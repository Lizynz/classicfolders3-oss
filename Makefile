export ARCHS = arm64 arm64e
GO_EASY_ON_ME = 1
PACKAGE_VERSION = 3.0.1

TARGET = iphone:clang:14.5
THEOS_LAYOUT_DIR_NAME = layout-rootless
THEOS_PACKAGE_SCHEME = rootless

export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ClassicFolders3
ClassicFolders3_FILES = iOS13.x CSClassicFolderView.x UIImage+ClassicFolders.m CSClassicFolderSettingsManager.m CSClassicFolderTextField.m iOS10BlurRemoval.x BackgroundBlur.x RootFolderBugFix.x Icon.x IconListViewBugFix.x 
#ClassicFolders3_FILES += ForceBinds.x
ClassicFolders3_CFLAGS = -Iinclude -include sha1.pch -include DRM.pch
#ClassicFolders3_CFLAGS = -include DRM-dummy.pch
#ClassicFolders3_OBJ_FILES = libcrypto.a
ClassicFolders3_FRAMEWORKS = IOKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += classicfolderssettings
include $(THEOS_MAKE_PATH)/aggregate.mk
