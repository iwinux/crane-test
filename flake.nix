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

  outputs = { self, crane, nixpkgs, utils }: utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" ] (system: {
    packages.default = crane.buildPackage {
      pname = "foo";
      src = crane.cleanCargoSource ./.;
      version = "0.1.0";
      doCheck = false;
    };
  });
}
