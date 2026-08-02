# PSVita Pacman

This respository contains all the files needed to build and install the pacman package manager for the PSVITA sdk. Pacman can be used to build and manage packages for the Playstation Vita and development for it.

This package provides the following commands:
- **psv-pacman** - Allows users to install and manage Vita packages.
- **psv-makepkg** - Allows users to build packages from VITABUILD files.

## Dependencies

On Ubuntu/Debian, the following packages need to be installed:
- build-essential
- libarchive-dev
- libarchive-tools
- libcurl4-openssl-dev
- libgpgme-dev
- libssl-dev
- pkg-config
- meson
- ninja-build
- wget

On Arch/Manjaro, the following packages need to be installed:
- base-devel

## Installation
1. Install the dependencies.
2. Make sure the environment variable ``$PSVITADEV`` is set in your shell. Use ``echo $PSVITADEV`` to confirm this.
3. Install with the following command:
  ```
  ./pacman.sh
  ```

## Usage

Here is how to use ``psv-pacman`` and ``psv-makepkg``.

### Installing a package

Installing a ``*.pkg.tar.gz`` package can be done with:
```
psv-pacman -U package-name-1.0.2.pkg.tar.gz
```

### Building a package

Building a package requires a ``VITABUILD`` script. Here is [an example](https://git.archlinux.org/pacman.git/plain/proto/PKGBUILD.proto) and [some documentation on which options are available](https://wiki.archlinux.org/index.php/PKGBUILD). Do **not** call it ``PKGBUILD``, though, use ``VITABUILD`` instead.

Packages can be build by running the following command in a directory with a PSPBUILD file in it:
```
psv-makepkg
```

This will create a file called something like ``package-name-1.0.2.pkg.tar.gz``. This file can be shared or installed. Installing would be done using the following command:
```
psv-pacman -U package-name-1.0.2.pkg.tar.gz
```
