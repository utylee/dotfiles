#!/bin/zsh
set -eu

# ---- config ----
AUTOSSH_BIN="/opt/homebrew/bin/autossh"
SSH_HOST="utylee@192.168.1.202"
SSH_PORT="8822"

CHECK_INTERVAL=60
FAIL_LIMIT=3
COOLDOWN=5

OPTS=(
  -M 0
  -N
  -p "$SSH_PORT"

  -o "ServerAliveInterval=10"
  -o "ServerAliveCountMax=3"
  -o "TCPKeepAlive=yes"
  -o "ExitOnForwardFailure=yes"
  -o "ConnectTimeout=5"
  -o "ConnectionAttempts=1"

  -R "127.0.0.1:13300:localhost:3000"
  -R "0.0.0.0:8817:localhost:8817"
  -R "0.0.0.0:8187:localhost:8188"
  -R "0.0.0.0:11434:localhost:11434"
  -R "0.0.0.0:11234:localhost:11234"
  -R "0.0.0.0:8087:localhost:8080"
  -R "0.0.0.0:1445:localhost:445"
  -R "0.0.0.0:21117:localhost:21118"
)

LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/autossh-tunnels.log"

mkdir -p "$LOG_DIR"

export AUTOSSH_GATETIME=0
export AUTOSSH_POLL=30
export AUTOSSH_FIRST_POLL=10

log() {
  print -r -- "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

network_ok() {
  /usr/bin/nc -z -G 3 192.168.1.202 "$SSH_PORT" >/dev/null 2>&1
}

wait_network() {
  while true; do
    if network_ok; then
      return 0
    fi

    log "202:$SSH_PORT not reachable yet; sleep 3"
    sleep 3
  done
}

health_check() {
  /usr/bin/ssh \
    -p "$SSH_PORT" \
    -o "BatchMode=yes" \
    -o "ConnectTimeout=5" \
    -o "ConnectionAttempts=1" \
    -o "ServerAliveInterval=5" \
    -o "ServerAliveCountMax=1" \
    "$SSH_HOST" \
    "nc -z -w 3 127.0.0.1 8817" \
    >/dev/null 2>&1
}

restart_autossh() {
  local pid="$1"
  local child_pids=""

  child_pids="$(pgrep -P "$pid" 2>/dev/null || true)"

  log "stopping autossh pid=$pid children=${child_pids:-none}"

  # autossh부터 종료해 child 재생성을 막음
  kill "$pid" 2>/dev/null || true

  # 기존 ssh child도 같이 종료
  if [[ -n "$child_pids" ]]; then
    for child in ${(f)child_pids}; do
      kill "$child" 2>/dev/null || true
    done
  fi

  # 최대 5초 동안 정상 종료 대기
  for i in {1..5}; do
    local alive=0

    kill -0 "$pid" 2>/dev/null && alive=1

    if [[ -n "$child_pids" ]]; then
      for child in ${(f)child_pids}; do
        kill -0 "$child" 2>/dev/null && alive=1
      done
    fi

    if (( ! alive )); then
      wait "$pid" 2>/dev/null || true
      log "autossh/ssh stopped cleanly"
      return 0
    fi

    sleep 1
  done

  log "autossh/ssh still alive -> SIGKILL"

  kill -9 "$pid" 2>/dev/null || true

  if [[ -n "$child_pids" ]]; then
    for child in ${(f)child_pids}; do
      kill -9 "$child" 2>/dev/null || true
    done
  fi

  wait "$pid" 2>/dev/null || true
}

main_loop() {
  while true; do
    wait_network

    log "starting autossh..."

    "$AUTOSSH_BIN" "${OPTS[@]}" "$SSH_HOST" >>"$LOG_FILE" 2>&1 &
    PID=$!

    log "autossh pid=$PID"

    fail=0

    while kill -0 "$PID" 2>/dev/null; do
      sleep "$CHECK_INTERVAL"

      if ! network_ok; then
        log "202:$SSH_PORT unreachable -> restart autossh"
        restart_autossh "$PID"
        break
      fi

      if health_check; then
        fail=0
      else
        fail=$((fail + 1))
        log "health_check failed ($fail/$FAIL_LIMIT)"

        if [ "$fail" -ge "$FAIL_LIMIT" ]; then
          log "health_check failed $FAIL_LIMIT times -> restart autossh"
          restart_autossh "$PID"
          break
        fi
      fi
    done

    wait "$PID" 2>/dev/null || true

    log "autossh exited; cool down ${COOLDOWN}s"
    sleep "$COOLDOWN"
  done
}

main_loop
