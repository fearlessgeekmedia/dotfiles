{
  description = "Linux Today CLI app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        app = pkgs.buildNpmPackage {
          pname = "linuxtoday-cli";
          version = "1.0.0";
          src = ./.;
          npmDepsHash = "sha256-eUUHKeRPjXvwogjz1s7kVL1VFN20KxIUIRolpVfJvvY=";
          dontNpmBuild = true;
          postInstall = ''
          cat > $out/bin/linuxtoday <<EOF
#!/bin/sh
exec ${pkgs.tsx}/bin/tsx $out/lib/node_modules/linuxtoday-cli/index.jsx "\$@"
EOF
            chmod +x $out/bin/linuxtoday
          '';
        };
      in {
        packages.default = app;
        apps.default = {
          type = "app";
          program = "${app}/bin/linuxtoday";
        };
      }
    );
}
