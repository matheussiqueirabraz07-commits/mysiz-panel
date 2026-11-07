ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = FreeFire

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UrielPanel

UrielPanel_FILES = Tweak.xm
UrielPanel_CFLAGS = -fobjc-arc
UrielPanel_FRAMEWORKS = UIKit Foundation QuartzCore
UrielPanel_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
