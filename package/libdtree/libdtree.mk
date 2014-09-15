#############################################################
#
# libdtree
#
#############################################################

LIBDTREE_VERSION = v2.0
LIBDTREE_SITE = git://github.com/jviki/dtree.git
LIBDTREE_INSTALL_STAGING = YES
LIBDTREE_INSTALL_TARGET = YES
LIBDTREE_LICENSE = GPLv3
LIBDTREE_LICENSE_FILES = COPYING
LIBDTREE_REDISTRIBUTE = YES

define LIBDTREE_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) all
endef

define LIBDTREE_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libdtree.a $(STAGING_DIR)/usr/lib/libdtree.a
	$(INSTALL) -D -m 0644 $(@D)/dtree.h $(STAGING_DIR)/usr/include/dtree.h
	$(INSTALL) -D -m 0755 $(@D)/libdtree.so $(STAGING_DIR)/usr/lib/libdtree.so
endef

define LIBDTREE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/libdtree.so* $(TARGET_DIR)/usr/lib/
endef

define LIBDTREE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/lib/libdtree.so
endef

define LIBDTREE_UNINSTALL_STAGING_CMDS
	rm -f $(STAGING_DIR)/usr/include/dtree.h
	rm -f $(STAGING_DIR)/usr/lib/libdtree.a
	rm -f $(STAGING_DIR)/usr/lib/libdtree.so
endef

define LIBDTREE_CLEAN_CMDS
	-$(MAKE) -C $(@D) distclean
endef

$(eval $(generic-package))
