#!/usr/bin/env bash
# Hook PreToolUse (Bash e PowerShell) condiviso dal gruppo: applica la decisione
# sul flusso Git prima che il comando arrivi a git o a GitHub.
# Blocca (exit 2, messaggio a Claude su stderr):
#   - commit, merge, push, rebase, cherry-pick, revert, am mentre si è su main o dev;
#   - push espliciti verso main o dev da qualunque branch;
#   - gh pr merge: le PR le unisce una persona, da GitHub, dopo l'approvazione.
# Volutamente senza jq o python: deve funzionare su Windows (Git Bash), macOS e Linux.

input="$(cat)"

blocca() {
  echo "BLOCCATO dalle regole del gruppo (CLAUDE.md, sezione Git): $1" >&2
  exit 2
}

# Unire una PR spetta a una persona dopo l'approvazione, non a Claude.
if printf '%s' "$input" | grep -Eq 'gh +pr +merge'; then
  blocca "Claude non unisce le Pull Request. Segnala all'utente che la PR è pronta: la unisce una persona da GitHub dopo l'approvazione."
fi

# Push esplicito verso main o dev (es. 'git push origin dev', 'git push origin HEAD:main').
if printf '%s' "$input" | grep -Eq 'git +push[^;&|]*[ :+](main|dev)([ "\\;&|]|$)'; then
  blocca "niente push diretti su main o dev. Lavora su un branch feature/, fix/, docs/ o chore/ e apri una PR verso dev."
fi

# Operazioni che scrivono la storia mentre si è su main o dev.
dir="${CLAUDE_PROJECT_DIR:-.}"
branch="$(git -C "$dir" branch --show-current 2>/dev/null)"
if [ "$branch" = "main" ] || [ "$branch" = "dev" ]; then
  if printf '%s' "$input" | grep -Eq 'git +(-C +[^ ]+ +)?(commit|merge|push|rebase|cherry-pick|revert|am)( |"|$)'; then
    blocca "sei su '$branch', dove non si scrive direttamente. Crea prima un branch da dev (es. 'git switch -c feature/<componente>-<descrizione>') e lavora lì."
  fi
fi

exit 0
