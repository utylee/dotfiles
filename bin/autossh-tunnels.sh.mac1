#!/bin/zsh
set -eu

# ---- config ----
AUTOSSH_BIN="/opt/homebrew/bin/autossh"
SSH_HOST="utylee@192.168.1.202"
SSH_PORT="8822"

# autossh options (기존 plist와 동일 + 안정 옵션 추가)
OPTS=(
  -M 0
  -N
  -p "$SSH_PORT"

  -o "ServerAliveInterval=10"
  -o "ServerAliveCountMax=2"
  -o "TCPKeepAlive=yes"
  -o "ExitOnForwardFailure=yes"
  -o "ConnectTimeout=5"
  -o "ConnectionAttempts=1"

  -R "127.0.0.1:13300:localhost:3000"
  -R "0.0.0.0:8817:localhost:8817"
  -R "0.0.0.0:11434:localhost:11434"   # ollama
  -R "0.0.0.0:11234:localhost:11234"   # lm studio
  -R "0.0.0.0:8087:localhost:8080"     # llama.cpp
  -R "0.0.0.0:1445:localhost:445"      # smb
)

LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/autossh-tunnels.log"

mkdir -p "$LOG_DIR"

# autossh env: 빨리 반응하게
export AUTOSSH_GATETIME=0
export AUTOSSH_POLL=30
export AUTOSSH_FIRST_POLL=10

log() { print -r -- "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"; }

# 네트워크가 "Reachable" 될 때까지 대기
wait_network() {
  while true; do
    # scutil reachability: "Reachable" 포함 여부로 판단
    if /usr/sbin/scutil -r "1.1.1.1" 2>/dev/null | /usr/bin/grep -q "Reachable"; then
      return 0
    fi
    log "network not reachable yet; sleep 3"
    sleep 3
  done
}

# 터널이 '살아있는 척' 하며 멈춘 상태 감지용 헬스체크
# - SSH 자체가 안 되면 autossh를 강제 재시작시키는 트리거로 사용
health_check() {
  /usr/bin/ssh \
    -p "$SSH_PORT" \
    -o "BatchMode=yes" \
    -o "ConnectTimeout=5" \
    -o "ConnectionAttempts=1" \
    -o "ServerAliveInterval=5" \
    -o "ServerAliveCountMax=1" \
    "$SSH_HOST" "true" >/dev/null 2>&1
}

main_loop() {
  while true; do
    wait_network
    log "starting autossh…"
    "$AUTOSSH_BIN" "${OPTS[@]}" "$SSH_HOST" >>"$LOG_FILE" 2>&1 &
    PID=$!
    log "autossh pid=$PID"

    fail=0
    while kill -0 "$PID" 2>/dev/null; do
      sleep 15

      # 네트워크가 끊기면 프로세스는 살아도 세션이 꼬일 수 있어서 적극적으로 재시작
      if ! /usr/sbin/scutil -r "1.1.1.1" 2>/dev/null | /usr/bin/grep -q "Reachable"; then
        log "network lost → kill autossh"
        kill "$PID" 2>/dev/null || true
        wait "$PID" 2>/dev/null || true
        break
      fi

      if health_check; then
        fail=0
      else
        fail=$((fail+1))
        log "health_check failed ($fail/3)"
        if [ "$fail" -ge 3 ]; then
          log "health_check failed 3 times → restart autossh"
          kill "$PID" 2>/dev/null || true
          wait "$PID" 2>/dev/null || true
          break
        fi
      fi
    done

    log "autossh exited; cool down 2s"
    sleep 2
  done
}

main_loop

