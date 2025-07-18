# 构建说明

本项目使用GitHub Actions自动构建多平台安装包。

## 工作流说明

### 1. CI工作流 (.github/workflows/ci.yml)
- **触发条件**: 推送到main/develop分支或创建PR
- **功能**: 在Windows、Linux、macOS上测试和构建应用
- **输出**: 构建状态检查

### 2. Release工作流 (.github/workflows/release.yml)
- **触发条件**: 推送v*标签或手动触发
- **功能**: 构建各平台的安装包
- **输出**: 
  - **Windows**: `frb-demo-windows-x64-setup.exe` (Inno Setup安装程序)
  - **Linux**: 
    - `frb-demo-linux-x86_64.AppImage` (AppImage格式)
    - `frb-demo-linux-amd64.deb` (DEB包格式)
  - **macOS**: 
    - `frb-demo-macos-x64.dmg` (Intel芯片DMG)
    - `frb-demo-macos-arm64.dmg` (Apple Silicon DMG)

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

## 注意事项
- 确保所有平台相关的依赖已正确安装
- 首次构建可能需要较长时间下载依赖
- 构建产物会作为GitHub Release的附件自动上传
