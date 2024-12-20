#!/usr/bin/env bash

gh_clone_all.sh traycerai ~/Work
pull_all.sh ~/Work/traycerai

PRECOMMIT_DIRS=(
  ~/Work/traycerai/traycer
)

for dir in "${PRECOMMIT_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "Installing precommit hooks in $dir"
    pushd "$dir" >/dev/null || continue
    pre-commit install --hook-type={pre-commit,commit-msg,prepare-commit-msg}
    pre-commit install-hooks
    popd >/dev/null || continue
  fi
done

deploy_if_on_main() {
  pushd "$1" >/dev/null || exit 1
  if [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ]; then
    eval "$2"
  fi
  popd >/dev/null || exit 1
}

deploy_if_on_main ~/Work/traycerai/traycer "npm install && npm run build"
deploy_if_on_main ~/Work/traycerai/traycer/code-explorer-agent "npm run staging_deploy"
