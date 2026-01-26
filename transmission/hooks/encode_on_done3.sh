#!/usr/bin/env bash
# Transmission "torrent-done" hook
# - 직렬 처리(동시 1개) + Apple VT 인코더 우선, 실패 시 x264 폴백
# - 재인코딩 트리거: 비-H.264, 비 yuv420p, level>4.1 또는 N/A, VFR(avg!=r), SAR!=1:1
# - 오디오는 aac/ac3/mp3면 copy, 그 외는 AAC 2ch 변환
# - 안전하면 무손실 리먹스(+faststart)
# - Bash 3.2 호환

set -Eeuo pipefail

############################
# 사용자 조정값
############################
OUT_SUFFIX=".tv.mp4"

# Apple VT 품질/속도(1080p 기준 무난)
VT_BV="4M"         # 평균 비트레이트
VT_MAX="6M"        # 최대 비트레이트
VT_BUF="12M"       # VBV 버퍼
VT_GOP="120"       # 약 4초@29.97fps

# x264 폴백(빠르고 충분히 괜찮게)
X264_PRESET="veryfast"
X264_CRF="23"

SAFE_FPS="30000/1001"   # 29.97 CFR
SAFE_LEVEL=41           # 4.1 (ffprobe는 41/42/51 같은 숫자)
LOG="/opt/homebrew/var/transmission/post-encode.log"
#
# ⬇ 여기가 새로 추가된 목적지
DEST_DIR="/Users/utylee/Volumes/8001/98-dlna"
mkdir -p "$DEST_DIR"

# PATH (ffmpeg/ffprobe)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

# 로그 수집
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
ts(){ date '+%F %T'; }

echo "[$(ts)] --- START --- PID=$$"

trap 'echo "[$(ts)] ERR line:$LINENO cmd:$BASH_COMMAND"' ERR
trap 'echo "[$(ts)] --- END (status:$?) ---"' EXIT

############################
# 직렬 락 (동시 한 개만 인코딩)
############################
LOCK="/tmp/tr_encode.lock"
while ! mkdir "$LOCK" 2>/dev/null; do
  echo "[$(ts)] Another encode running; wait..."
  sleep 1
done
cleanup_lock(){ rmdir "$LOCK" 2>/dev/null || true; }
trap 'cleanup_lock' EXIT

############################
# 유틸
############################
lc(){ printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

probe_video_csv(){  # codec_name,level,pix_fmt,avg_frame_rate,r_frame_rate,sample_aspect_ratio
  ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_name,level,pix_fmt,avg_frame_rate,r_frame_rate,sample_aspect_ratio \
    -of csv=p=0 "$1" 2>/dev/null || true
}
probe_audio_codec(){ # 첫 오디오 코덱명
  ffprobe -v error -select_streams a:0 -show_entries stream=codec_name \
    -of csv=p=0 "$1" 2>/dev/null | head -n1 || true
}

############################
# 판단 로직
############################
# 반환: 0=재인코딩 필요, 1=불필요
video_needs_transcode(){
  local f="$1"
  local vcodec level pix avg r sar
  IFS=, read -r vcodec level pix avg r sar < <(probe_video_csv "$f")
  echo "[$(ts)] META video: vcodec='${vcodec:-}' level='${level:-}' pix='${pix:-}' avg='${avg:-}' r='${r:-}' sar='${sar:-}'"

  local lcvcodec="$(lc "${vcodec:-}")"
  local lcpix="$(lc "${pix:-}")"

  # 코덱/픽셀포맷 기본 불일치 → 재인코딩
  { [[ "$lcvcodec" = "h264" || "$lcvcodec" = "avc1" ]]; } || return 0
  [[ "$lcpix" = "yuv420p" ]] || return 0

  # 레벨: 비어있음/N/A/비숫자 → 재인코딩, 숫자면 >4.1이면 재인코딩
  if [[ -z "${level:-}" || "$level" = "N/A" || ! "$level" =~ ^[0-9]+$ ]]; then
    return 0
  fi
  if (( level > SAFE_LEVEL )); then
    return 0
  fi

  # VFR: avg != r → 재인코딩
  if [[ -n "${avg:-}" && -n "${r:-}" && "$avg" != "$r" ]]; then
    return 0
  fi

  # SAR: 1:1 아니면 재인코딩
  if [[ -n "${sar:-}" && "$sar" != "1:1" ]]; then
    return 0
  fi

  # 모두 통과 → 재인코딩 불필요
  return 1
}

# 반환: 0=오디오 AAC 변환 필요, 1=복사 가능
audio_needs_aac(){
  local f="$1" ac
  ac="$(probe_audio_codec "$f")"
  ac="$(lc "${ac:-}")"
  echo "[$(ts)] META audio: codec='${ac:-none}'"
  case "$ac" in
    aac|ac3|mp3) return 1 ;;
    *)           return 0 ;;
  esac
}

