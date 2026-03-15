{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      sandboxTools = with pkgs; [
        gemini-cli
        ripgrep
        fd
        nodejs
        (python3.withPackages (ps: with ps; [ fastmcp ]))
        jq
        bash
        coreutils
        cacert
      ];

      sandboxEnv = pkgs.buildEnv {
        name = "gemini-sandbox-env";
        paths = sandboxTools;
      };

      settingsJson = pkgs.writeText "gemini-settings.json" ''
        {
          "mcpServers": {
            "project-tools": {
              "command": "python3",
              "args": ["mcp_tools.py"]
            }
          },
          "security": {
            "folderTrust": {
              "enabled": false
            },
            "auth": {
              "selectedType": "gemini-api-key"
            }
          }
        }
      '';

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = sandboxTools ++ (with pkgs; [ bubblewrap ]);

        SANDBOX_ENV_PATH = "${sandboxEnv}";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        GEMINI_CLI_SYSTEM_SETTINGS_PATH = "${settingsJson}";
      };
    };
}