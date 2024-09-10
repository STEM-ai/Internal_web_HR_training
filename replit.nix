{pkgs}: {
  deps = [
    pkgs.tesseract
    pkgs.poppler_utils
    pkgs.cmake
    pkgs.wget
    pkgs.libxcrypt
    pkgs.bash
    pkgs.rustc
    pkgs.libiconv
    pkgs.cargo
    pkgs.pkg-config
    pkgs.freetype
    pkgs.poppler
    pkgs.expat
    pkgs.qt5.qtbase
    pkgs.qt5.qttools
    pkgs.boost
    pkgs.gpgme
  ];


  shellHook = ''
      pip install -r requirements.txt --constraint constraints.txt
    '';
  
}
