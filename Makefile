#
# Copyright (C) 2006-2017 etnperlong
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mentohust-sysu
PKG_VERSION:=0.4.17
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/Placya/mentohust-SYSU.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=f93a2191ce62e5e051769043527e5fdc2e7c6459
# Specialize

PKG_MAINTAINER:=Evans Mike (etnperlong@gmail.com)
PKG_LICENSE:=GPLv3

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
# PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/mentohust-sysu
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpcap +libintl +libiconv
	TITLE:=MentoHUST SYSU
	URL:=https://github.com/Placya/mentohust-SYSU
	SUBMENU:=CERNET
endef

define Package/mentohust-sysu/description
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

define Package/mentohust-sysu/conffiles
/etc/mentohust-sysu.conf
endef

define Package/mentohust-sysu/install
	mkdir -p $(PKG_INSTALL_DIR)/usr/bin
	mkdir -p $(PKG_INSTALL_DIR)/etc
	$(CP) $(PKG_BUILD_DIR)/src/mentohust $(PKG_INSTALL_DIR)/usr/bin/mentohust-sysu
	# RENAME binary
	$(CP) $(PKG_BUILD_DIR)/src/mentohust-sysu.conf $(PKG_INSTALL_DIR)/etc/mentohust-sysu.conf
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mentohust-sysu $(1)/usr/sbin/
	chmod 755 $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/mentohust-sysu.conf $(1)/etc/
endef

$(eval $(call BuildPackage,mentohust-sysu))
