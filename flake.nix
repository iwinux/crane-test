{
  description = "Crane Test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/3ea257209da29110bd4c83bd2efc6d89ddc40b46";

    crane = {
      url = "github:ipetkov/crane";
      inputs.flake-utils.follows = "utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, crane, nixpkgs, utils }: utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" ] (system:
    let
      craneLib = crane.lib.${system};

      common = {
        src = crane.lib.${system}.cleanCargoSource ./.;
        version = "0.1.0";
        doCheck = false;
      };

      deps = craneLib.buildDepsOnly common // {
        pname = "foo-deps";
      };
    in
    {
      packages.default = craneLib.buildPackage common // {
        pname = "foo";
        cargoArtifacts = deps;
      };
    });
}
