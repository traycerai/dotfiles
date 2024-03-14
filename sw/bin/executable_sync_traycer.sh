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
