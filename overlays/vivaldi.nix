final: prev: {

  myvivaldi = (prev.vivaldi.override {
    proprietaryCodecs = true;
    commandLineArgs = "--ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy --enable-accelerated-video-decode --enable-features=VaapiVideoDecoder";
  }).overrideAttrs(old: rec {
    version = "7.0.3495.6";

    src = prev.fetchurl {
      url = "https://downloads.vivaldi.com/stable/vivaldi-stable_${version}-1_amd64.deb";
      hash = "sha256-dbBdmqoY4x6+zwiWe+eRjrd0jeww3ANZNDDYH79uxaU=";
    };
  });
}