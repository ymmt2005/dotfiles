#!/usr/bin/env bash
# Claude Code statusLine command
# model(effort) | color-coded context usage | session cost | branch | dir

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
model=${model/ (1M context)/ 1M}  # "Opus 4.8 (1M context)" -> "Opus 4.8 1M"
effort=$(echo "$input" | jq -r '.effort.level // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
in_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
out_tok=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
win=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

sep=' \033[90m|\033[00m '
first=1
seg() { # seg <printf-fmt> [args...]
    [ "$first" -eq 1 ] && first=0 || printf "$sep"
    # shellcheck disable=SC2059
    printf "$@"
}

# --- model (+ effort) ---
if [ -n "$model" ]; then
    if [ -n "$effort" ]; then
        seg '\033[01;35m%s\033[00m \033[90m(%s)\033[00m' "$model" "$effort"
    else
        seg '\033[01;35m%s\033[00m' "$model"
    fi
fi

# --- context window: "ctx 16% (162k/1000k)" color-coded ---
if [ -n "$used_pct" ] && [ "$win" -gt 0 ]; then
    total_tok=$((in_tok + out_tok))
    pct_int=${used_pct%.*}
    if [ "$pct_int" -ge 80 ]; then color='\033[31m'   # red
    elif [ "$pct_int" -ge 60 ]; then color='\033[33m' # yellow
    else color='\033[32m'                             # green
    fi
    seg "${color}ctx %s%% (%sk/%sk)\033[00m" \
        "$pct_int" "$((total_tok / 1000))" "$((win / 1000))"
else
    # not populated until the first API response of the session
    seg '\033[90mctx –\033[00m'
fi

# --- rate limits: "5h 24% · 7d 41%" color-coded per window ---
pct_color() { # pct_color <pct> -> sets $color
    local p=${1%.*}
    if [ "$p" -ge 80 ]; then color='\033[31m'
    elif [ "$p" -ge 60 ]; then color='\033[33m'
    else color='\033[32m'
    fi
}
[ "$first" -eq 1 ] && first=0 || printf "$sep"
if [ -n "$rl_5h" ]; then
    pct_color "$rl_5h"
    printf "5h ${color}%s%%\033[00m" "${rl_5h%.*}"
else
    printf '\033[90m5h –\033[00m'
fi
printf ' \033[90m·\033[00m '
if [ -n "$rl_7d" ]; then
    pct_color "$rl_7d"
    printf "7d ${color}%s%%\033[00m" "${rl_7d%.*}"
else
    printf '\033[90m7d –\033[00m'
fi

# --- git branch ---
branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || true)
[ -n "$branch" ] && seg '\033[01;34m%s\033[00m' "$branch"

# --- dir (basename, dimmed) ---
[ -n "$cwd" ] && seg '\033[90m%s\033[00m' "$(basename "$cwd")"
