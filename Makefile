#
# Copyright (C) 2019-2020 Xingwang Liao
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=1.1.2
PKG_RELEASE:=1

PKG_SOURCE_NAME=Xray-core
PKG_SOURCE:=$(PKG_SOURCE_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/XTLS/Xray-core/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=6ec14856fe9966a118fc0854696ec54c08ce478cb937a75fae74072c945dcb42
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_NAME)-$(PKG_VERSION)

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Zhonghua Mo <mozhonghu@yeah.net>

PKG_BUILD_DEPENDS:=golang/host PACKAGE_xray-core-mini:upx/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_xray_include_geo_data \
	CONFIG_PACKAGE_xray_compress_upx \
	CONFIG_PACKAGE_xray_custom_features \
	CONFIG_PACKAGE_xray_without_dns \
	CONFIG_PACKAGE_xray_without_log \
	CONFIG_PACKAGE_xray_without_tls \
	CONFIG_PACKAGE_xray_without_udp \
	CONFIG_PACKAGE_xray_without_policy \
	CONFIG_PACKAGE_xray_without_reverse \
	CONFIG_PACKAGE_xray_without_routing \
	CONFIG_PACKAGE_xray_without_statistics \
	CONFIG_PACKAGE_xray_without_blackhole_proto \
	CONFIG_PACKAGE_xray_without_dns_proxy \
	CONFIG_PACKAGE_xray_without_dokodemo_proto \
	CONFIG_PACKAGE_xray_without_freedom_proto \
	CONFIG_PACKAGE_xray_without_mtproto_proxy \
	CONFIG_PACKAGE_xray_without_http_proto \
	CONFIG_PACKAGE_xray_without_shadowsocks_proto \
	CONFIG_PACKAGE_xray_without_socks_proto \
	CONFIG_PACKAGE_xray_without_vmess_proto \
	CONFIG_PACKAGE_xray_without_tcp_trans \
	CONFIG_PACKAGE_xray_without_mkcp_trans \
	CONFIG_PACKAGE_xray_without_websocket_trans \
	CONFIG_PACKAGE_xray_without_http2_trans \
	CONFIG_PACKAGE_xray_without_domain_socket_trans \
	CONFIG_PACKAGE_xray_without_quic_trans

GO_PKG:=github.com/xtls/xray-core
GO_PKG_LDFLAGS:=-s -w

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
	source "$(SOURCE)/Config.in"
endef

XRAY_SED_ARGS:=

ifeq ($(CONFIG_PACKAGE_xray_custom_features),y)

ifeq ($(CONFIG_PACKAGE_xray_without_dns),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/dns",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_log),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/log",// &,; \
	s,_ "github.com/xtls/xray-core/app/log/command",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_tls),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/tls",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_udp),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/udp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_policy),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/policy",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_reverse),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/reverse",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_routing),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/router",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_statistics),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/app/stats",// &,; \
	s,_ "github.com/xtls/xray-core/app/stats/command",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_blackhole_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/blackhole",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_dns_proxy),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/dns",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_dokodemo_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/dokodemo",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_freedom_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/freedom",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_mtproto_proxy),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/mtproto",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_http_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/http",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_shadowsocks_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/shadowsocks",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_socks_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/socks",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_vmess_proto),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/proxy/vmess/inbound",// &,; \
	s,_ "github.com/xtls/xray-core/proxy/vmess/outbound",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_tcp_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/tcp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_mkcp_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/kcp",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_websocket_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/websocket",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_http2_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/http",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/http",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_domain_socket_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/domainsocket",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_quic_trans),y)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/quic",// &,;
endif

ifeq ($(CONFIG_PACKAGE_xray_without_mkcp_trans)$(CONFIG_PACKAGE_xray_without_quic_trans),yy)
XRAY_SED_ARGS += \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/noop",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/srtp",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/tls",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/utp",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/wechat",// &,; \
	s,_ "github.com/xtls/xray-core/transport/internet/headers/wireguard",// &,;
endif
endif

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

ifneq ($(XRAY_SED_ARGS),)
	( \
		$(SED) \
			'$(XRAY_SED_ARGS)' \
			$(PKG_BUILD_DIR)/main/distro/all/all.go ; \
	)
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
