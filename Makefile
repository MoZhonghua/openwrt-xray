#
# Copyright (C) 2019-2020 Xingwang Liao
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=1.2.3
PKG_RELEASE:=1

PKG_SOURCE_NAME=Xray-core
PKG_SOURCE:=$(PKG_SOURCE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/XTLS/Xray-core/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=1deed281d2b976c0132b57194a09b62a1b978ec1b35d8329894b80f8d47befb7
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Zhonghua Mo <mozhonghu@yeah.net>

PKG_BUILD_DEPENDS:=golang/host PACKAGE_xray_compress_upx:upx/host

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_xray_include_geo_data \
	CONFIG_PACKAGE_xray_compress_upx

GO_PKG:=github.com/xtls/xray-core
GO_PKG_LDFLAGS:=-s -w -buildid=

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/xray-core
  TITLE:=A platform for building proxies to bypass network restrictions.
  URL:=https://github.com/XTLS
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Project X
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-certificates
  PROVIDES:=xray
endef

define Package/xray-core/description
  Project X originates from XTLS protocol, provides a set of network tools such as Xray-core and Xray-flutter.

  This package contains xray, geoip.dat and geosite.dat.
endef

define Package/xray-core/config
menu "XRAY Configuration"

config PACKAGE_xray_include_geo_data
	bool "Include geoip.dat & geosite.dat"
	default n

config PACKAGE_xray_compress_upx
	bool "Compress executable files with UPX"
	default n

endmenu
endef

GEOIP_VER:=latest
GEOIP_FILE:=geoip-$(GEOIP_VER).dat

define Download/geoip.dat
  URL:=https://github.com/v2fly/geoip/releases/$(GEOIP_VER)/download
  URL_FILE:=geoip.dat
  FILE:=$(GEOIP_FILE)
  HASH:=skip
endef

GEOSITE_VER:=latest
GEOSITE_FILE:=geosite-$(GEOSITE_VER).dat

define Download/geosite.dat
  URL:=https://github.com/v2fly/domain-list-community/releases/$(GEOSITE_VER)/download
  URL_FILE:=dlc.dat
  FILE:=$(GEOSITE_FILE)
  HASH:=skip
endef

define Build/Prepare
	$(call Build/Prepare/Default)

ifeq ($(CONFIG_PACKAGE_xray_include_geo_data),y)
	$(eval $(call Download,geoip.dat))
	$(eval $(call Download,geosite.dat))

	# move file to make sure download new file every build
	mv -f $(DL_DIR)/$(GEOIP_FILE) $(PKG_BUILD_DIR)/geoip.dat
	mv -f $(DL_DIR)/$(GEOSITE_FILE) $(PKG_BUILD_DIR)/geosite.dat
endif

endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=github.com/xtls/xray-core/main)
	$(call GoPackage/Build/Compile)
	mv -f $(GO_PKG_BUILD_BIN_DIR)/main $(GO_PKG_BUILD_BIN_DIR)/xray

ifeq ($(CONFIG_PACKAGE_xray_compress_upx),y)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/xray || true
endif

endef

define Package/xray-core/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/xray $(1)/usr/bin

	$(INSTALL_DIR) $(1)/etc/xray/
	$(INSTALL_DATA) ./files/config.json.example $(1)/etc/xray
	$(INSTALL_DATA) ./files/vpoint_socks_vmess.json $(1)/etc/xray
	$(INSTALL_DATA) ./files/vpoint_vmess_freedom.json $(1)/etc/xray

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/xray.init $(1)/etc/init.d/xray

ifeq ($(CONFIG_PACKAGE_xray_include_geo_data),y)
	$(INSTALL_DIR) $(1)/usr/share/xray
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/{geoip,geosite}.dat \
		$(1)/usr/share/xray
endif
endef

$(eval $(call BuildPackage,xray-core))
