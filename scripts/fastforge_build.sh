#!/bin/bash
# FastForge本地构建脚本

echo "使用FastForge构建多平台安装包..."

# 安装flutter_distributor
echo "安装Flutter Distributor..."
dart pub global activate flutter_distributor

# 确保PATH包含全局包
export PATH="$PATH":"$HOME/.pub-cache/bin"

# 构建所有平台
echo "构建Linux包..."
flutter_distributor package --platform linux --targets deb,appimage --skip-clean

echo "构建Windows包..."
flutter_distributor package --platform windows --targets exe --skip-clean

echo "构建macOS包..."
flutter_distributor package --platform macos --targets dmg --skip-clean

echo "构建完成！安装包位于 dist/ 目录"
ls -la dist/
