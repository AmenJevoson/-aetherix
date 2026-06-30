# AETHERIX MacBook Pro 部署指南

**完整的一步一步操作指南，让您在 MacBook Pro 上快速部署 AETHERIX**

---

## 📋 目录

1. [前置准备](#前置准备)
2. [本地开发环境设置](#本地开发环境设置)
3. [项目下载和配置](#项目下载和配置)
4. [后端验证和测试](#后端验证和测试)
5. [前端启动](#前端启动)
6. [Vercel 部署](#vercel-部署)
7. [Cloudflare 配置](#cloudflare-配置)
8. [获客和宣传策略](#获客和宣传策略)

---

## 前置准备

### 步骤 1：检查 MacBook 系统

打开 **Terminal**（终端）：

```bash
# 按 Command + Space，输入 "Terminal"，按 Enter

# 检查 macOS 版本
sw_vers

# 输出应该显示：
# ProductName:    macOS
# ProductVersion: 14.x 或更高
```

### 步骤 2：安装 Homebrew（Mac 包管理器）

如果还没有安装，执行：

```bash
# 复制粘贴以下命令到 Terminal
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 按 Enter，输入 Mac 密码（密码不会显示，直接输入即可）
# 等待安装完成（通常 5-10 分钟）
```

验证安装：

```bash
brew --version
# 输出应该显示：Homebrew 4.x.x
```

### 步骤 3：安装 Node.js 和 pnpm

```bash
# 安装 Node.js（包含 npm）
brew install node

# 验证 Node.js
node --version
# 输出应该显示：v22.x.x 或更高

npm --version
# 输出应该显示：10.x.x 或更高

# 安装 pnpm（项目包管理器）
npm install -g pnpm

# 验证 pnpm
pnpm --version
# 输出应该显示：10.x.x 或更高
```

### 步骤 4：安装 Git

```bash
brew install git

# 验证 Git
git --version
# 输出应该显示：git version 2.x.x
```

### 步骤 5：配置 Git（第一次使用）

```bash
# 设置用户名
git config --global user.name "Your Name"

# 设置邮箱
git config --global user.email "AmenJevoson@gmail.com"

# 验证配置
git config --global --list
```

---

## 本地开发环境设置

### 步骤 1：创建项目目录

```bash
# 打开 Terminal

# 进入用户主目录
cd ~

# 创建项目文件夹
mkdir -p Projects/aetherix
cd Projects/aetherix

# 验证位置
pwd
# 输出应该显示：/Users/YourUsername/Projects/aetherix
```

### 步骤 2：安装 VS Code（推荐编辑器）

```bash
# 安装 VS Code
brew install --cask visual-studio-code

# 验证安装
code --version
```

打开 VS Code：

```bash
# 在当前项目目录中打开 VS Code
code .
```

### 步骤 3：在 VS Code 中打开 Terminal

在 VS Code 中：
- 按 `Control + ~`（或 `Command + ~`）
- 或进入 **View → Terminal**

现在您可以在 VS Code 的集成 Terminal 中运行命令。

---

## 项目下载和配置

### 步骤 1：获取项目代码

**选项 A：从 GitHub 克隆（如果已上传）**

```bash
cd ~/Projects/aetherix

# 克隆项目
git clone https://github.com/YourUsername/aetherix.git .

# 如果还没有上传到 GitHub，跳到选项 B
```

**选项 B：从 Manus 导出（推荐）**

1. 登录 Manus Management UI
2. 进入 AETHERIX 项目
3. 点击 **More (⋯) → Download as ZIP**
4. 解压到 `~/Projects/aetherix`

### 步骤 2：安装依赖

```bash
# 确保在项目根目录
cd ~/Projects/aetherix

# 安装所有依赖
pnpm install

# 这会下载所有 npm 包（通常 3-5 分钟）
# 完成后显示：✓ Packages in scope: aetherix
```

### 步骤 3：配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 在 VS Code 中打开 .env 文件
code .env
```

**编辑 .env 文件，填入以下信息：**

```env
# 数据库连接（使用 Manus 提供的）
DATABASE_URL=mysql://user:password@host:3306/aetherix

# Google OAuth 凭证（使用新创建的凭证）
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-client-secret
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# JWT 密钥（生成随机字符串）
JWT_SECRET=your-random-secret-key-here-min-32-chars

# Manus OAuth（已自动配置）
VITE_APP_ID=your-app-id
OAUTH_SERVER_URL=https://oauth.manus.im
VITE_OAUTH_PORTAL_URL=https://oauth.manus.im/portal

# LLM API（Manus 内置，自动配置）
BUILT_IN_FORGE_API_URL=https://api.manus.im
BUILT_IN_FORGE_API_KEY=your-api-key
```

**保存文件：** `Command + S`

### 步骤 4：初始化数据库

```bash
# 在 Terminal 中运行
pnpm db:push

# 输出应该显示：
# ✓ Migrations applied successfully
# ✓ Database schema updated
```

---

## 后端验证和测试

### 步骤 1：启动后端服务器

```bash
# 在 Terminal 中运行
pnpm dev

# 输出应该显示：
# ➜  Local:   http://localhost:3000
# ➜  API:     http://localhost:3000/api/trpc
```

**保持 Terminal 运行，不要关闭！**

### 步骤 2：验证后端 AI 功能

打开**新的 Terminal 窗口**（`Command + T`）：

```bash
# 测试 AI 自动调度系统
curl -X POST http://localhost:3000/api/trpc/riskControl.predictMarketTrend \
  -H "Content-Type: application/json" \
  -d '{
    "symbol": "BTC",
    "timeframe": "1h",
    "context": "Bitcoin showing strong support at $42,000"
  }'

# 输出应该显示 AI 的分析结果
```

### 步骤 3：验证 Google OAuth

打开浏览器访问：

```
http://localhost:3000/login
```

您应该看到：
- ✅ Google 登录按钮
- ✅ 邮箱登录表单
- ✅ 深空赛博金融设计风格

### 步骤 4：运行测试

在**第三个 Terminal 窗口**中：

```bash
# 运行所有测试
pnpm test

# 输出应该显示：
# ✓ auth.logout.test.ts
# ✓ ai-orchestrator.test.ts
# ✓ risk-control.test.ts
# ...
# Test Files  3 passed (3)
```

---

## 前端启动

### 步骤 1：打开前端开发服务器

在第一个 Terminal 窗口中（已运行 `pnpm dev`），您应该看到：

```
➜  Frontend: http://localhost:5173
➜  Backend:  http://localhost:3000
```

### 步骤 2：在浏览器中访问

打开浏览器，访问：

```
http://localhost:5173
```

您应该看到：
- ✅ AETHERIX 首页（深空赛博金融设计）
- ✅ 7 大风控功能卡片
- ✅ 实时数据可视化
- ✅ Google 登录按钮
- ✅ 完整的页脚

### 步骤 3：测试完整流程

1. **点击 "登录" 按钮**
   - 选择 Google 登录
   - 使用您的 Google 账户登录
   - 应该重定向回首页，显示已登录状态

2. **测试风控功能**
   - 点击 "行情预判推演"
   - 输入加密货币符号（如 BTC）
   - 应该看到 AI 的实时分析

3. **测试其他功能**
   - 暗盘隐性风险预警
   - 持仓 AI 风控保镖
   - 舆情真假过滤
   - 等等

---

## Vercel 部署

### 步骤 1：创建 Vercel 账户

1. 访问 https://vercel.com
2. 点击 **Sign Up**
3. 选择 **GitHub**（或其他方式）
4. 授权连接

### 步骤 2：上传项目到 GitHub

```bash
# 在项目目录中初始化 Git
git init

# 添加所有文件
git add .

# 创建首次提交
git commit -m "Initial AETHERIX deployment"

# 添加远程仓库（替换为您的 GitHub 用户名）
git remote add origin https://github.com/YourUsername/aetherix.git

# 推送到 GitHub
git push -u origin main
```

### 步骤 3：在 Vercel 中导入项目

1. 登录 Vercel Dashboard：https://vercel.com/dashboard
2. 点击 **Add New → Project**
3. 选择 **Import Git Repository**
4. 搜索并选择 `aetherix`
5. 点击 **Import**

### 步骤 4：配置环境变量

在 Vercel 中：

1. 进入 **Settings → Environment Variables**
2. 添加以下变量（与 .env 相同）：

```
DATABASE_URL=mysql://...
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-client-secret
GOOGLE_CALLBACK_URL=https://aetherix.vercel.app/auth/google/callback
JWT_SECRET=...
```

### 步骤 5：部署

1. 点击 **Deploy**
2. 等待部署完成（通常 3-5 分钟）
3. 获得免费 Vercel 子域名：`https://aetherix.vercel.app`

### 步骤 6：验证部署

访问 `https://aetherix.vercel.app`，确保：
- ✅ 首页正常加载
- ✅ Google 登录可用
- ✅ 所有功能正常工作

---

## Cloudflare 配置

### 步骤 1：在 Cloudflare 中添加网站

1. 访问 https://dash.cloudflare.com
2. 点击 **Add a Site**
3. 输入 `aetherix.com`
4. 点击 **Add Site**
5. 选择 **Free Plan**

### 步骤 2：更新 Nameservers

Cloudflare 会显示 2 个 Nameservers。在 Namecheap 中：

1. 登录 Namecheap
2. 进入 **Domain List → Manage aetherix.com**
3. 进入 **Nameservers** 标签
4. 选择 **Custom DNS**
5. 输入 Cloudflare 的 Nameservers
6. 点击 **Save**

### 步骤 3：配置 DNS 记录

在 Cloudflare 中，进入 **DNS** 标签，添加：

```
记录 1：
Type: A
Name: aetherix.com
Content: 76.76.19.132（Vercel IP）
TTL: Auto
Proxy: Proxied（橙色云）

记录 2：
Type: CNAME
Name: www
Content: cname.vercel-dns.com
TTL: Auto
Proxy: Proxied（橙色云）
```

### 步骤 4：启用 Cloudflare 功能

在 Cloudflare 中启用：

- **Caching → Cache Everything**
- **Speed → Auto Minify**（CSS、JS、HTML）
- **Speed → Brotli Compression**
- **Security → WAF**

---

## 获客和宣传策略

### 🎯 第 1 阶段：种子用户（第 1-2 周）

**目标：** 获得 100-500 个初期用户

**渠道 1：Twitter/X（最重要）**

```
发布内容：
1. 产品发布推文
   "🚀 AETHERIX 上线！
   Web3 原生 AI 风控生态终端
   7×24 小时全周期 AI 庇护体系
   行情预判 | 暗盘预警 | 持仓守护 | 舆情过滤
   
   🔗 https://aetherix.com
   
   #Web3 #AI #Crypto"

2. 功能演示推文
   每天发布 1 个风控功能的演示视频

3. 用户评价推文
   分享早期用户的反馈和成功案例

频率：每天 1-2 条
```

**渠道 2：Telegram 社区**

```
1. 创建 AETHERIX 官方 Telegram 群
2. 发布产品更新和功能演示
3. 与用户互动，收集反馈
4. 邀请 KOL 加入并推荐

目标：500-1000 人社区
```

**渠道 3：Discord 社区**

```
1. 创建 AETHERIX Discord 服务器
2. 设置频道：
   - #announcements（公告）
   - #features（功能展示）
   - #support（技术支持）
   - #feedback（用户反馈）
3. 邀请 Web3 爱好者加入

目标：1000-5000 人社区
```

**渠道 4：Reddit**

```
1. 在 r/cryptocurrency、r/defi、r/web3 发布
2. 标题示例：
   "AETHERIX - 全球首个 Web3 原生 AI 风控平台"
3. 描述产品独特价值
4. 邀请用户测试和反馈

目标：500-1000 点赞
```

### 🎯 第 2 阶段：社区增长（第 3-4 周）

**渠道 1：KOL 合作**

```
1. 联系加密货币 KOL
   - 关注者 10K-100K 的 Twitter 账户
   - 邀请他们测试产品
   - 提供独家功能或奖励

2. 邀请他们发布推荐推文
   
3. 提供佣金或代币激励
```

**渠道 2：加密论坛**

```
1. BitcoinTalk
   - 发布项目介绍帖
   - 邀请社区反馈

2. 币乎（中文社区）
   - 发布产品文章
   - 分享技术细节

3. Steemit
   - 发布长文章
   - 获得社区投票
```

**渠道 3：产品发布平台**

```
1. Product Hunt
   - 发布产品
   - 争取首页推荐
   - 目标：500+ 点赞

2. Hacker News
   - 发布技术文章
   - 分享架构设计

3. IndieHackers
   - 分享创业故事
   - 获得反馈
```

### 🎯 第 3 阶段：付费获客（第 5+ 周）

**渠道 1：Google Ads**

```
关键词：
- "AI crypto risk management"
- "blockchain risk protection"
- "DeFi risk analysis"
- "crypto portfolio protection"

预算：$500-1000/月
目标：CPA $5-10
```

**渠道 2：Twitter Ads**

```
目标受众：
- 加密货币投资者
- DeFi 用户
- Web3 开发者

预算：$500-1000/月
目标：CPA $3-5
```

**渠道 3：Telegram 广告**

```
1. 在热门 Telegram 频道投放广告
2. 目标频道：
   - 加密货币交易频道
   - DeFi 频道
   - Web3 频道

预算：$200-500/月
目标：CPA $2-4
```

### 📊 SEO 优化（长期）

**关键词目标：**

```
第 1 个月：
- "AI crypto risk"
- "blockchain risk management"
- "DeFi protection"

第 3 个月：
- 排名前 10

第 6 个月：
- 排名前 3
- 每月 5000+ 自然流量
```

**内容策略：**

```
1. 发布 10 篇深度文章
   - "如何使用 AI 预测加密市场"
   - "DeFi 风险识别指南"
   - "区块链风险管理最佳实践"

2. 创建视频教程
   - YouTube 频道
   - 每周 1 个视频
   - 目标：1000+ 订阅

3. 发布案例研究
   - 用户成功案例
   - 风险避免案例
```

### 📈 增长指标

**第 1 周目标：**
- 100 个用户
- 1000 个 Twitter 粉丝
- 500 个 Telegram 成员

**第 2 周目标：**
- 500 个用户
- 5000 个 Twitter 粉丝
- 2000 个 Telegram 成员

**第 4 周目标：**
- 2000 个用户
- 20000 个 Twitter 粉丝
- 10000 个 Telegram 成员

**第 8 周目标：**
- 10000 个用户
- 50000 个 Twitter 粉丝
- 30000 个 Telegram 成员

---

## 🚀 完整部署检查清单

### 本地开发
- [ ] Node.js 已安装
- [ ] pnpm 已安装
- [ ] 项目依赖已安装
- [ ] .env 已配置
- [ ] 数据库已初始化
- [ ] 后端已启动（`pnpm dev`）
- [ ] 前端已启动（http://localhost:5173）
- [ ] Google OAuth 可用
- [ ] AI 功能已测试
- [ ] 所有测试通过

### Vercel 部署
- [ ] GitHub 账户已创建
- [ ] 项目已上传到 GitHub
- [ ] Vercel 账户已创建
- [ ] 项目已导入 Vercel
- [ ] 环境变量已配置
- [ ] 部署已完成
- [ ] 验证部署成功（https://aetherix.vercel.app）

### 域名和 DNS
- [ ] aetherix.com 已购买
- [ ] Cloudflare 账户已创建
- [ ] Nameservers 已更新
- [ ] DNS 记录已配置
- [ ] SSL 证书已生效
- [ ] 验证 https://aetherix.com 可访问

### 宣传和获客
- [ ] Twitter 账户已创建
- [ ] Telegram 群已创建
- [ ] Discord 服务器已创建
- [ ] 首批推文已发布
- [ ] KOL 已联系
- [ ] Product Hunt 已发布
- [ ] 监控增长指标

---

## 🆘 常见问题

### Q1：后端无法启动

```bash
# 检查 Node.js 版本
node --version

# 检查依赖是否完整
pnpm install

# 检查环境变量
cat .env

# 查看错误日志
pnpm dev 2>&1 | tail -50
```

### Q2：Google OAuth 不工作

```bash
# 检查 Google OAuth 凭证
echo $GOOGLE_CLIENT_ID
echo $GOOGLE_CLIENT_SECRET

# 检查回调 URL 是否正确
# 本地：http://localhost:3000/auth/google/callback
# 生产：https://aetherix.com/auth/google/callback
```

### Q3：数据库连接失败

```bash
# 检查数据库连接字符串
echo $DATABASE_URL

# 测试数据库连接
mysql -h host -u user -p

# 查看数据库日志
tail -100 /var/log/mysql/error.log
```

### Q4：DNS 不生效

```bash
# 检查 DNS 记录
nslookup aetherix.com

# 详细 DNS 查询
dig aetherix.com

# 等待 DNS 传播（最长 48 小时）
# 使用 https://www.whatsmydns.net/?d=aetherix.com 检查
```

---

## 📞 获取帮助

- 📧 邮箱：AmenJevoson@gmail.com
- 🐦 Twitter：@aetherix
- 💬 Telegram：https://t.me/aetherix
- 📖 文档：https://aetherix.com/docs

---

**现在您已经拥有完整的 MacBook Pro 部署指南！按照步骤操作，您将在 1 小时内完成本地部署，24 小时内完成全球上线。🚀**
