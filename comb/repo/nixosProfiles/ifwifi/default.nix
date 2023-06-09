{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  iw,
  networkmanager,
  Security,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "ifwifi";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "araujobsd";
    repo = "ifwifi";
    rev = "${version}";
    sha256 = "sha256-RYxBlqG8yV7ZhqTkWbzrGI/ZJRF55JN+kUlqFj/Bs7s=";
  };

  cargoSha256 = "sha256-ys4tXP46pTXj9LSVISBRX+9xj7ijJddS86YzHHzK+jQ=";

  nativeBuildInputs = [makeWrapper];
  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    wrapProgram "$out/bin/ifwifi" \
      --prefix PATH : "${
      lib.makeBinPath ([
          # `ifwifi` runtime dep
          networkmanager
        ]
        # `wifiscanner` crate's runtime deps
        ++ (lib.optional stdenv.isLinux iw))
      # ++ (lib.optional stdenv.isDarwin airport) # airport isn't packaged
    }"
  '';

  doCheck = true;

  meta = with lib; {
    description = "A simple wrapper over nmcli using wifiscanner made in rust";
    longDescription = ''
      In the author's words:

      I felt bothered because I never remember the long and tedious command
      line to setup my wifi interface. So, I wanted to develop something
      using rust to simplify the usage of nmcli, and I met the wifiscanner
      project that gave me almost everything I wanted to create this tool.
    '';
    homepage = "https://github.com/araujobsd/ifwifi";
    license = with licenses; [bsd2];
    maintainers = with maintainers; [blaggacao];
    platforms = platforms.linux;
  };
}
