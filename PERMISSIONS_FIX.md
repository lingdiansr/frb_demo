# GitHub Actions 权限问题解决方案

## 错误信息
```
Resource not accessible by integration
GitHub release failed with status: 403
```

## 原因
GitHub Actions默认权限不足，无法创建Release。

## 解决方案

### 方法1：设置仓库权限（推荐）
1. 进入你的GitHub仓库页面
2. 点击 **Settings** → **Actions** → **General**
3. 在 **Workflow permissions** 部分，选择：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
4. 点击 **Save**

### 方法2：使用个人访问令牌（PAT）
1. 创建个人访问令牌：
   - 进入 GitHub Settings → Developer settings → Personal access tokens
   - 点击 **Generate new token (classic)**
   - 选择作用域：`repo` 和 `workflow`
   - 复制生成的令牌

2. 设置仓库密钥：
   - 进入仓库 Settings → Secrets and variables → Actions
   - 点击 **New repository secret**
   - 名称：`GITHUB_TOKEN`
   - 值：你的个人访问令牌

### 方法3：修改工作流文件
更新工作流文件，使用正确的文件路径：

```yaml
- name: Create Release
  uses: softprops/action-gh-release@v2
  if: startsWith(github.ref, 'refs/tags/')
  with:
    files: |
      frb-demo-linux-x64.tar.gz
      frb-demo-windows-x64.zip
      frb-demo-macos-x64.tar.gz
      frb-demo-macos-arm64.tar.gz
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 验证步骤
1. 检查仓库是否为公开仓库（私有仓库需要额外权限）
2. 确认工作流权限设置正确
3. 重新触发构建：
   ```bash
   git tag v0.1.5
   git push origin v0.1.5
   ```

## 常见问题
- **私有仓库**: 需要确保Actions权限足够
- **组织仓库**: 可能需要组织管理员设置权限
- **令牌过期**: 检查个人访问令牌是否过期

## 测试权限
可以在GitHub Actions页面手动触发工作流来测试权限设置。
