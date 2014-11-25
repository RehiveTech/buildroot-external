#############################################################
#
# busio
#
#############################################################

BUSIO_VERSION = 2.1
BUSIO_SOURCE =
BUSIO_DEPENDENCIES = libdtree
BUSIO_INSTALL_TARGET = YES
BUSIO_LICENSE = GPLv3

define BUSIO_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(LIBDTREE_DIR) busio
endef

define BUSIO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(LIBDTREE_DIR)/busio $(TARGET_DIR)/usr/bin
endef

define BUSIO_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/busio
endef

define BUSIO_CLEAN_CMDS
	rm -f $(LIBDTREE_DIR)/busio
endef

$(eval $(generic-package))
