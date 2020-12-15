# openwrt-xray

Xray for OpenWrt

## Build Guide

1. Use the latest [OpenWrt SDK](https://downloads.openwrt.org/snapshots/) or with source code in master branch (requires golang modules support, commit [openwrt/packages@7dc1f3e](https://github.com/openwrt/packages/commit/7dc1f3e0293588ebc544e8eee104043dd0dacaf5) and later).

2. Enter root directory of SDK, then download the Makefile:

```sh
git clone -b master --depth 1 https://github.com/MoZhonghua/openwrt-xray package/xray-core
```

> For Chinese users, `export GOPROXY=https://goproxy.io` before build.

Start build:

```sh
./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

Network ---> Project X ---> <*> xray-core

make package/xray-core/{clean,compile} V=s
```

- You can custom the features in `XRAY Configuration` option.

3. Upgrade golang (only required if version of golang in SDK is too old)

```sh
sed -i "s/GO_VERSION_MAJOR_MINOR:=.*/GO_VERSION_MAJOR_MINOR:=1.15/g" feeds/packages/lang/golang/golang-version.mk
sed -i "s/GO_VERSION_PATCH:=.*/GO_VERSION_PATCH:=5/g" feeds/packages/lang/golang/golang-version.mk 
sed -i "s/PKG_HASH:=.*/PKG_HASH:=c1076b90cf94b73ebed62a81d802cd84d43d02dea8c07abdc922c57a071c84f1/g" feeds/packages/lang/golang/golang/Makefile
```

4. UPX Compress

If you want to build with UPX compress, the UPX package is required.

```sh
git clone -b master --depth 1 https://github.com/kuoruan/openwrt-upx.git package/openwrt-upx
```

## Uninstall

```sh
opkg remove xray-core
```
