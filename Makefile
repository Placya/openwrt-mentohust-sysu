#
# Copyright (C) 2006-2017 etnperlong
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mentohust-sysu-double
PKG_VERSION:=0.4.17
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/Placya/mentohust-SYSU.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=300d78c97c9dbc663771d2c2a966700eb724ff7c
# Double

PKG_MAINTAINER:=Evans Mike (etnperlong@gmail.com)
PKG_LICENSE:=GPLv3

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
# PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/mentohust-sysu-double
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpcap +libintl +libiconv
	TITLE:=MentoHUST SYSU (Double)
	URL:=https://github.com/Placya/mentohust-SYSU
	SUBMENU:=CERNET
endef

define Package/mentohust-sysu-double/description
Open-source alternative to rjsupplicant.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(SED) 's/dhclient/udhcpc -i/g' $(PKG_BUILD_DIR)/src/myconfig.c
endef

CONFIGURE_ARGS += \
	--disable-encodepass \
	--disable-notify \
	--with-pcap=dylib

define Build/Configure
	( cd $(PKG_BUILD_DIR); ./autogen.sh )
	$(call Build/Configure/Default)
endef

# XXX: CFLAGS are already set by Build/Compile/Default
MAKE_FLAGS+= \
	OFLAGS=""

define Package/mentohust-sysu-double/conffiles
/etc/mentohust-sysu-double.conf
endef

define Package/mentohust-sysu-double/install
	mkdir -p $(PKG_INSTALL_DIR)/usr/bin
	mkdir -p $(PKG_INSTALL_DIR)/etc
	$(CP) $(PKG_BUILD_DIR)/src/mentohust $(PKG_INSTALL_DIR)/usr/bin/mentohust-sysu-double
	# RENAME binary
	$(CP) $(PKG_BUILD_DIR)/src/mentohust-sysu-double.conf $(PKG_INSTALL_DIR)/etc/mentohust-sysu-double.conf
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mentohust-sysu-double $(1)/usr/sbin/
	chmod 755 $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/mentohust-sysu-double.conf $(1)/etc/
endef

$(eval $(call BuildPackage,mentohust-sysu-double))
