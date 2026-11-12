#########################################################################################
#
# sysmon
#
#########################################################################################

SYSMON_VERSION = 1.0
SYSMON_PROJECT_DIR = $(BR2_EXTERNAL_RPI4_SYSMON_PATH)/..
SYSMON_SITE = $(SYSMON_PROJECT_DIR)/sysmon
SYSMON_SITE_METHOD = local

SYSMON_MODULE_SUBDIRS = kernel

define SYSMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/daemon CC="$(TARGET_CC)"
endef

define SYSMON_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/daemon/sysmond $(TARGET_DIR)/usr/bin/sysmond
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/lib/sysmon
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/sysmon/dashboard/templates
	$(INSTALL) -m 0755 $(SYSMON_PROJECT_DIR)/dashboard/app.py \
		$(TARGET_DIR)/usr/share/sysmon/dashboard/app.py
	$(INSTALL) -m 0644 $(SYSMON_PROJECT_DIR)/dashboard/templates/index.html \
		$(TARGET_DIR)/usr/share/sysmon/dashboard/templates/index.html
endef

$(eval $(kernel-module))
$(eval $(generic-package))
