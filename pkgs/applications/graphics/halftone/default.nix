{ lib
, fetchFromGitHub
, wrapGAppsHook4
, meson
, ninja
, pkg-config
, appstream-glib
, desktop-file-utils
, gobject-introspection
, glib
, blueprint-compiler
, libadwaita
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "halftone";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "tfuxu";
    repo = pname;
    rev = version;
    hash = "sha256-EYxnGpVKPV3Xg6dH3m1aC3/pDigUxkNF7C8U16n8al8=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    wand
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/tfuxu/halftone";
    description = "Simple app for giving images that pixel-art style";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