############################
# 작업 함수
############################
encode_video_only(){  # VT 우선, 실패 시 x264 폴백
  local in="$1" out="$2" do_aac="$3"
  local aopts="-c:a copy"; [[ "$do_aac" = "yes" ]] && aopts="-c:a aac -ac 2 -b:a 160k"

  echo "[$(ts)] FFMPEG encode (videotoolbox) -> '$out' (aac:$do_aac)"
  if nice -n 10 ffmpeg -loglevel info -stats -hide_banner -y -i "$in" -map 0 \
      -vf "setsar=1,fps=${SAFE_FPS}" \
      -c:v h264_videotoolbox -profile:v high -level 4.1 -pix_fmt yuv420p \
      -b:v "$VT_BV" -maxrate "$VT_MAX" -bufsize "$VT_BUF" -g "$VT_GOP" -tag:v avc1 \
      $aopts -c:s copy -movflags +faststart "$out"; then
    echo "[$(ts)] VT encode OK -> $out"
  else
    echo "[$(ts)] VT encode FAILED -> fallback to libx264"
    nice -n 10 ffmpeg -loglevel info -stats -hide_banner -y -i "$in" -map 0 \
      -vf "setsar=1,fps=${SAFE_FPS}" \
      -c:v libx264 -pix_fmt yuv420p -profile:v high -level:v 4.1 \
      -x264-params ref=3:bframes=2:b-pyramid=none:open-gop=0 \
      -crf "$X264_CRF" -preset "$X264_PRESET" \
      $aopts -c:s copy -movflags +faststart -max_muxing_queue_size 9999 "$out"
  fi
}

remux_copy(){  # 무손실 리먹스(+faststart), 오디오는 필요 시 AAC
  local in="$1" out="$2" do_aac="$3"
  local aopts="-c:a copy"; [[ "$do_aac" = "yes" ]] && aopts="-c:a aac -ac 2 -b:a 160k"
  echo "[$(ts)] FFMPEG remux -> '$out' (aac:$do_aac)"
  nice -n 10 ffmpeg -loglevel info -stats -hide_banner -y -i "$in" -map 0 \
    -c:v copy $aopts -c:s copy -movflags +faststart "$out"
}

process_one(){
  local in="$1"
  [[ -f "$in" ]] || return 0

  case "${in##*.}" in
    mkv|MKV|mp4|MP4|m4v|M4V|mov|MOV) ;;
    *) echo "[$(ts)] Skip(ext): $in"; return 0 ;;
  esac

  local out="${in%.*}${OUT_SUFFIX}"
  if [[ -e "$out" ]]; then
    echo "[$(ts)] Exists -> $out (skip)"
    return 0
  fi

  local need_aac="no"; if audio_needs_aac "$in"; then need_aac="yes"; fi

  if video_needs_transcode "$in"; then
    echo "[$(ts)] DECISION: video=TRANSCODE, audio_aac=${need_aac}"
    encode_video_only "$in" "$out" "$need_aac"
  else
    echo "[$(ts)] DECISION: video=COPY(remux), audio_aac=${need_aac}"
    remux_copy "$in" "$out" "$need_aac"
  fi

  echo "[$(ts)] Done -> $out"

  # ------------------------------------
  # 🔥 인코딩 완료 후 파일 이동
  # ------------------------------------
  final_path="$DEST_DIR/$(basename "$out")"
  mv "$out" "$final_path"
  log "Moved encoded file to: $final_path"
}

process_target(){
  local p="$1"
  if [[ -d "$p" ]]; then
    echo "[$(ts)] Target=dir -> $p"
    find "$p" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mov" \) -print0 \
      | while IFS= read -r -d '' f; do process_one "$f"; done
  else
    echo "[$(ts)] Target=file -> $p"
    process_one "$p"
  fi
}

