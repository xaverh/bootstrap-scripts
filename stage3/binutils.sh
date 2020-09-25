#!/bin/true
set -e

. $(dirname $(realpath -s $0))/common.sh

if [[ "${SERPENT_LIBC}" != "glibc" ]]; then
    printInfo "Skipping binutils with non-glibc libc"
    exit 0
fi

extractSource binutils
pushd binutils-*
mkdir build
popd
serpentChrootCd binutils-*/build

export CFLAGS="${SERPENT_TARGET_CFLAGS}"
export CXXFLAGS="${SERPENT_TARGET_CXXFLAGS}"

unset CONFIG_SITE
export LD="ld.bfd"
export AR="ar"
export RANLIB="ranlib"
export AS="as"
export NM="nm"
export CC="gcc"
export CPP="clang-cpp"
export CXX="g++"

export LDFLAGS="-L/usr/lib -L/serpent/usr/lib -B/usr/lib -B/serpent/usr/lib -isystem /usr/include -isystem /serpent/usr/include"
export CFLAGS="${CFLAGS} ${LDFLAGS}"
export CXXFLAGS="${CXXFLAGS} ${LDFLAGS}"
export PATH="/serpent/usr/binutils/bin:${PATH}"

printInfo "Configuring binutils"
serpentChroot ../configure --prefix=/usr/binutils \
    --sysconfdir=/etc \
    --libdir=/usr/lib \
    --sbindir=/usr/sbin \
    --datadir=/usr/share \
    --build="${SERPENT_TRIPLET}" \
    --host="${SERPENT_TRIPLET}" \
    --includedir=/usr/include \
    --disable-multilib \
    --enable-deterministic-archives \
    --disable-plugins \
    --disable-shared \
    --enable-static \
    --enable-ld=default \
    --enable-secureplt \
    --enable-64-bit-bfd \
    PATH="/serpent/usr/binutils/bin:/serpent/usr/bin:/serpent/usr/sbin:/usr/bin:/usr/sbin"

printInfo "Building binutils"
serpentChroot make -j "${SERPENT_BUILD_JOBS}" tooldir=/usr/binutils

printInfo "Installing binutils"
serpentChroot make -j "${SERPENT_BUILD_JOBS}" tooldir=/usr/binutils install
