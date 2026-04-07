{
  pkgs,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "git_bayesect";
  version = "1.2";
  pyproject = true;

  src = pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-9N6JUfMiyZhuv2pa6DuO3SUqfTPb4DB9C4YyHeXTfrs=";
  };

  dependencies = with python3Packages; [
    flit-core
    numpy
    scipy
  ];
  buildInputs = with python3Packages; [
    flit-core
    numpy
    scipy
  ];

  build-system = with python3Packages; [setuptools];
}