############################
# Transmission env
############################
TORRENT_DIR="${TR_TORRENT_DIR:-}"
TORRENT_NAME="${TR_TORRENT_NAME:-}"
echo "[$(ts)] TR_TORRENT_DIR='$TORRENT_DIR' TR_TORRENT_NAME='$TORRENT_NAME'"
if [[ -z "$TORRENT_DIR" || -z "$TORRENT_NAME" ]]; then
  echo "[$(ts)] Missing TR_TORRENT_* env; exit."
  exit 0
fi

TARGET_PATH="$TORRENT_DIR/$TORRENT_NAME"


process_target "$TARGET_PATH"

##!/usr/bin/env bash
## TV-safe 자동화 훅 (Bash 3.2 호환)
#set -Eeuo pipefail

#OUT_SUFFIX=".tv.mp4"
#X264_PRESET="slow"
#X264_CRF="20"
#SAFE_FPS="30000/1001"
#SAFE_LEVEL=41
#AUDIO_OK_REGEX='^(aac|ac3|mp3)$'

#export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
#LOG="/opt/homebrew/var/transmission/post-encode.log"
#mkdir -p "$(dirname "$LOG")"
#exec >>"$LOG" 2>&1

#ts(){ date '+%F %T'; }
#echo "[$(ts)] --- START --- PID=$$"
#trap 'echo "[$(ts)] ERR line:$LINENO cmd:$BASH_COMMAND"' ERR
#trap 'echo "[$(ts)] --- END (status:$?) ---"' EXIT

## 소문자 변환( Bash 3.2 호환 )
#lc(){ printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

#TORRENT_DIR="${TR_TORRENT_DIR:-}"
#TORRENT_NAME="${TR_TORRENT_NAME:-}"
#echo "[$(ts)] TR_TORRENT_DIR='$TORRENT_DIR' TR_TORRENT_NAME='$TORRENT_NAME'"
#[[ -n "$TORRENT_DIR" && -n "$TORRENT_NAME" ]] || exit 0
#TARGET_PATH="$TORRENT_DIR/$TORRENT_NAME"

#probe_video_csv(){
#  ffprobe -v error -select_streams v:0 \
#    -show_entries stream=codec_name,level,pix_fmt,avg_frame_rate,r_frame_rate,sample_aspect_ratio \
#    -of csv=p=0 "$1" 2>/dev/null || true
#}
#probe_audio_codec(){
#  ffprobe -v error -select_streams a:0 -show_entries stream=codec_name \
#    -of csv=p=0 "$1" 2>/dev/null | head -n1 || true
#}

## 비디오가 재인코딩이 필요한가? (0=필요, 1=불필요)
#video_needs_transcode(){
#  local f="$1"
#  local vcodec level pix avg r sar
#  IFS=, read -r vcodec level pix avg r sar < <(probe_video_csv "$f")
#  echo "[$(ts)] META video: vcodec='${vcodec:-}' level='${level:-}' pix='${pix:-}' avg='${avg:-}' r='${r:-}' sar='${sar:-}'"

#  # 소문자 변환(Bash 3.2 호환)
#  local lcvcodec="$(lc "${vcodec:-}")"
#  local lcpix="$(lc "${pix:-}")"

#  # 0) 코덱/픽셀포맷 기본 체크
#  { [[ "$lcvcodec" = "h264" || "$lcvcodec" = "avc1" ]]; } || return 0
#  [[ "$lcpix" = "yuv420p" ]] || return 0

#  # 1) 레벨 체크: 비어있거나 N/A거나 "숫자 아님"이면 재인코딩
#  if [[ -z "${level:-}" || "$level" = "N/A" || ! "$level" =~ ^[0-9]+$ ]]; then
#    return 0
#  fi
#  # 숫자일 때만 비교
#  if (( level > SAFE_LEVEL )); then
#    return 0
#  fi

#  # 2) VFR: avg_frame_rate != r_frame_rate 이면 재인코딩
#  if [[ -n "${avg:-}" && -n "${r:-}" && "$avg" != "$r" ]]; then
#    return 0
#  fi

#  # 3) SAR != 1:1 이면 재인코딩
#  if [[ -n "${sar:-}" && "$sar" != "1:1" ]]; then
#    return 0
#  fi

#  # 모두 통과 → 재인코딩 불필요
#  return 1
#}

