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
  time="$(date +%Y%m%d%H%M%S)"
  if [ "$(uname -s)" != "Darwin" ]; then
    _red "Unsupported operating system, Darwin?";
    return 1;
  fi

  gitRepositoryPath=""
  while true; do
    read -p "Input git repository path: " gitRepositoryPath
    if [ ! -d ${gitRepositoryPath} ]; then
      _red "Git repository path not found!"
    elif [ ! -d "${gitRepositoryPath}/.git" ]; then 
      _red "Dir .git not find, Please git init first?"
    else
      break
    fi
  done

  if [ -f "${gitRepositoryPath}/.git/hooks/commit-msg" ]; then
    mv ${gitRepositoryPath}/.git/hooks/commit-msg ${gitRepositoryPath}/.git/hooks/commit-msg.bak.${time};
  fi

  cp -r commit-msg ${gitRepositoryPath}/.git/hooks/commit-msg
  chmod +x ${gitRepositoryPath}/.git/hooks/commit-msg
  _green "commit-msg hook Install Success!\n"

  isGolangProgram=0
  while true; do
    read -p "Is golang program? (y/N)" readIsGolangProgram
    case ${readIsGolangProgram} in
      'Y'|'y')
        isGolangProgram=1
        break;;
      'N'|'n'|'')
        isGolangProgram=0
        break;;
      *);;
    esac
  done

  if [[ ${isGolangProgram} -eq 1 ]]; then
    if [ -f "${gitRepositoryPath}/.git/hooks/pre-commit" ]; then
      mv ${gitRepositoryPath}/.git/hooks/pre-commit ${gitRepositoryPath}/.git/hooks/pre-commit.bak.${time};
    fi
    cp -r pre-commit-golang ${gitRepositoryPath}/.git/hooks/pre-commit
    chmod +x ${gitRepositoryPath}/.git/hooks/pre-commit
    _green "golang pre-commit hook Install Success!\n"
  fi
}

main "$@"