#!/usr/bin/env bash
set -euo pipefail

# PATH에 ffmpeg/ffprobe가 잡히도록
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

LOG="/opt/homebrew/var/transmission/post-encode.log"
log(){ printf '[%s] %s\n' "$(date '+%F %T')" "$*" >> "$LOG"; }

TORRENT_DIR="${TR_TORRENT_DIR:-}"
TORRENT_NAME="${TR_TORRENT_NAME:-}"

[ -n "$TORRENT_DIR" ] && [ -n "$TORRENT_NAME" ] || {
  log "Missing env (TR_TORRENT_DIR/TR_TORRENT_NAME). Exit."
  exit 0
}

TARGET_PATH="$TORRENT_DIR/$TORRENT_NAME"

encode_one() {
  in="$1"
  ext="${in##*.}"
  lext="$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')"
  case "$lext" in mkv|mp4|m4v|mov) ;; *) return 0 ;; esac

  # 이미 h264면 스킵
  vcodec="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name \
           -of csv=p=0 "$in" || true)"
  if [ "$vcodec" = "h264" ] || [ "$vcodec" = "avc1" ]; then
    log "Skip (already h264): $in"
    return 0
  fi

  base="${in%.*}"
  out="${base}.x264.${lext}"
  [ -e "$out" ] && { log "Exists, skip: $out"; return 0; }

  log "Start: $in -> $out"
  if [ "$lext" = "mp4" ] || [ "$lext" = "m4v" ]; then
    nice -n 10 ffmpeg -hide_banner -y -i "$in" -map 0 \
      -c:v libx264 -preset slow -crf 20 \
      -c:a copy -c:s copy -movflags +faststart \
      -max_muxing_queue_size 9999 "$out"
  else
    nice -n 10 ffmpeg -hide_banner -y -i "$in" -map 0 \
      -c:v libx264 -preset slow -crf 20 \
      -c:a copy -c:s copy \
      -max_muxing_queue_size 9999 "$out"
  fi
  log "Done: $out"
}

if [ -d "$TARGET_PATH" ]; then
  # 토렌트가 폴더일 때 내부 영상 전부 처리
  find "$TARGET_PATH" -type f \( -iname "*.mkv" -o -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.mov" \) -print0 \
    | while IFS= read -r -d '' f; do encode_one "$f"; done
else
  encode_one "$TARGET_PATH"
fi
