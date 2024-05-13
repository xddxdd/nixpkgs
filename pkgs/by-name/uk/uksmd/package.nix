{ stdenv
, lib
, fetchFromGitHub
, meson
, cmake
, pkg-config
, procps4
, libcap_ng
, systemd
, ninja
, ...
}@args:
stdenv.mkDerivation {
  pname = "uksmd";
  version = "1.2.9";
  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "uksmd";
    rev = "v1.2.9";
    fetchSubmodules = false;
    sha256 = "sha256-sRQzGBtJuoOwO7aNzwiA7VOfeIGjvXR+tM9pr208Cm0=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];
  buildInputs = [
    procps4
    libcap_ng
    systemd
  ];

  postPatch = ''
    sed -i "s#install_dir: systemd_system_unit_dir#install_dir: '$out/lib/systemd/system'#g" meson.build
    sed -i "s#/usr/bin#$out/bin#g" meson.build
    sed -i "s#/usr/bin#$out/bin#g" uksmd.service
  '';

  meta = with lib; {
    description = "Userspace KSM helper daemon";
    homepage = "https://github.com/CachyOS/uksmd";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xddxdd ];
  };
}
