#! /usr/bin/env bash

set -e

# Compile natives
cd Natives
CFLAGS="-arch arm64 -fmessage-length=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit=0 -Wno-trigraphs -fpascal-strings -miphoneos-version-min=12.0 -O3 -Wno-missing-field-initializers -Wno-missing-prototypes -Wno-return-type -Wno-missing-braces -Wparentheses -Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wno-unused-variable -Wunused-value -Wno-empty-body -Wno-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wno-constant-conversion -Wno-int-conversion -Wno-bool-conversion -Wno-enum-conversion -Wno-float-conversion -Wno-non-literal-null-conversion -Wno-objc-literal-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wl,-rpath,/Applications/PojavLauncher.app/Frameworks -fobjc-arc -x objective-c -Fresources/Frameworks -Iresources/Frameworks/MetalANGLE.framework/Headers -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"

clang -framework UIKit $CFLAGS -o PojavLauncher main.c log.m JavaLauncher.c
clang -framework UIKit -framework MetalANGLE -framework CoreGraphics -framework AuthenticationServices -dynamiclib $CFLAGS -o libpojavexec.dylib log.m AppDelegate.m SceneDelegate.m UILauncher.m LauncherViewController.m LoginViewController.m SurfaceViewController.m egl_bridge_ios.m ios_uikit_bridge.m customcontrols/ControlButton.m egl_bridge.c input_bridge_v3.c utils.c -DGLES_TESTZ -DUSE_EGLZ -Wl,-undefined,dynamic_lookup

ldid -S../entitlements.xml PojavLauncher
ldid -S../entitlements.xml libpojavexec.dylib

# Making directories
mkdir -p build
mkdir -p build/Release-iphoneos
mkdir -p build/Release-iphoneos/PojavLauncher.app
mkdir -p build/Release-iphoneos/PojavLauncher.app/Frameworks
mkdir -p build/Release-iphoneos/PojavLauncher.app/Base.lproj

# Compile storyboard
ibtool --compile build/Release-iphoneos/PojavLauncher.app/Base.lproj/MinecraftSurface.storyboardc en.lproj/MinecraftSurface.storyboard

# Copy to target app
cp -rv PojavLauncher build/Release-iphoneos/PojavLauncher.app/PojavLauncher
cp -rv Info.plist build/Release-iphoneos/PojavLauncher.app/Info.plist
cp -rv PkgInfo build/Release-iphoneos/PojavLauncher.app/PkgInfo
cp -rv libpojavexec.dylib build/Release-iphoneos/PojavLauncher.app/Frameworks/libpojavexec.dylib
cp -rv resources/* build/Release-iphoneos/PojavLauncher.app/

echo "BUILD SUCCESSFUL"
