#!/bin/bash
cd ~
mkdir -p .local/bin
echo "export PATH=\$PATH:\$HOME/.local/bin" >> .bashrc
curl -L https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest/download-by-type/file/binary-dist > .local/bin/.nix-wrapped
chmod +x .local/bin/.nix-wrapped
