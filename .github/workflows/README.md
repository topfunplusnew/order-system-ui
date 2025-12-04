# GitHub Actions Workflow 配置说明

## 工作流说明

当代码推送到 `front-dev` 分支时，会自动：
1. 构建项目（`yarn build`）
2. 通过 rsync 同步构建产物到服务器的 nginx 目录

## 配置 GitHub Secrets

在 GitHub 仓库设置中配置以下 Secrets（Settings → Secrets and variables → Actions）：

### 必需的 Secrets

1. **DEPLOY_HOST** - 服务器IP地址或域名
   ```
   例如: 192.168.1.100 或 deploy.example.com
   ```

2. **DEPLOY_USER** - SSH 登录用户名
   ```
   例如: root 或 deploy
   ```

3. **DEPLOY_PATH** - 服务器上 nginx 网站目录的绝对路径
   ```
   例如: /usr/share/nginx/html/order-system
   或: /var/www/html/order-system
   ```

4. **DEPLOY_SSH_KEY** - SSH 私钥（用于 rsync 认证）
   ```
   生成密钥对（如果还没有）:
   ssh-keygen -t rsa -b 4096 -C "github-actions" -f ~/.ssh/github_deploy_key
   
   将私钥内容（~/.ssh/github_deploy_key）添加到 DEPLOY_SSH_KEY
   将公钥内容（~/.ssh/github_deploy_key.pub）添加到服务器的 ~/.ssh/authorized_keys
   ```

## 配置步骤

### 1. 生成 SSH 密钥对

```bash
# 在本地生成密钥对
ssh-keygen -t rsa -b 4096 -C "github-actions-deploy" -f ~/.ssh/github_deploy_key

# 查看私钥（添加到 GitHub Secrets）
cat ~/.ssh/github_deploy_key

# 查看公钥（添加到服务器）
cat ~/.ssh/github_deploy_key.pub
```

### 2. 配置服务器 SSH 访问

```bash
# 登录到服务器
ssh user@your-server

# 将公钥添加到 authorized_keys
echo "你的公钥内容" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### 3. 配置 GitHub Secrets

1. 进入 GitHub 仓库
2. 点击 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**
4. 添加以下 secrets：
   - `DEPLOY_HOST`: 服务器地址
   - `DEPLOY_USER`: SSH 用户名
   - `DEPLOY_PATH`: 部署路径
   - `DEPLOY_SSH_KEY`: SSH 私钥内容

### 4. 测试部署

```bash
# 推送到 front-dev 分支
git checkout front-dev
git push origin front-dev

# 在 GitHub 仓库的 Actions 标签页查看部署进度
```

## 手动触发

除了自动触发（推送到 front-dev 分支），也可以手动触发：

1. 进入 GitHub 仓库
2. 点击 **Actions** 标签页
3. 选择 **构建并部署到开发环境** workflow
4. 点击 **Run workflow**

## 注意事项

1. **路径权限**: 确保 `DEPLOY_USER` 对 `DEPLOY_PATH` 有写入权限
2. **SSH 密钥**: 私钥不要泄露，只添加到 GitHub Secrets
3. **服务器目录**: 确保目标目录存在，rsync 不会自动创建父目录
4. **备份**: 建议在部署前备份服务器上的现有文件
5. **Nginx 配置**: 确保 nginx 配置指向正确的目录

## 故障排查

### 1. SSH 连接失败

检查：
- `DEPLOY_HOST` 是否正确
- `DEPLOY_USER` 是否正确
- SSH 密钥是否正确添加到服务器
- 服务器防火墙是否允许 SSH 连接

### 2. Rsync 同步失败

检查：
- `DEPLOY_PATH` 路径是否存在
- 用户是否有写入权限
- 磁盘空间是否充足

### 3. 构建失败

检查：
- Node.js 版本是否正确（需要 >= 18.20.6）
- 依赖安装是否成功
- 构建命令是否正确

## 安全建议

1. 使用专用的部署用户，不要使用 root
2. 限制 SSH 密钥的权限范围
3. 定期轮换 SSH 密钥
4. 使用 SSH 密钥密码保护（可选）
5. 监控部署日志，及时发现异常

