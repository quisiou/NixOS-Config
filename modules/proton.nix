# modules/proton.nix

{ ... }:

{
    nixpkgs.overlays = [
        (final: prev: {
            ge-proton9-24 = prev.fetchzip {
                url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton9-24/GE-Proton9-24.tar.gz";
                hash = "sha256-L0GkzpSn4f6dLDOm2iDJr8D1DINTHNW9Kkn1xFTuqfo=";
            };
            ge-proton10-17 = prev.fetchzip {
                url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-17/GE-Proton10-17.tar.gz";
                hash = "sha256-GMwAAKuaBhDv1TvAuW9DVcXSYPRM87NP6NnJfk8O8ZU=";
            };
            ge-proton10-28 = prev.fetchzip {
                url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-28/GE-Proton10-28.tar.gz";
                hash = "sha256-6NvSGX8445la6WU6z9UaaKJm30eg094cuTyhHVDjbOo=";
            };
        })
    ];
}
