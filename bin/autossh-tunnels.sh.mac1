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
  -R "0.0.0.0:8187:localhost:8188"      #comfyui
  -R "0.0.0.0:11434:localhost:11434"   # ollama
  -R "0.0.0.0:11234:localhost:11234"   # lm studio
  -R "0.0.0.0:8087:localhost:8080"     # llama.cpp
  -R "0.0.0.0:1445:localhost:445"      # smb
  -R "0.0.0.0:21117:localhost:21118"    # Rustdesk
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

# 실제 reverse tunnel(8817)이 HC1에 올라와 있는지 확인
# - HC1 SSH 접속 자체만 확인하면 reverse tunnel이 죽어도 정상으로 오인할 수 있음
health_check() {
  /usr/bin/ssh \
    -p "$SSH_PORT" \
    -o "BatchMode=yes" \
    -o "ConnectTimeout=5" \
    -o "ConnectionAttempts=1" \
    -o "ServerAliveInterval=5" \
    -o "ServerAliveCountMax=1" \
    "$SSH_HOST" \
    "ss -lnt | grep -q ':8817 '" \
    >/dev/null 2>&1
}

# autossh를 정상 종료시키고, 그래도 남아 있으면 강제 종료
restart_autossh() {
  local pid="$1"

  log "stopping autossh pid=$pid"
  kill "$pid" 2>/dev/null || true

  for i in {1..5}; do
    if ! kill -0 "$pid" 2>/dev/null; then
      wait "$pid" 2>/dev/null || true
      return 0
    fi
    sleep 1
  done

  log "autossh still alive -> SIGKILL pid=$pid"
  kill -9 "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
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
        restart_autossh "$PID"
        break
      fi

      if health_check; then
        fail=0
      else
        fail=$((fail+1))
        log "health_check failed ($fail/3)"
        if [ "$fail" -ge 3 ]; then
          log "health_check failed 3 times → restart autossh"
          restart_autossh "$PID"
          break
        fi
      fi
    done

    log "autossh exited; cool down 2s"
    sleep 2
  done
}

main_loop

