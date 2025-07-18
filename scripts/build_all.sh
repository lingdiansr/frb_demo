#!/bin/bash
# 构建脚本 - 为所有平台构建发布版本
set -e

PROJECT_NAME="frb-demo"
VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)

echo "开始构建 $PROJECT_NAME v$VERSION"

# 创建构建目录
mkdir -p build/releases

# 构建函数
build_platform() {
    local platform=$1
    local build_cmd=$2
    local output_dir=$3
    local package_name=$4
    
    echo "正在构建 $platform..."
    
    # 清理之前的构建
    flutter clean
    
    # 获取依赖
    flutter pub get
    
    # 构建应用
    eval "$build_cmd"
    
    # 创建压缩包
    if [ "$platform" = "windows" ]; then
        cd "build/windows/x64/runner/Release"
        zip -r "../../../../../build/releases/$package_name" *
        cd -
    elif [ "$platform" = "linux" ]; then
        cd "build/linux/x64/release/bundle"
        tar -czf "../../../../../build/releases/$package_name" *
        cd -
    elif [ "$platform" = "macos" ]; then
        cd "build/macos/Build/Products/Release"
        tar -czf "../../../../../build/releases/$package_name" *.app
        cd -
    fi
    
    echo "$platform 构建完成: build/releases/$package_name"
}

# 检查平台并构建
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    build_platform "linux" "flutter build linux --release" "$PROJECT_NAME-linux-x64.tar.gz"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - 构建x64和arm64
    build_platform "macos" "flutter build macos --release" "$PROJECT_NAME-macos-x64.tar.gz"
    
    # 如果需要构建arm64版本，可以添加：
    # build_platform "macos" "flutter build macos --release --dart-define=TARGET_ARCH=arm64" "$PROJECT_NAME-macos-arm64.tar.gz"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    # Windows
    build_platform "windows" "flutter build windows --release" "$PROJECT_NAME-windows-x64.zip"
else
    echo "不支持的平台: $OSTYPE"
    exit 1
fi

echo "所有构建完成！"
echo "构建产物位于: build/releases/"
ls -la build/releases/
