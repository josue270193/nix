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
    cp -r $(ls -A $src | grep -v -w test | awk -v path=$src '{printf "%s/%s ", path, $src}') $out/
  '';

  meta = {
    description = "Node Version Manager";
    homepage = "https://github.com/nvm-sh/nvm";
  };
}