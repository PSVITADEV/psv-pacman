#!/usr/bin/env bash
# build-and-install.sh by Wouter Wijsman (wwijsman@live.nl)

# Exit on errors
set -e

## Remove $CC and $CXX for configure
unset CC
unset CXX

## Make sure PSVITADEV is set
if [ -z "${PSVITADEV}" ]; then
    echo "The PSVITADEV environment variable has not been set"
    exit 1
fi

## Enter the script directory.
cd "$(dirname "$0")"
WORKDIR="${PWD}"

## MacOS specific environment variables
if [ "$(uname -s)" == "Darwin" ]; then
    export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$(brew --prefix bash)/bin:$PATH"
    export PKG_CONFIG_PATH="$(brew --prefix libarchive)/lib/pkgconfig"
fi

## Clean up from previous builds
rm -rf temp_build pkg src psv-pacman-*-*.pkg.tar.gz

## Install makepkg from source if it isn't already available and build the package
if ! which makepkg > /dev/null; then
    echo "Did not find makepkg, downloading and building pacman from source"
    source VITABUILD
    export pkgdir="${PWD}/temp_build/psv-pacman"
    mkdir -p "${pkgdir}"
    rm -rf pacman-v${pkgver}
    wget -nc ${source[0]}
    tar -xvf pacman-v${pkgver}.tar.gz
    prepare
    cd "$WORKDIR"
    build
    cd "$WORKDIR"
    package
    cd "$WORKDIR"
    export PATH="${pkgdir}/share/pacman/bin:${PATH}"
    if (( EUID == 0 )); then
        CARCH="$(./get-arch)" PSVITADEV="${pkgdir}" makepkg -p VITABUILD --asroot .
    else
        CARCH="$(./get-arch)" PSVITADEV="${pkgdir}" makepkg -p VITABUILD .
    fi
else
    CARCH="$(./get-arch)" makepkg -p VITABUILD .
fi

## Create the required directories for installation
mkdir -m 755 -p "${PSVITADEV}/var/lib/pacman"

## Add the directory with pacman's binaries to the start of the PATH
export PATH="${PWD}/pkg/psv-pacman/share/pacman/bin:${PATH}"

export LD_LIBRARY_PATH="${PWD}/pkg/psv-pacman/lib:${LD_LIBRARY_PATH}"

## The package in $PSVITADEV using the pacman that was build
./pkg/psv-pacman/share/pacman/bin/pacman  \
    --root "${PSVITADEV}" \
    --dbpath "${PSVITADEV}/var/lib/pacman" \
    --config "pacman.conf" \
    --arch "$(./get-arch)" \
    --noconfirm \
    -U psv-pacman-*-*.pkg.tar.gz
