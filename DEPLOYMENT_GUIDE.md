# AETHERIX 完整部署手册

**项目名称：** AETHERIX - Web3 原生 AI 风控生态终端  
**版本：** 1.0.0  
**最后更新：** 2026-06-30

---

## 📋 目录

1. [快速开始](#快速开始)
2. [本地开发](#本地开发)
3. [Docker 部署](#docker-部署)
4. [Vercel 部署](#vercel-部署)
5. [AWS 部署](#aws-部署)
6. [Railway 部署](#railway-部署)
7. [域名和 SSL 配置](#域名和-ssl-配置)
8. [环境变量配置](#环境变量配置)
9. [数据库初始化](#数据库初始化)
10. [监控和日志](#监控和日志)
11. [故障排查](#故障排查)

---

## 快速开始

### 前置要求

- Node.js 22+
- pnpm 10.4.1+
- MySQL 8.0+（或 TiDB）
- Docker（可选）
- Git

### 一键启动

```bash
# 克隆项目
git clone https://github.com/your-org/aetherix.git
cd aetherix

# 复制环境变量模板
cp .env.example .env

# 编辑 .env 填入实际值
nano .env

# 一键启动（选择模式）
bash start.sh dev      # 开发模式
bash start.sh prod     # 生产模式
bash start.sh docker   # Docker 模式
```

---

## 本地开发

### 1. 环境设置

```bash
# 安装依赖
pnpm install

# 初始化数据库
pnpm db:push

# 启动开发服务器
pnpm dev
```

### 2. 访问应用

- **前端：** http://localhost:5173
- **后端：** http://localhost:3000
- **API：** http://localhost:3000/api/trpc

### 3. 开发工作流

```bash
# 监听文件变化并重新构建
pnpm dev

# 运行测试
pnpm test

# 代码格式化
pnpm format

# 类型检查
pnpm check
```

---

## Docker 部署

### 1. 构建 Docker 镜像

```bash
# 构建镜像
docker build -t aetherix:latest .

# 标记镜像
docker tag aetherix:latest your-registry/aetherix:latest

# 推送到镜像仓库
docker push your-registry/aetherix:latest
```

### 2. 使用 Docker Compose

```bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f app

# 停止服务
docker-compose down

# 重启服务
docker-compose restart app
```

### 3. Docker 环境变量

编辑 `docker-compose.yml` 中的 `environment` 部分：

```yaml
environment:
  NODE_ENV: production
  DATABASE_URL: mysql://user:password@db:3306/aetherix
  GOOGLE_CLIENT_ID: your-client-id
  GOOGLE_CLIENT_SECRET: your-client-secret
  # ... 其他变量
```

---

## Vercel 部署

### 1. 连接 GitHub 仓库

1. 访问 https://vercel.com/new
2. 导入 GitHub 仓库
3. 选择 AETHERIX 项目

### 2. 配置环境变量

在 Vercel Dashboard 中：
1. 进入 **Settings → Environment Variables**
2. 添加所有 `.env.example` 中的变量

### 3. 部署

```bash
# 自动部署（推送到 main 分支）
git push origin main

# 或手动部署
vercel deploy --prod
```

### 4. 配置自定义域名

1. 在 Vercel Dashboard 中进入 **Domains**
2. 添加 `aetherix.com`
3. 按照 DNS 配置指南更新域名 DNS 记录

---

## AWS 部署

### 1. 创建 ECR 仓库

```bash
# 创建 ECR 仓库
aws ecr create-repository --repository-name aetherix --region us-east-1

# 登录 ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# 构建并推送镜像
docker build -t aetherix:latest .
docker tag aetherix:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/aetherix:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/aetherix:latest
```

### 2. 创建 RDS 数据库

```bash
# 使用 AWS CLI 创建 MySQL 实例
aws rds create-db-instance \
  --db-instance-identifier aetherix-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password YourPassword123! \
  --allocated-storage 20 \
  --region us-east-1
```

### 3. 创建 ECS 集群和任务

```bash
# 创建 ECS 集群
aws ecs create-cluster --cluster-name aetherix

# 注册任务定义
aws ecs register-task-definition --cli-input-json file://ecs-task-definition.json

# 创建服务
aws ecs create-service \
  --cluster aetherix \
  --service-name aetherix-service \
  --task-definition aetherix:1 \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxx],securityGroups=[sg-xxx]}"
```

### 4. 配置 ALB 和自定义域名

```bash
# 创建 Application Load Balancer
aws elbv2 create-load-balancer \
  --name aetherix-alb \
  --subnets subnet-xxx subnet-yyy \
  --security-groups sg-xxx

# 创建目标组
aws elbv2 create-target-group \
  --name aetherix-targets \
  --protocol HTTP \
  --port 3000 \
  --vpc-id vpc-xxx
```

---

## Railway 部署

### 1. 连接 GitHub

1. 访问 https://railway.app
2. 点击 **New Project**
3. 选择 **Deploy from GitHub**
4. 授权并选择 AETHERIX 仓库

### 2. 配置环境变量

在 Railway Dashboard 中：
1. 进入 **Variables**
2. 添加所有必要的环境变量

### 3. 添加数据库

```bash
# 在 Railway 中添加 MySQL 服务
# 自动生成 DATABASE_URL
```

### 4. 部署

```bash
# 推送到 main 分支自动部署
git push origin main

# 或使用 Railway CLI
railway up
```

---

## 域名和 SSL 配置

### 1. 购买域名

推荐平台：
- Namecheap
- GoDaddy
- Google Domains
- Cloudflare

### 2. DNS 配置

#### 指向 Vercel
```
A 记录：    76.76.19.132
CNAME 记录: www → aetherix.vercel.app
```

#### 指向 AWS
```
A 记录（Alias）: 指向 ALB DNS 名称
CNAME 记录：     www → 主域名
```

#### 指向 Railway
```
CNAME 记录: aetherix.com → xxx.railway.app
CNAME 记录: www → aetherix.com
```

### 3. SSL 证书

#### 自动 SSL（推荐）
- Vercel：自动配置
- Railway：自动配置
- AWS：使用 ACM（AWS Certificate Manager）

#### 手动 SSL（Let's Encrypt）
```bash
# 安装 Certbot
sudo apt-get install certbot python3-certbot-nginx

# 获取证书
sudo certbot certonly --standalone -d aetherix.com -d www.aetherix.com

# 自动续期
sudo systemctl enable certbot.timer
```

### 4. HTTPS 重定向

在 `nginx.conf` 中已配置（见第 80-85 行）

---

## 环境变量配置

### 必需变量

```bash
# 数据库
DATABASE_URL=mysql://user:password@host:3306/aetherix

# Google OAuth
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_CALLBACK_URL=https://aetherix.com/auth/google/callback

# JWT
JWT_SECRET=your-super-secret-key-min-32-chars

# Manus（如果使用）
VITE_APP_ID=your-app-id
OAUTH_SERVER_URL=https://api.manus.im
BUILT_IN_FORGE_API_URL=https://api.manus.im
BUILT_IN_FORGE_API_KEY=your-api-key
```

### 可选变量

```bash
# Redis 缓存
REDIS_URL=redis://localhost:6379

# 分析
VITE_ANALYTICS_ENDPOINT=https://analytics.your-domain.com
VITE_ANALYTICS_WEBSITE_ID=your-website-id

# 第三方服务
STRIPE_SECRET_KEY=your-stripe-secret-key-if-needed
SENDGRID_API_KEY=SG.xxx
SENTRY_DSN=https://xxx@sentry.io/xxx
```

---

## 数据库初始化

### 1. 创建数据库

```sql
CREATE DATABASE aetherix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 2. 运行迁移

```bash
# 生成并应用迁移
pnpm db:push

# 查看迁移状态
pnpm db:status
```

### 3. 数据库结构

```sql
-- 用户表
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  openId VARCHAR(64) UNIQUE NOT NULL,
  name TEXT,
  email VARCHAR(320),
  loginMethod VARCHAR(64),
  role ENUM('user', 'admin') DEFAULT 'user',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  lastSignedIn TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 订阅表
CREATE TABLE subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(320) UNIQUE NOT NULL,
  status ENUM('active', 'inactive', 'unsubscribed') DEFAULT 'active',
  subscribedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  unsubscribedAt TIMESTAMP NULL
);

-- 持仓表
CREATE TABLE holdings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  symbol VARCHAR(20) NOT NULL,
  amount DECIMAL(20, 8) NOT NULL,
  entryPrice DECIMAL(20, 8),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);

-- 风险预警表
CREATE TABLE risk_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  symbol VARCHAR(20) NOT NULL,
  riskLevel ENUM('low', 'medium', 'high', 'critical') NOT NULL,
  message TEXT,
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);

-- 审计日志表
CREATE TABLE audit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  action VARCHAR(100) NOT NULL,
  resource VARCHAR(100) NOT NULL,
  details JSON,
  ipHash VARCHAR(64),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);
```

---

## 监控和日志

### 1. 应用日志

```bash
# Docker 日志
docker-compose logs -f app

# Railway 日志
railway logs

# Vercel 日志
vercel logs

# AWS CloudWatch
aws logs tail /ecs/aetherix --follow
```

### 2. 性能监控

推荐工具：
- Datadog
- New Relic
- Sentry（错误追踪）
- Google Analytics（用户分析）

### 3. 健康检查

```bash
# 检查应用健康状态
curl http://localhost:3000/health

# 检查 API 可用性
curl http://localhost:3000/api/trpc/auth.me
```

---

## 故障排查

### 常见问题

#### 1. 数据库连接失败

```bash
# 检查数据库连接
mysql -h host -u user -p -e "SELECT 1"

# 查看日志
docker-compose logs db
```

#### 2. Google OAuth 登录失败

- 检查 `GOOGLE_CLIENT_ID` 和 `GOOGLE_CLIENT_SECRET`
- 验证 `GOOGLE_CALLBACK_URL` 是否正确
- 确保 Google Cloud 项目已启用 Google+ API

#### 3. SSL 证书错误

```bash
# 检查证书有效期
openssl x509 -in /etc/nginx/ssl/cert.pem -noout -dates

# 续期证书
sudo certbot renew
```

#### 4. 内存溢出

```bash
# 增加 Node.js 内存限制
NODE_OPTIONS=--max-old-space-size=4096 npm start

# 或在 Docker 中
docker run -e NODE_OPTIONS="--max-old-space-size=4096" aetherix:latest
```

### 调试模式

```bash
# 启用详细日志
DEBUG=* pnpm dev

# 启用 Node.js 调试
node --inspect-brk dist/index.js
```

---

## 性能优化

### 1. 缓存策略

```bash
# Redis 缓存
REDIS_URL=redis://localhost:6379

# CDN 缓存（Cloudflare）
- 缓存静态资源（JS、CSS、图片）
- 缓存 API 响应（可选）
```

### 2. 数据库优化

```sql
-- 创建索引
CREATE INDEX idx_users_openId ON users(openId);
CREATE INDEX idx_subscriptions_email ON subscriptions(email);
CREATE INDEX idx_holdings_userId ON holdings(userId);
CREATE INDEX idx_risk_alerts_userId ON risk_alerts(userId);
```

### 3. 前端优化

- 代码分割（Code Splitting）
- 懒加载（Lazy Loading）
- 图片优化（WebP、压缩）
- 资源预加载（Preload、Prefetch）

---

## 备份和恢复

### 1. 数据库备份

```bash
# 完整备份
mysqldump -u user -p aetherix > backup.sql

# 定时备份（Cron）
0 2 * * * mysqldump -u user -p aetherix > /backups/aetherix-$(date +\%Y\%m\%d).sql
```

### 2. 恢复数据库

```bash
# 从备份恢复
mysql -u user -p aetherix < backup.sql
```

---

## 支持和反馈

- 📧 邮件：AmenJevoson@gmail.com
- 🐛 Bug 报告：GitHub Issues
- 💬 讨论：GitHub Discussions

---

**部署完成后，请验证以下检查清单：**

- [ ] 应用可访问
- [ ] Google OAuth 登录正常
- [ ] 数据库连接正常
- [ ] SSL 证书有效
- [ ] 日志正常输出
- [ ] 性能监控已配置
- [ ] 备份已设置
- [ ] 域名 DNS 已配置
- [ ] SEO 配置已完成

**祝部署顺利！🚀**
