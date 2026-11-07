ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = FreeFire

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MysizPanel

MysizPanel_FILES = Tweak.xm
MysizPanel_CFLAGS = -fobjc-arc
MysizPanel_FRAMEWORKS = UIKit Foundation QuartzCore
MysizPanel_LIBRARIES = substrate

include $(THEOS_MAKE_PATH)/tweak.mk
