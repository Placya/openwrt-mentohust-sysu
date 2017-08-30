#
# Copyright (C) 2006-2017 etnperlong
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mentohust
PKG_VERSION:=0.4.17
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/Placya/mentohust-SYSU.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=595aa096f359e4bbf077ac0de3d10aa24882c568

PKG_MAINTAINER:=Evans Mike (etnperlong@gmail.com)
PKG_LICENSE:=GPLv3

PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/nls.mk 

PKG_BUILD_DEPENDES:=libintl-full libncurses

include $(INCLUDE_DIR)/package.mk

define Package/mentohust
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpcap
	TITLE:=MentoHUST
	URL:=https://github.com/HustLion/mentohust
	SUBMENU:=CERNET
endef

define Package/mentohust/description
Open-source alternative to rjsupplicant.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(SED) 's/dhclient/udhcpc -i/g' $(PKG_BUILD_DIR)/src/myconfig.c
endef

# autogen first
CONFIGURE_CMD =$(PKG_BUILD_DIR)/autogen.sh

CONFIGURE_ARGS += \
	--disable-encodepass \
	--disable-notify

# XXX: CFLAGS are already set by Build/Compile/Default
MAKE_FLAGS+= \
	OFLAGS=""

define Package/mentohust/conffiles
/etc/mentohust.conf
endef

define Package/mentohust/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mentohust $(1)/usr/sbin/
	chmod 755 $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/mentohust.conf $(1)/etc/
endef

$(eval $(call BuildPackage,mentohust))
