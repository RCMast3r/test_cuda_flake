{
  description = "A dev environment for PyTorch with CUDA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true; # CUDA is unfree software
            cudatoolkit = pkgs.cudatoolkit_11; # Specify the desired version of CUDA
          };
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.torchWithCuda
            # python3Packages.torchvision
            # Add other dependencies as needed
            cudatoolkit_11
          ];

          shellHook = ''
            export CUDA_HOME=${pkgs.cudatoolkit_11}
            export PATH=$CUDA_HOME/bin:$PATH
            export LD_LIBRARY_PATH=${pkgs.cudatoolkit_11}/lib64:$LD_LIBRARY_PATH

            echo "Checking if PyTorch can detect CUDA..."
            python3 -c 'import torch; print("CUDA available:" if torch.cuda.is_available() else "CUDA not available.")'
          '';
        };
      }
    );
}