# General - This is a simple PoC for management of product dependencies
{
  description = "A flake for building a PoC for sample-product";

  inputs = {
    nixpkgs-repo.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs-repo, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      lib = nixpkgs-repo.lib;
      forAllSystems = f: lib.genAttrs systems (system: f system);
      maintainers = import ./poc-internal/nix/maintainers.nix;

      findOwnStablePackages = pkgs:
        let
          packagesPath = ./poc-internal/nix/packages/own-stable;
          subdirs = builtins.readDir packagesPath;
          packageDirs = lib.filterAttrs
            (name: type: type == "directory" && builtins.pathExists (packagesPath + "/${name}/default.nix"))
            subdirs;

          packages = lib.mapAttrs
            (name: type:
              pkgs.callPackage (packagesPath + "/${name}") {
                pocMaintainers = maintainers;
              })
            packageDirs;
        in
          packages;

    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs-repo { inherit system; };
          ownStablePackages = findOwnStablePackages pkgs;
        in
          ownStablePackages // {
            default = ownStablePackages.hello;
          }
      );

      legacyPackages = self.packages;
    };
}
