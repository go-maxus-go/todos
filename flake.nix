{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.gemini-cli;

      apps.${system}.default = {
        type = "app";
        program = "${pkgs.gemini-cli}/bin/gemini";
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          gemini-cli
          ripgrep
          fd
          git
          nodejs
          python3
          jq
        ];

        shellHook = ''
        '';
      };
    };
}
