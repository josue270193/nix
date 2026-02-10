{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "nvm";
  version = "0.40.3";

  src = fetchFromGitHub {
    owner = "nvm-sh";
    repo = "nvm";
    rev = "v${version}";
    sha256 = "sha256-s36EQojnNKm4x410nllC3nbnzzwcLZCKSP3DkJPpjjo=";
  };

  phases = [ "unpackPhase" "installPhase" ]; # Skip build/configure phases

  installPhase = ''
    mkdir -p $out
    for f in $(ls -A $src | grep -v -w test); do
      cp -r "$src/$f" "$out/"
    done
  '';

  meta = {
    description = "Node Version Manager";
    homepage = "https://github.com/nvm-sh/nvm";
  };
}