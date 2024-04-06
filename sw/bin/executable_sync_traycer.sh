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

pushd ~/Work/traycerai/traycer >/dev/null || exit 1
npm install && npm run build
popd >/dev/null || exit 1

pushd ~/Work/traycerai/traycer/code-explorer-agent >/dev/null || exit 1
npm run local_deploy
popd >/dev/null || exit 1
