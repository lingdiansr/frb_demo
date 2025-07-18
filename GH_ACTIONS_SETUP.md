# GitHub Actions 权限设置指南

## 问题描述
当GitHub Actions尝试创建Release时，可能会遇到以下错误：
```
Resource not accessible by integration
```

## 解决方案

### 1. 设置仓库权限

1. 进入你的GitHub仓库页面
2. 点击 **Settings** → **Actions** → **General**
3. 在 **Workflow permissions** 部分，选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

### 2. 创建标签触发构建

```bash
# 创建标签
git tag v0.1.0

# 推送标签
git push origin v0.1.0
```

### 3. 验证工作流

1. 进入 **Actions** 标签页
2. 查看 **Build Multi-Platform Release** 工作流
3. 确保所有步骤都成功完成

## 常见问题排查

### 文件路径问题
确保所有构建产物都正确上传到artifacts，并且路径匹配。

### 权限检查清单
- [ ] 仓库设置为公开或私有但启用了Actions
- [ ] 工作流权限设置为"Read and write"
- [ ] 标签格式正确 (v* 格式)
- [ ] 所有依赖的Actions都可用

### 手动测试工作流
可以在GitHub Actions页面手动触发工作流：
1. 进入 **Actions** → **Build Multi-Platform Release**
2. 点击 **Run workflow** → 选择分支 → **Run workflow**

## 本地测试
使用提供的构建脚本进行本地测试：

### Linux/macOS
```bash
chmod +x scripts/build_all.sh
./scripts/build_all.sh
```

### Windows
```cmd
scripts\build_windows.bat
