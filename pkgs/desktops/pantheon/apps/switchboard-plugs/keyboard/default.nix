{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, gnome-settings-daemon
, granite
, gsettings-desktop-schemas
, gtk3
, libhandy
, libxml2
, libgnomekbd
, libxklavier
, ibus
, onboard
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-OMcySVnOkXy236YRldVK1hB1zCWMBhcGnCsqQOU08wo=";
  };

  patches = [
    ./0001-Remove-Install-Unlisted-Engines-function.patch
    (substituteAll {
      src = ./fix-paths.patch;
      inherit ibus onboard libgnomekbd;
    })

    # Fix crash with non-ubuntu GSD, can be removed on next update
    # https://github.com/elementary/switchboard-plug-keyboard/pull/427
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-keyboard/commit/4426499594f274bd092a603ba9a53e2840848288.patch";
      sha256 = "sha256-UI6B99WBQazs4+A9qidJrqopEsv8701SrsU9JpFhIkM=";
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite
    gsettings-desktop-schemas
    gtk3
    ibus
    libgee
    libhandy
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
