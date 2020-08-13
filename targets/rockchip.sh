#!/bin/true

. $(dirname $(realpath -s $0))/../lib/base.sh


# The rockchip build profile is intended for Rockchip RK3399, found in Pinebook Pro
export SERPENT_TARGET_CFLAGS="-march=armv8-a -mtune=cortex-a72.cortex-a53 -O3 -fPIC"
export SERPENT_TARGET_CXXFLAGS="${SERPENT_TARGET_CFLAGS}"
export SERPENT_TARGET_LDFLAGS=""
export SERPENT_TRIPLET="aarch64-serpent-linux-musl"
