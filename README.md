Install nix package manager from https://nixos.org/download/

Install direnv and nix-direnv via nix

nix profile add nixpkgs#direnv nixpkgs#nix-direnv


Add the line below to ~/.bashrc

eval "$(direnv hook bash)"


Enable nix flakes and nix command by adding this line

experimental-features = nix-command flakes

to ~/.config/nix/nix.conf


Execute in this folder:

direnv allow