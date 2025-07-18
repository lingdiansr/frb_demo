# 构建说明

本项目使用GitHub Actions自动构建多平台安装包。

## 工作流说明

### 1. CI工作流 (.github/workflows/ci.yml)
- **触发条件**: 推送到main/develop分支或创建PR
- **功能**: 在Windows、Linux、macOS上测试和构建应用
- **输出**: 构建状态检查

### 2. FastForge Release工作流 (.github/workflows/fastforge-release.yml)
- **触发条件**: 推送v*标签或手动触发
- **功能**: 使用FastForge构建各平台安装包
- **工具**: [FastForge](https://fastforge.dev/) - 专业的Flutter应用打包工具
- **输出**: 
  - **Windows**: `.exe`安装程序
  - **Linux**: `.deb`和`.AppImage`格式
  - **macOS**: `.dmg`磁盘映像

### 3. FastForge配置
- **配置文件**: `distribute_options.yaml`
- **构建命令**: `flutter_distributor package`
- **输出目录**: `dist/`

## 使用方法

### 创建发布版本
1. 创建并推送标签：
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions会自动开始构建

3. 构建完成后，在GitHub Releases页面查看和下载构建产物

### 本地构建
#### Windows
```bash
flutter build windows --release
```

#### Linux
```bash
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev
flutter build linux --release
```

#### macOS
```bash
flutter build macos --release
```

## 配置说明

### Rust版本
使用`rust/rust-toolchain.toml`文件指定Rust版本和构建目标。

### Flutter版本
使用`.fvmrc`文件指定Flutter版本，GitHub Actions会自动读取此配置。

## FastForge配置说明

### 必需文件结构
项目已创建以下FastForge配置文件：

```
linux/packaging/deb/make_config.yaml      # DEB包配置
linux/packaging/appimage/make_config.yaml # AppImage配置
windows/packaging/exe/make_config.yaml    # Windows安装程序配置
macos/packaging/dmg/make_config.yaml      # macOS DMG配置
```

### 图标配置
- 创建 `assets/icon.png` (1024x1024像素) 作为应用图标
- 图标将用于所有平台的安装包

### 本地测试
```bash
# 安装flutter_distributor
dart pub global activate flutter_distributor

# 构建特定平台
flutter_distributor package --platform linux --targets deb
flutter_distributor package --platform windows --targets exe
flutter_distributor package --platform macos --targets dmg

# 一键构建所有平台
./scripts/fastforge_build.sh
```

### 注意事项
- 确保所有平台相关的依赖已正确安装
- 首次构建可能需要较长时间下载依赖
- 构建产物会作为GitHub Release的附件自动上传
- 所有安装包将输出到 `dist/` 目录