## video_needs_transcode(){ # 0=필요, 1=불필요
##   local f="$1"
##   local vcodec level pix avg r sar
##   IFS=, read -r vcodec level pix avg r sar < <(probe_video_csv "$f")
##   echo "[$(ts)] META video: vcodec='${vcodec:-}' level='${level:-}' pix='${pix:-}' avg='${avg:-}' r='${r:-}' sar='${sar:-}'"

##   local lcvcodec="$(lc "${vcodec:-}")"
##   local lcpix="$(lc "${pix:-}")"

##   # 비-H.264 또는 비 yuv420p → 재인코딩
##   { [[ "$lcvcodec" = "h264" || "$lcvcodec" = "avc1" ]]; } || return 0
##   [[ "$lcpix" = "yuv420p" ]] || return 0

##   # 레벨 > 4.1
##   if [[ -n "${level:-}" ]] && (( level > SAFE_LEVEL )); then return 0; fi
##   # VFR (avg != r)
##   if [[ -n "${avg:-}" && -n "${r:-}" && "$avg" != "$r" ]]; then return 0; fi
##   # SAR != 1:1
##   if [[ -n "${sar:-}" && "$sar" != "1:1" ]]; then return 0; fi

##   return 1
## }

#audio_needs_aac(){ # 0=변환, 1=복사
#  local f="$1" ac
#  ac="$(probe_audio_codec "$f")"
#  echo "[$(ts)] META audio: codec='${ac:-none}'"
#  [[ "$ac" =~ $AUDIO_OK_REGEX ]] && return 1 || return 0
#}

#encode_video_only(){ # 비디오만 x264
#  local in="$1" out="$2" do_aac="$3"
#  local aopts="-c:a copy"; [[ "$do_aac" = "yes" ]] && aopts="-c:a aac -ac 2 -b:a 192k"
#  echo "[$(ts)] FFMPEG encode video -> '$out' (aac:$do_aac)"
#  nice -n 10 ffmpeg -loglevel info -stats -hide_banner -y -i "$in" -map 0 \
#    -vf "setsar=1,fps=${SAFE_FPS}" \
#    -c:v libx264 -pix_fmt yuv420p -profile:v high -level:v 4.1 \
#    -x264-params ref=4:bframes=3:b-pyramid=none:open-gop=0 \
#    -crf "$X264_CRF" -preset "$X264_PRESET" \
#    $aopts -c:s copy -movflags +faststart -max_muxing_queue_size 9999 "$out"
#}

#remux_copy(){ # 무손실 리먹스(+faststart)
#  local in="$1" out="$2" do_aac="$3"
#  local aopts="-c:a copy"; [[ "$do_aac" = "yes" ]] && aopts="-c:a aac -ac 2 -b:a 192k"
#  echo "[$(ts)] FFMPEG remux -> '$out' (aac:$do_aac)"
#  nice -n 10 ffmpeg -loglevel info -stats -hide_banner -y -i "$in" -map 0 \
#    -c:v copy $aopts -c:s copy -movflags +faststart "$out"
#}

#process_one(){
#  local in="$1"
#  [[ -f "$in" ]] || return 0
#  case "${in##*.}" in mkv|MKV|mp4|MP4|m4v|M4V|mov|MOV) ;; *) echo "[$(ts)] Skip(ext): $in"; return 0 ;; esac
#  local out="${in%.*}${OUT_SUFFIX}"
#  [[ -e "$out" ]] && { echo "[$(ts)] Exists -> $out"; return 0; }

#  local need_aac="no"; if audio_needs_aac "$in"; then need_aac="yes"; fi

#  if video_needs_transcode "$in"; then
#    echo "[$(ts)] DECISION: video=TRANSCODE, audio_aac=${need_aac}"
#    encode_video_only "$in" "$out" "$need_aac"
#  else
#    echo "[$(ts)] DECISION: video=COPY, audio_aac=${need_aac}"
#    remux_copy "$in" "$out" "$need_aac"
#  fi
#  echo "[$(ts)] Done -> $out"
#}

#process_target(){
#  local p="$1"
#  if [[ -d "$p" ]]; then
#    echo "[$(ts)] Target=dir -> $p"
#    find "$p" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mov" \) -print0 \
#      | while IFS= read -r -d '' f; do process_one "$f"; done
#  else
#    echo "[$(ts)] Target=file -> $p"
#    process_one "$p"
#  fi
#}

#process_target "$TARGET_PATH"
