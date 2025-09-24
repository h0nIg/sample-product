{ stdenv, fetchurl, lib, pocMaintainers }:

stdenv.mkDerivation rec {
  # This is the same as hello, but a different package just to have multiple packages
  pname = "another";
  version = "2.12.1";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${version}.tar.gz";
    sha256 = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
  };

  meta = with lib; {
    description = "Another program that produces a familiar, friendly greeting";
    homepage = "https://www.gnu.org/software/hello/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ pocMaintainers.X054979 ];
  };
}
