final: prev: {

  libratbag = prev.libratbag.overrideAttrs(old: {
    src = prev.fetchFromGitHub {
      owner = "libratbag";
      repo = "libratbag";
      rev = "v0.18";
      hash = "sha256-dAWKDF5hegvKhUZ4JW2J/P9uSs4xNrZLNinhAff6NSc=";
    };
  });

  piper = prev.piper.overrideAttrs(old: {
    src = prev.fetchFromGitHub {
      owner = "TheOptimist";
      repo = "piper";
      rev = "9ab64f5e54b8d6e90d720605ae4a5fbccf46c44b";
      hash = "sha256-vqdUP7Uq4+Xqm0Xm/P5V85phQruTjMkLso9LJiprg3g=";
    };

    mesonFlags = [
      "-Druntime-dependency-checks=false"
    ];
  });
}