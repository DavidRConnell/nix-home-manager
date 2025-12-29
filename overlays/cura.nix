final: prev: {
  cura = prev.cura.overrideAttrs (old: rec {
    version = "5.10";
    src = prev.fetchFromGitHub {
      owner = "lulzbot3d";
      repo = "CuraLE";
      rev = version;
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    matrials = prev.fetchFromGitHub {
      owner = "lulzbot3d";
      repo = "FDM_MaterialsLE";
      rev = version;
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  });
}
