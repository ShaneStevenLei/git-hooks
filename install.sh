#!/bin/sh

set -e

_green() {
  printf '\033[1;31;32m%b\033[0m\n' "$1"
}

_red() {
  printf '\033[1;31;40m%b\033[0m\n' "$1"
}

_exists() {
  cmd="$1"
  if [ -z "$cmd" ]; then
    _red "Usage: _exists cmd"
    return 1
  fi

  if eval type type >/dev/null 2>&1; then
    eval type "$cmd" >/dev/null 2>&1
  elif command >/dev/null 2>&1; then
    command -v "$cmd" >/dev/null 2>&1
  else
    which "$cmd" >/dev/null 2>&1
  fi
  return "$?"
}

main() {
  time=`$(date +%Y%m%d%H%M%S)`
  if [ "$(uname -s)" != "Darwin" ]; then
    _red "Unsupported operating system, Darwin?";
    return 1;
  fi

  if [ ! -d ".git" ]; then 
    _red "Dir .git not find, Please git init first?";
    return 1;
  fi

  if [ -f .git/hooks/pre-commit ]; then
    mv .git/hooks/pre-commit .git/hooks/pre-commit.bak.${time};
  fi

  if [ -f .git/hooks/commit-msg ]; then
    mv .git/hooks/commit-msg .git/hooks/commit-msg.bak.${time};
  fi

  curl https://raw.githubusercontent.com/ShaneStevenLei/git-hooks/main/git-commit-msg -o .git/hooks/commit-msg
  chmod +x .git/hooks/commit-msg
    _green "commit-msg hook Install Success!"

  isGolangProgram = false
  while 1; do
    read -p "Is golang program? (y/N)" readIsGolangProgram
    case ${isGolangProgram} in
      'Y'|'y')
        isGolangProgram = true
        break;;
      'N'|'n')
        isGolangProgram = false
        break;;
      *);;
    esac
  done

  if [[ ${isGolangProgram} ]]; then
    curl https://raw.githubusercontent.com/ShaneStevenLei/git-hooks/main/pre-commit-golang -o .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    _green "golang pre-commit hook Install Success!"
  fi
}

main "$@"