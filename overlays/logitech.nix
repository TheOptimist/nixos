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
      owner = "libratbag";
      repo = "piper";
      rev = "0.8";
      hash = "sha256-j58fL6jJAzeagy5/1FmygUhdBm+PAlIkw22Rl/fLff4=";
    };

    mesonFlags = [
      "-Druntime-dependency-checks=false"
    ];
  });
}