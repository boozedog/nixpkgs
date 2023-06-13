{ lib
, gcc49Stdenv
, fetchFromGitHub

, zlib
, libxml2

, directfb
, autoreconfHook
, coreutils
, pkg-config
, minizip

, tcl
, tcltls
, tk
}:

gcc49Stdenv.mkDerivation rec {
  pname = "degrib";
  version = "2.25";

  src = (fetchTarball {
    url = "https://lamp.mdl.nws.noaa.gov/lamp/Data/degrib/download/archive/degrib-20200921.tar.gz";
    sha256 = "1md33zbp3bs85d0v2i77zyq4clabhzqpwg17jy9rnyn40dc1kjc7";
  }) + "/src";

  buildInputs = [
    tcl
    tcltls
    tk
  ];

  postPatch = ''
    rm -rf libxml
    cp -r ${libxml2.src}
  '';

  configureFlags = [
    "--with-zlib=${zlib.dev}"
    "--with-libxml2=${libxml2.dev}"
    "--with-xml=${libxml2.dev}"
#    "--with-libpng"
#    "--with-libaat"
#    "--with-jpeg2000"
  ];

  hardeningDisable = [ "format" ];

#  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Decode NDFD (and other) GRIB2 files";
    homepage = "https://vlab.noaa.gov/web/mdl/degrib-download";
    license = with licenses; [ ];
    maintainers = with maintainers; [ boozedog ];
  };
}
