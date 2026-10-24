TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = lockpositionprefs

lockpositionprefs_FILES = LPRootListController.m
lockpositionprefs_FRAMEWORKS = UIKit
lockpositionprefs_PRIVATE_FRAMEWORKS = Preferences
lockpositionprefs_INSTALL_PATH = /Library/PreferenceBundles
lockpositionprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
