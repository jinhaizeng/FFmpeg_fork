#!/bin/bash

# NDK的路径 (在bash.rc、zshrc中设置的路径，其中的NDK_HOME需要配置环境变量，如果你不配，在这改成你自己的也可以。)
NDK_ROOT=$NDK_HOME
# NDK_ROOT=你的NDK路径
TOOLCHAIN_PREFIX=$NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64

echo "<<<<<< FFMPEG 交叉编译 <<<<<<"
echo "<<<<<< 基于当前系统NDK地址： $NDK_HOME <<<<<<"


# 编译的相关参数
# 目标平台的CPU指令类型 ARMv8
CPU=armv8-a
# 架构类型 ： ARM
ARCH=arm64
# 操作系统
OS=android
# 平台
PLATFORM=aarch64-linux-android
OPTIMIZE_CFLAGS="-march=$CPU"

# 指定输出路径
PREFIX=/Volumes/RyanSSD/Code/FFmpeg/ffmpegOuput/aarch64

# 删除 so 的输出文件夹
 rm -rf $PREFIX

# SYSROOT
SYSROOT=$TOOLCHAIN_PREFIX/sysroot

# 交叉编译工具链
CROSS_PREFIX=$TOOLCHAIN_PREFIX/bin/llvm-

# Android交叉编译工具链的位置
ANDROID_CROSS_PREFIX=$TOOLCHAIN_PREFIX/bin/${PLATFORM}29

echo ">>>>>> FFMPEG 开始编译 >>>>>>"

./configure \
--prefix=$PREFIX \
--enable-shared \
--enable-gpl \
--enable-neon \
--enable-hwaccels \
--enable-postproc \
--enable-jni \
--enable-small \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-ffmpeg \
--enable-shared \
--disable-static \
--disable-doc \
--disable-ffplay \
--disable-ffprobe \
--disable-symver \
--disable-ffmpeg \
--cross-prefix=$CROSS_PREFIX \
--target-os=$OS \
--arch=$ARCH \
--cpu=$CPU \
--cc=${ANDROID_CROSS_PREFIX}-clang \
--cxx=${ANDROID_CROSS_PREFIX}-clang++ \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-I/opt/homebrew/include -DVK_ENABLE_BETA_EXTENSIONS=0 -fPIC" \
--extra-ldflags=-L/opt/homebrew/lib


make clean

# 创建目标路径,如果不存在的话，最终产物存储在Prefix对应路径之下。
mkdir -p $PREFIX

sudo make -j8

sudo make install


echo "<<<<<< 编译完成，产物存储在:$PREFIX <<<<<<"