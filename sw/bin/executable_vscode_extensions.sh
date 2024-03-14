#!/bin/bash

# execute command
# -------------------
# curl -s https://raw.githubusercontent.com/karaage0703/vscode-dotfiles/master/install-vscode-extensions.sh | /bin/bash

# Visual Studio Code :: Package list
pkglist=(
	1yib.rust-bundle
	dbaeumer.vscode-eslint
	dustypomerleau.rust-syntax
	evgeniypeshkov.syntax-highlighter
	github.copilot
	github.copilot-chat
	golang.go
	ms-azuretools.vscode-docker
	ms-python.debugpy
	ms-python.python
	ms-python.vscode-pylance
	ms-vscode-remote.remote-containers
	ms-vscode.extension-test-runner
	rust-lang.rust-analyzer
	serayuzgur.crates
	sumneko.lua
)

for i in "${pkglist[@]}"; do
	code --install-extension $i
done
