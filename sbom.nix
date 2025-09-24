{ ... }:
  (builtins.getFlake "/sample-product").outputs.legacyPackages.${builtins.currentSystem}
