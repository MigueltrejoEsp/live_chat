{
  description = "Development shell for the Live Chat project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [ 
        beamMinimal27Packages.erlang
        beamMinimal27Packages.elixir_1_19
          beamMinimal27Packages.elixir-ls

        nodejs
        esbuild
        tailwindcss_4

        docker_25
        docker-compose
      ];

      env = {
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "postgres";
        POSTGRES_HOST = "localhost";
        POSTGRES_DB = "liv_chat_dev";
        TAILWINDCSS_PATH="${pkgs.lib.getExe pkgs.tailwindcss_4}";
        TAILWINDCSS_VERSION="4.1.16";
        ESBUILD_PATH="${pkgs.lib.getExe pkgs.esbuild}";
        ESBUILD_VERSION="0.25.5";
      };

      shellHook = ''
        echo "############################################"
        echo "############################################"
        echo "###                                      ###"
        echo "###      LiveChat development shell      ###"
        echo "###                                      ###"
        echo "############################################"
        echo "############################################"
      '';
    };
  };
}