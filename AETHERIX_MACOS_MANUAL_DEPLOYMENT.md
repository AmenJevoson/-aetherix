# AETHERIX Web3 AI 风控平台 - MacBook Pro M5 纯手动部署指南

**⚠️ 重要提示：本文档所有操作都是您手动点击、手动输入，没有任何 AI 自动执行。每一步都清楚标注了作用和踩坑点。**

---

## 📑 文档导航

- [第一阶段：Mac 本地完整部署自测](#第一阶段mac-本地完整部署自测)
- [第二阶段：全球公网上线](#第二阶段全球公网上线)
- [上线前自检清单](#上线前自检清单)

---

# 第一阶段：Mac 本地完整部署自测

**目标：** 在您的 MacBook Pro M5 上完整运行 AETHERIX，测试所有功能（Google 登录、AI 风控、后端接口）

**预计耗时：** 1.5 小时

---

## 第 1 步：打开 Mac 终端

**作用：** 打开命令行工具，用来安装软件和启动项目

**操作步骤：**

1. 按住键盘上的 **Command（⌘）+ 空格**
2. 在弹出的搜索框中输入 `terminal`
3. 看到 "Terminal" 出现，按 **Enter** 键
4. 一个黑色窗口打开了，这就是终端

**踩坑点：**
- ❌ 不要用 Spotlight 搜索 "命令行"，要搜 "terminal"
- ✅ 第一次打开可能需要输入 Mac 密码，这是正常的

---

## 第 2 步：检查 Mac 是否已安装 Homebrew（软件管理器）

**作用：** Homebrew 是 Mac 上的"应用商店"，用来快速安装 Node.js 等开发工具

**操作步骤：**

在终端中输入以下命令，然后按 **Enter**：

```
brew --version
```

**看到的结果：**

- ✅ **如果显示** `Homebrew 4.x.x` → 已安装，跳到第 3 步
- ❌ **如果显示** `command not found` → 需要安装，继续看下面

**如果需要安装 Homebrew：**

在终端中复制粘贴以下命令，按 **Enter**：

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

然后：
1. 按 **Enter** 确认
2. 输入您的 Mac 密码（密码不会显示，直接输入即可）
3. 按 **Enter**
4. 等待安装完成（通常 5-10 分钟，会看到很多绿色的 ✓ 符号）

**踩坑点：**
- ❌ 安装过程中不要关闭终端
- ⚠️ 输入密码时屏幕上看不到字符，这是正常的，直接输入即可
- ✅ 看到 "Installation successful!" 就说明安装完了

---

## 第 3 步：安装 Node.js（JavaScript 运行环境）

**作用：** Node.js 是运行 AETHERIX 后端的必需工具

**操作步骤：**

在终端中输入：

```
brew install node
```

然后按 **Enter**，等待安装完成（通常 2-3 分钟）

**验证安装成功：**

在终端中输入：

```
node --version
```

按 **Enter**，应该看到类似 `v22.x.x` 的版本号

**踩坑点：**
- ❌ 如果显示 `command not found`，说明安装失败，重新运行上面的安装命令
- ✅ M5 芯片的 Mac 会自动下载 ARM64 版本，无需手动选择

---

## 第 4 步：安装 pnpm（项目包管理器）

**作用：** pnpm 是 AETHERIX 项目使用的包管理工具，用来安装项目的所有依赖

**操作步骤：**

在终端中输入：

```
npm install -g pnpm
```

按 **Enter**，等待安装完成（通常 1 分钟）

**验证安装成功：**

在终端中输入：

```
pnpm --version
```

按 **Enter**，应该看到类似 `10.x.x` 的版本号

**踩坑点：**
- ✅ 这一步通常不会出错，因为 npm 已经随 Node.js 安装了

---

## 第 5 步：安装 Git（版本控制工具）

**作用：** Git 用来管理代码版本，后面上传到 GitHub 时需要用到

**操作步骤：**

在终端中输入：

```
brew install git
```

按 **Enter**，等待安装完成（通常 1 分钟）

**验证安装成功：**

在终端中输入：

```
git --version
```

按 **Enter**，应该看到类似 `git version 2.x.x` 的版本号

---

## 第 6 步：创建项目文件夹

**作用：** 为 AETHERIX 项目创建一个专门的文件夹，方便管理

**操作步骤：**

在终端中依次输入以下命令，每行按 **Enter**：

```
cd ~
```

这会进入您的 Mac 用户主文件夹

然后输入：

```
mkdir -p Projects/aetherix
```

这会创建一个 `Projects/aetherix` 文件夹

然后输入：

```
cd Projects/aetherix
```

这会进入刚才创建的文件夹

**验证成功：**

在终端中输入：

```
pwd
```

按 **Enter**，应该看到类似 `/Users/YourName/Projects/aetherix` 的路径

**踩坑点：**
- ✅ 这些命令只是创建文件夹，不会删除任何东西，放心操作

---

## 第 7 步：获取 AETHERIX 项目代码

**作用：** 把 AETHERIX 的完整代码下载到您的电脑

**有两种方式选一种：**

### 方式 A：从 Manus 平台下载（推荐新手）

1. 登录 Manus Management UI
2. 进入 AETHERIX 项目
3. 点击右上角 **More (⋯)** 菜单
4. 选择 **Download as ZIP**
5. 等待下载完成（通常 1-2 分钟）
6. 打开 Mac 的 **Finder**（访达）
7. 进入 **Downloads** 文件夹
8. 找到 `aetherix.zip` 文件
9. 双击解压
10. 把解压后的文件夹中的所有内容复制到 `~/Projects/aetherix` 文件夹

### 方式 B：从 GitHub 克隆（需要 GitHub 账户）

如果您已经把代码上传到 GitHub，在终端中输入：

```
git clone https://github.com/YourUsername/aetherix.git .
```

（把 `YourUsername` 替换成您的 GitHub 用户名）

**踩坑点：**
- ✅ 方式 A 更简单，推荐先用这个
- ❌ 解压后要把文件放在 `~/Projects/aetherix` 文件夹里，不要放在 Downloads 里

---

## 第 8 步：安装项目依赖

**作用：** 下载 AETHERIX 项目需要的所有 npm 包和库

**操作步骤：**

确保您在 `~/Projects/aetherix` 文件夹中（可以在终端中看到 `aetherix` 字样），然后输入：

```
pnpm install
```

按 **Enter**，然后**等待**（这会花 3-5 分钟，会看到很多下载进度）

**完成标志：**

看到终端显示：

```
✓ Packages in scope: aetherix
```

说明依赖安装完了

**踩坑点：**
- ⚠️ 这一步不要中断，即使看起来很慢也要等
- ❌ 如果看到红色的 `ERR!` 错误，检查网络连接，然后重新运行命令
- ✅ M5 芯片的 Mac 会自动识别，不需要特殊配置

---

## 第 9 步：配置环境变量文件

**作用：** 设置项目需要的各种密钥和配置（比如 Google OAuth 凭证、数据库连接等）

**操作步骤：**

1. 在 Mac 上打开 **VS Code**（如果没有安装，先运行 `brew install --cask visual-studio-code`）
2. 在 VS Code 中点击 **File → Open Folder**
3. 选择 `~/Projects/aetherix` 文件夹，点 **Open**
4. 在左边的文件列表中，找到 `.env.example` 文件
5. 右键点击 `.env.example`，选择 **Copy**
6. 右键点击空白处，选择 **Paste**
7. 把新文件重命名为 `.env`（删除 `.example` 部分）
8. 双击打开 `.env` 文件

**现在编辑 .env 文件，填入以下内容：**

```
# ========== 本地开发配置 ==========

# Google OAuth 本地测试配置（后面会详细说明如何获取）
GOOGLE_CLIENT_ID=YOUR_LOCAL_CLIENT_ID
GOOGLE_CLIENT_SECRET=YOUR_LOCAL_CLIENT_SECRET
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# JWT 密钥（随意填一个 32 位以上的字符串，比如）
JWT_SECRET=your-super-secret-key-min-32-characters-long-12345

# Manus OAuth（这些是系统自动配置的，暂时用这些占位符）
VITE_APP_ID=local-dev-app-id
OAUTH_SERVER_URL=https://oauth.manus.im
VITE_OAUTH_PORTAL_URL=https://oauth.manus.im/portal

# 数据库连接（本地开发用 SQLite）
DATABASE_URL=file:./dev.db

# LLM API（Manus 内置，这些是占位符）
BUILT_IN_FORGE_API_URL=https://api.manus.im
BUILT_IN_FORGE_API_KEY=local-dev-key
```

**保存文件：** 按 **Command + S**

**踩坑点：**
- ⚠️ `.env` 文件包含敏感信息，**不要上传到 GitHub**（.gitignore 已经配置好了）
- ❌ 不要在 `.env` 中使用中文，只用英文和数字
- ✅ 现在先用占位符，后面会替换成真实的 Google OAuth 凭证

---

## 第 10 步：初始化数据库

**作用：** 创建 AETHERIX 需要的数据库表（用户表、订阅表、风控记录表等）

**操作步骤：**

在终端中输入：

```
pnpm db:push
```

按 **Enter**，等待完成（通常 30 秒）

**完成标志：**

看到终端显示：

```
✓ Migrations applied successfully
```

说明数据库初始化完了

**踩坑点：**
- ✅ 这一步会自动创建 `dev.db` 文件，这是本地数据库
- ❌ 如果出错，检查 `.env` 中的 `DATABASE_URL` 是否正确

---

## 第 11 步：配置 Google OAuth 本地测试凭证

**作用：** 让您能在本地电脑上测试 Google 登录功能

**这一步需要您在 Google Cloud 上创建项目和凭证。详细步骤如下：**

### 步骤 11.1：创建 Google Cloud 项目

1. 打开浏览器，访问 https://console.cloud.google.com
2. 用您的 Google 账户登录（AmenJevoson@gmail.com）
3. 看到左上角有个蓝色的 **Google Cloud** 标志，旁边有个下拉菜单
4. 点击那个下拉菜单
5. 点击 **NEW PROJECT**
6. 在弹出窗口中，**Project name** 输入 `AETHERIX-Local`
7. 点击 **CREATE**
8. 等待项目创建完成（通常 1 分钟）

### 步骤 11.2：启用 Google+ API

1. 在 Google Cloud Console 中，顶部有个搜索框
2. 搜索 `Google+ API`
3. 点击第一个结果
4. 点击 **ENABLE** 按钮
5. 等待启用完成

### 步骤 11.3：配置 OAuth 同意屏幕

1. 在左边菜单中，找到 **APIs & Services**
2. 点击 **OAuth consent screen**
3. 选择 **External**（外部用户）
4. 点击 **CREATE**
5. 填写表单：
   - **App name**：输入 `AETHERIX`
   - **User support email**：输入 `AmenJevoson@gmail.com`
   - **Developer contact**：输入 `AmenJevoson@gmail.com`
6. 点击 **SAVE AND CONTINUE**
7. 在 **Scopes** 页面，点击 **SAVE AND CONTINUE**（保持默认）
8. 在 **Test users** 页面，点击 **ADD USERS**
9. 输入 `AmenJevoson@gmail.com`
10. 点击 **ADD**
11. 点击 **SAVE AND CONTINUE**

### 步骤 11.4：创建 OAuth 2.0 凭证（本地测试用）

1. 在左边菜单中，点击 **Credentials**
2. 点击 **+ CREATE CREDENTIALS**
3. 选择 **OAuth client ID**
4. 如果弹出警告，点击 **CONFIGURE CONSENT SCREEN**，然后回到第 2 步
5. 在 **Application type** 中选择 **Web application**
6. **Name** 输入 `AETHERIX-Local-Dev`
7. 在 **Authorized JavaScript origins** 中，点击 **+ ADD URI**
8. 输入 `http://localhost:3000`
9. 再点击 **+ ADD URI**
10. 输入 `http://localhost:5173`
11. 在 **Authorized redirect URIs** 中，点击 **+ ADD URI**
12. 输入 `http://localhost:3000/auth/google/callback`
13. 点击 **CREATE**
14. 弹出窗口显示 **Client ID** 和 **Client Secret**
15. **复制 Client ID**，粘贴到记事本中（待会要用）
16. **复制 Client Secret**，也粘贴到记事本中

**踩坑点：**
- ⚠️ **本地测试用的 Client ID 和 Client Secret 只能用于 localhost，不能用于线上域名**
- ✅ 记住这两个值，待会要填进 `.env` 文件

### 步骤 11.5：更新 .env 文件

回到 VS Code，打开 `.env` 文件，把刚才记下的值填进去：

```
GOOGLE_CLIENT_ID=你复制的Client_ID
GOOGLE_CLIENT_SECRET=你复制的Client_Secret
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback
```

保存文件：**Command + S**

---

## 第 12 步：启动后端服务器

**作用：** 运行 AETHERIX 的后端，这样才能处理 AI 风控、Google 登录等功能

**操作步骤：**

在终端中输入：

```
pnpm dev
```

按 **Enter**

**看到的输出：**

终端会显示类似这样的信息：

```
➜  Local:   http://localhost:3000
➜  Frontend: http://localhost:5173
➜  API:     http://localhost:3000/api/trpc
```

这说明后端已经启动了！

**⚠️ 重要：保持这个终端窗口打开，不要关闭！**

**踩坑点：**
- ❌ 如果显示 `Port 3000 already in use`，说明有其他程序占用了这个端口，需要关闭那个程序或改用其他端口
- ✅ 看到上面的输出就说明成功了

---

## 第 13 步：打开新的终端窗口，启动前端

**作用：** 在浏览器中看到 AETHERIX 的界面

**操作步骤：**

1. 在 Mac 上按 **Command + T**（在 VS Code 中）或打开新的 Terminal 窗口
2. 确保您在 `~/Projects/aetherix` 文件夹中
3. 输入：

```
cd ~/Projects/aetherix
```

然后按 **Enter**

4. 输入：

```
pnpm dev
```

按 **Enter**

**看到的输出：**

终端会显示：

```
➜  Frontend: http://localhost:5173
```

这说明前端已经启动了！

**踩坑点：**
- ✅ 现在您有两个终端窗口在运行，一个后端（3000 端口），一个前端（5173 端口）
- ❌ 都不要关闭

---

## 第 14 步：在浏览器中打开 AETHERIX

**作用：** 看到 AETHERIX 的首页和所有功能

**操作步骤：**

1. 打开 Mac 上的浏览器（Safari、Chrome 或 Firefox 都可以）
2. 在地址栏中输入：

```
http://localhost:5173
```

按 **Enter**

**看到的画面：**

您应该看到 AETHERIX 的首页，包括：
- ✅ 顶部导航栏（AETHERIX Logo、登录按钮）
- ✅ Hero 区域（标题、副标题）
- ✅ 7 个风控功能卡片（行情预判、暗盘预警等）
- ✅ 深空赛博金融设计风格

**踩坑点：**
- ❌ 如果显示 `Cannot GET /`，检查前端是否启动了（看第二个终端窗口）
- ✅ 如果页面加载很慢，等待 10 秒，可能是第一次编译

---

## 第 15 步：测试 Google 登录

**作用：** 验证 Google OAuth 是否正常工作

**操作步骤：**

1. 在 AETHERIX 首页上，点击右上角的 **登录** 按钮
2. 看到登录页面，点击 **使用 Google 登录** 按钮
3. 浏览器会跳转到 Google 登录页面
4. 用您的 Google 账户登录（AmenJevoson@gmail.com）
5. Google 会要求您授权 AETHERIX 访问您的信息，点击 **允许**
6. 浏览器会跳转回 AETHERIX，显示您已登录

**看到的标志：**
- ✅ 页面右上角显示您的 Google 账户名
- ✅ 可以看到 **登出** 按钮

**踩坑点：**
- ❌ 如果显示 `redirect_uri_mismatch` 错误，检查 Google Cloud 中配置的回调 URL 是否正确
- ✅ 本地测试时回调 URL 必须是 `http://localhost:3000/auth/google/callback`

---

## 第 16 步：测试 AI 风控功能

**作用：** 验证后端 AI 自动调度系统是否正常工作

**操作步骤：**

1. 登录后，在首页上找到 **行情预判推演** 卡片
2. 点击卡片中的 **立即体验** 按钮
3. 弹出一个对话框，输入一个加密货币符号，比如 `BTC`
4. 点击 **分析** 按钮
5. 等待 AI 分析（通常 5-10 秒）

**看到的结果：**
- ✅ AI 会返回关于 BTC 的市场分析
- ✅ 包含价格预测、风险评估等内容

**踩坑点：**
- ⚠️ 第一次调用 AI 可能会比较慢，因为模型需要加载
- ❌ 如果显示错误，检查后端终端窗口是否有错误信息
- ✅ 如果能看到 AI 的分析结果，说明整个系统都正常了！

---

## 第 17 步：测试其他功能

**作用：** 确保所有 7 大风控功能都能正常工作

**操作步骤：**

在首页上，逐个点击以下卡片，测试每个功能：

1. **暗盘隐性风险预警** - 输入币种，看是否有风险提示
2. **持仓 AI 风控保镖** - 输入您的持仓信息，看 AI 的建议
3. **交易风格定制推送** - 设置您的交易偏好
4. **舆情真假过滤** - 输入一条新闻，看 AI 的真假判断
5. **极端行情急救系统** - 模拟市场暴跌场景
6. **悬浮 AI 对话舱** - 点击右下角的 AI 按钮，和 AI 对话

**踩坑点：**
- ✅ 所有功能都应该能正常响应
- ❌ 如果某个功能不工作，检查后端是否有错误

---

## 第 18 步：查看数据库

**作用：** 验证数据是否正确保存到数据库

**操作步骤：**

1. 在 VS Code 中，找到项目根目录下的 `dev.db` 文件
2. 右键点击 `dev.db`
3. 选择 **Open with → SQLite Viewer**（如果没有这个选项，先安装 SQLite 扩展）
4. 可以看到数据库中的所有表：
   - `users` - 用户表
   - `subscriptions` - 订阅记录表
   - `risk_alerts` - 风险预警表
   - 等等

**踩坑点：**
- ✅ 这一步是可选的，主要是验证数据是否保存
- ❌ 如果看不到表，说明数据库初始化可能有问题

---

## 第 19 步：查看后端 API 文档

**作用：** 了解所有可用的 API 接口（为后面的线上部署做准备）

**操作步骤：**

在 VS Code 中，打开 `API_DOCUMENTATION.md` 文件，可以看到：

- **7 大风控功能的 API 端点**
- **每个端点的请求和响应格式**
- **错误处理方式**
- **速率限制**

**重要的 API 端点：**

```
POST /api/trpc/riskControl.predictMarketTrend
POST /api/trpc/riskControl.detectDarkPoolRisks
POST /api/trpc/riskControl.protectPortfolio
POST /api/trpc/riskControl.filterSentiment
POST /api/trpc/riskControl.emergencyRescue
POST /api/trpc/chat.sendMessage
```

**踩坑点：**
- ✅ 这些 API 在本地是 `http://localhost:3000/api/trpc/...`
- ⚠️ 线上部署后会变成 `https://aetherix.com/api/trpc/...`

---

## 第 20 步：查看数据库 Schema

**作用：** 了解数据库结构（为后面的线上部署做准备）

**操作步骤：**

在 VS Code 中，打开 `DATABASE_SCHEMA.md` 文件，可以看到：

- **8 张核心业务表的详细说明**
- **每个字段的数据类型和含义**
- **索引策略**
- **数据安全措施（加密、脱敏）**

**核心表：**

| 表名 | 作用 |
|------|------|
| `users` | 存储用户信息 |
| `subscriptions` | 存储订阅记录 |
| `risk_alerts` | 存储风险预警 |
| `market_predictions` | 存储行情预测 |
| `portfolio_tracking` | 存储持仓跟踪 |
| `sentiment_analysis` | 存储舆情分析 |
| `emergency_alerts` | 存储急救预警 |
| `ai_interactions` | 存储 AI 对话记录 |

**踩坑点：**
- ✅ 所有敏感数据（邮箱、钱包地址）都会被加密存储
- ✅ 用户的持仓数量会被脱敏处理

---

## ✅ 第一阶段完成检查

现在您已经完成了本地部署！检查以下项目是否都完成了：

- [ ] Mac 上安装了 Homebrew、Node.js、pnpm、Git
- [ ] 创建了 `~/Projects/aetherix` 文件夹
- [ ] 下载了 AETHERIX 项目代码
- [ ] 运行了 `pnpm install` 安装依赖
- [ ] 配置了 `.env` 文件
- [ ] 运行了 `pnpm db:push` 初始化数据库
- [ ] 配置了 Google OAuth 本地凭证
- [ ] 启动了后端（`pnpm dev`）
- [ ] 启动了前端（`pnpm dev`）
- [ ] 在浏览器中打开了 http://localhost:5173
- [ ] 测试了 Google 登录
- [ ] 测试了 AI 风控功能
- [ ] 测试了其他 6 个功能
- [ ] 查看了 API 文档
- [ ] 查看了数据库 Schema

**如果以上都完成了，恭喜！本地部署成功！🎉**

---

---

# 第二阶段：全球公网上线

**目标：** 把 AETHERIX 部署到全球互联网上，让任何人都能访问 aetherix.com

**预计耗时：** 2 小时

---

## 第 21 步：创建 GitHub 账户（如果还没有）

**作用：** GitHub 是代码托管平台，Vercel 需要从 GitHub 读取代码来部署

**操作步骤：**

1. 打开浏览器，访问 https://github.com
2. 点击右上角 **Sign up**
3. 输入您的邮箱（可以用 AmenJevoson@gmail.com）
4. 设置密码
5. 输入用户名（比如 `aetherix-team`）
6. 点击 **Create account**
7. 按照提示完成邮箱验证

**踩坑点：**
- ✅ 用户名要记住，后面会用到
- ❌ 不要用中文用户名

---

## 第 22 步：在 GitHub 上创建新仓库

**作用：** 为 AETHERIX 项目创建一个代码仓库

**操作步骤：**

1. 登录 GitHub
2. 点击右上角 **+** 号
3. 选择 **New repository**
4. **Repository name** 输入 `aetherix`
5. **Description** 输入 `AETHERIX - Web3 AI Risk Control Platform`
6. 选择 **Public**（公开）
7. **不要** 勾选 "Initialize this repository with a README"（因为我们已经有代码了）
8. 点击 **Create repository**

**看到的页面：**

GitHub 会显示一些命令，告诉您如何上传代码。记住这个页面上的信息。

**踩坑点：**
- ✅ 选择 Public，这样搜索引擎可以索引您的代码
- ❌ 不要勾选初始化选项

---

## 第 23 步：在 Mac 上配置 Git

**作用：** 告诉 Git 您是谁，这样才能上传代码到 GitHub

**操作步骤：**

打开终端（新窗口），输入以下命令（每行按 **Enter**）：

```
git config --global user.name "Your Name"
```

把 `Your Name` 替换成您的名字，比如 `Amen Jevoson`

然后输入：

```
git config --global user.email "AmenJevoson@gmail.com"
```

**验证配置：**

输入：

```
git config --global --list
```

应该看到您刚才设置的名字和邮箱

**踩坑点：**
- ✅ 这个配置是全局的，只需要设置一次

---

## 第 24 步：上传项目代码到 GitHub

**作用：** 把 AETHERIX 的代码上传到 GitHub，这样 Vercel 才能读取代码进行部署

**操作步骤：**

确保您在 `~/Projects/aetherix` 文件夹中，然后依次输入以下命令（每行按 **Enter**）：

```
git init
```

这会初始化一个 Git 仓库

```
git add .
```

这会把所有文件添加到 Git（`.` 表示当前文件夹的所有文件）

```
git commit -m "Initial AETHERIX deployment"
```

这会创建一个提交记录，消息是 "Initial AETHERIX deployment"

现在需要添加远程仓库。输入：

```
git remote add origin https://github.com/YourUsername/aetherix.git
```

把 `YourUsername` 替换成您的 GitHub 用户名

然后输入：

```
git push -u origin main
```

这会把代码上传到 GitHub

**看到的输出：**

终端会显示上传进度，最后显示类似：

```
✓ Everything up-to-date
```

**踩坑点：**
- ⚠️ 第一次上传时，GitHub 可能会要求您输入用户名和密码（或 token）
- ✅ 如果要求输入密码，去 GitHub 生成一个 Personal Access Token（在 Settings → Developer settings → Personal access tokens）
- ❌ 不要把 `.env` 文件上传到 GitHub（.gitignore 已经配置好了，会自动忽略）

---

## 第 25 步：创建 Vercel 账户

**作用：** Vercel 是一个云平台，可以自动部署您的网站到全球 CDN

**操作步骤：**

1. 打开浏览器，访问 https://vercel.com
2. 点击 **Sign Up**
3. 选择 **Continue with GitHub**
4. 授权 Vercel 访问您的 GitHub 账户
5. 完成注册

**踩坑点：**
- ✅ 用 GitHub 账户登录最方便，Vercel 会自动读取您的仓库

---

## 第 26 步：在 Vercel 中导入 AETHERIX 项目

**作用：** 让 Vercel 自动部署您的代码

**操作步骤：**

1. 登录 Vercel Dashboard：https://vercel.com/dashboard
2. 点击 **Add New**
3. 选择 **Project**
4. 点击 **Import Git Repository**
5. 搜索 `aetherix`
6. 点击 `aetherix` 仓库
7. 点击 **Import**

**看到的页面：**

Vercel 会显示项目配置页面

**踩坑点：**
- ✅ Vercel 会自动检测这是一个 Node.js 项目

---

## 第 27 步：在 Vercel 中配置环境变量

**作用：** 告诉 Vercel 您的 Google OAuth 凭证、数据库连接等信息

**操作步骤：**

在 Vercel 的项目配置页面中：

1. 找到 **Environment Variables** 部分
2. 点击 **Add New**
3. 添加以下变量（对于线上环境）：

```
GOOGLE_CLIENT_ID=YOUR_PRODUCTION_CLIENT_ID
GOOGLE_CLIENT_SECRET=YOUR_PRODUCTION_CLIENT_SECRET
GOOGLE_CALLBACK_URL=https://aetherix.com/auth/google/callback

JWT_SECRET=your-super-secret-key-min-32-characters

DATABASE_URL=mysql://user:password@host:3306/aetherix

VITE_APP_ID=your-production-app-id
OAUTH_SERVER_URL=https://oauth.manus.im
VITE_OAUTH_PORTAL_URL=https://oauth.manus.im/portal

BUILT_IN_FORGE_API_URL=https://api.manus.im
BUILT_IN_FORGE_API_KEY=your-production-api-key
```

**⚠️ 重要：这些是线上环境的凭证，需要单独配置**

**踩坑点：**
- ⚠️ **不要用本地测试的 Google OAuth 凭证**，需要创建新的线上凭证（后面会说明）
- ✅ 数据库连接字符串需要指向线上数据库

---

## 第 28 步：创建线上环境的 Google OAuth 凭证

**作用：** 为线上的 aetherix.com 域名创建专门的 Google OAuth 凭证（不同于本地测试用的）

**这一步需要在 Google Cloud 上创建新的凭证。详细步骤如下：**

### 步骤 28.1：创建新的 Google Cloud 项目（线上用）

1. 打开浏览器，访问 https://console.cloud.google.com
2. 用您的 Google 账户登录
3. 点击左上角的项目下拉菜单
4. 点击 **NEW PROJECT**
5. **Project name** 输入 `AETHERIX-Production`
6. 点击 **CREATE**
7. 等待项目创建完成

### 步骤 28.2：启用 Google+ API（线上项目）

1. 在新项目中，搜索 `Google+ API`
2. 点击第一个结果
3. 点击 **ENABLE**

### 步骤 28.3：配置 OAuth 同意屏幕（线上项目）

1. 在左边菜单中，点击 **OAuth consent screen**
2. 选择 **External**
3. 点击 **CREATE**
4. 填写表单：
   - **App name**：`AETHERIX`
   - **User support email**：`AmenJevoson@gmail.com`
   - **Developer contact**：`AmenJevoson@gmail.com`
5. 点击 **SAVE AND CONTINUE**
6. 在 **Scopes** 页面，点击 **SAVE AND CONTINUE**
7. 在 **Test users** 页面，点击 **SAVE AND CONTINUE**（暂时不需要添加测试用户）

### 步骤 28.4：创建线上 OAuth 凭证

1. 在左边菜单中，点击 **Credentials**
2. 点击 **+ CREATE CREDENTIALS**
3. 选择 **OAuth client ID**
4. **Application type** 选择 **Web application**
5. **Name** 输入 `AETHERIX-Production`
6. 在 **Authorized JavaScript origins** 中，点击 **+ ADD URI**
7. 输入 `https://aetherix.com`
8. 再点击 **+ ADD URI**
9. 输入 `https://www.aetherix.com`
10. 在 **Authorized redirect URIs** 中，点击 **+ ADD URI**
11. 输入 `https://aetherix.com/auth/google/callback`
12. 再点击 **+ ADD URI**
13. 输入 `https://www.aetherix.com/auth/google/callback`
14. 点击 **CREATE**
15. 弹出窗口显示新的 **Client ID** 和 **Client Secret**
16. **复制 Client ID**，粘贴到记事本
17. **复制 Client Secret**，也粘贴到记事本

**⚠️ 重要：这是线上用的凭证，不同于本地测试用的**

### 步骤 28.5：在 Vercel 中更新环境变量

回到 Vercel 的项目配置页面：

1. 找到 `GOOGLE_CLIENT_ID` 变量
2. 点击编辑，替换成新的线上 Client ID
3. 找到 `GOOGLE_CLIENT_SECRET` 变量
4. 点击编辑，替换成新的线上 Client Secret
5. 确保 `GOOGLE_CALLBACK_URL` 是 `https://aetherix.com/auth/google/callback`

**踩坑点：**
- ⚠️ **本地用的 Client ID 和线上用的 Client ID 是不同的**
- ✅ 线上的回调 URL 必须是 `https://aetherix.com/auth/google/callback`（注意是 https，不是 http）

---

## 第 29 步：在 Vercel 中部署

**作用：** 让 Vercel 自动编译和部署您的代码

**操作步骤：**

在 Vercel 的项目配置页面中：

1. 所有环境变量都配置好后，点击 **Deploy**
2. Vercel 会开始部署（通常 3-5 分钟）
3. 看到绿色的 ✓ 符号说明部署成功

**看到的结果：**

部署完成后，Vercel 会给您一个临时 URL，比如：

```
https://aetherix.vercel.app
```

点击这个 URL，应该能看到 AETHERIX 首页

**踩坑点：**
- ✅ 这是一个临时 URL，后面会绑定您的自定义域名 aetherix.com
- ❌ 如果部署失败，检查环境变量是否正确

---

## 第 30 步：购买 aetherix.com 域名

**作用：** 拥有一个属于自己的 .com 域名，这样用户可以用 aetherix.com 访问您的网站

**操作步骤：**

1. 打开浏览器，访问 https://www.namecheap.com
2. 在搜索框中输入 `aetherix.com`
3. 点击 **Search**
4. 看到 `aetherix.com` 的价格，点击 **Add to Cart**
5. 选择购买期限（推荐 1 年，$8.88）
6. 点击 **View Cart**
7. 勾选 **WHOIS Privacy**（保护您的个人信息）
8. 点击 **Proceed to Checkout**
9. 如果还没有 Namecheap 账户，点击 **Create Account**
10. 输入邮箱、密码等信息
11. 在支付页面，选择 **Alipay**（支付宝）
12. 点击 **Pay Now**
13. 扫描二维码，用支付宝支付
14. 等待支付完成

**看到的结果：**

支付完成后，Namecheap 会显示 "Order Successful"，您的邮箱会收到确认邮件

**踩坑点：**
- ✅ 域名通常需要 5-15 分钟才能激活
- ❌ 不要关闭浏览器，等待支付完成

---

## 第 31 步：在 Cloudflare 中添加网站

**作用：** Cloudflare 是一个免费的 DNS 和 CDN 服务，可以加快网站速度、提供 DDoS 防护等

**操作步骤：**

1. 打开浏览器，访问 https://dash.cloudflare.com
2. 点击 **Sign Up**（如果还没有账户）
3. 输入邮箱和密码
4. 完成注册
5. 登录后，点击 **+ Add a Site**
6. 输入 `aetherix.com`
7. 点击 **Add Site**
8. 选择 **Free Plan**（免费计划）
9. 点击 **Continue**

**看到的页面：**

Cloudflare 会显示两个 Nameservers，比如：

```
ns1.cloudflare.com
ns2.cloudflare.com
```

**记住这两个 Nameservers，下一步需要用到**

**踩坑点：**
- ✅ 选择 Free Plan 就足够了，功能很强大
- ❌ 不要关闭这个页面，待会需要用到 Nameservers

---

## 第 32 步：在 Namecheap 中更新 Nameservers

**作用：** 告诉 Namecheap 使用 Cloudflare 的 DNS 服务

**操作步骤：**

1. 打开浏览器，访问 https://www.namecheap.com
2. 登录您的 Namecheap 账户
3. 点击 **Account → Dashboard**
4. 找到 `aetherix.com`，点击 **Manage**
5. 在左边菜单中，点击 **Nameservers**
6. 看到 **Nameserver 1、Nameserver 2** 等字段
7. 把当前的 Nameservers 改成 Cloudflare 的：
   - **Nameserver 1**：`ns1.cloudflare.com`
   - **Nameserver 2**：`ns2.cloudflare.com`
8. 点击 **Save**

**看到的结果：**

Namecheap 会显示 "Nameservers have been successfully updated"

**踩坑点：**
- ⚠️ DNS 更新需要时间（通常 1-24 小时），不要急
- ✅ 更新完成后，回到 Cloudflare 继续配置

---

## 第 33 步：在 Cloudflare 中配置 DNS 记录

**作用：** 告诉 Cloudflare 把 aetherix.com 的流量指向 Vercel

**操作步骤：**

1. 回到 Cloudflare Dashboard
2. 点击 `aetherix.com`
3. 在左边菜单中，点击 **DNS**
4. 点击 **+ Add record**
5. 配置第一条记录：
   - **Type**：选择 `A`
   - **Name**：输入 `@`（表示根域名）
   - **IPv4 address**：输入 `76.76.19.132`（这是 Vercel 的 IP）
   - **TTL**：选择 `Auto`
   - **Proxy status**：选择 **Proxied**（橙色云）
   - 点击 **Save**

6. 再点击 **+ Add record**，配置第二条记录：
   - **Type**：选择 `CNAME`
   - **Name**：输入 `www`
   - **Target**：输入 `cname.vercel-dns.com`
   - **TTL**：选择 `Auto`
   - **Proxy status**：选择 **Proxied**（橙色云）
   - 点击 **Save**

**看到的结果：**

Cloudflare 会显示两条 DNS 记录

**踩坑点：**
- ✅ 确保两条记录都是 **Proxied**（橙色云），这样可以享受 Cloudflare 的 CDN 加速
- ❌ 如果是灰色云，说明没有启用代理

---

## 第 34 步：在 Vercel 中绑定自定义域名

**作用：** 告诉 Vercel 使用 aetherix.com 作为您的网站域名

**操作步骤：**

1. 打开 Vercel Dashboard：https://vercel.com/dashboard
2. 点击 AETHERIX 项目
3. 在右上角，点击 **Settings**
4. 在左边菜单中，点击 **Domains**
5. 点击 **Add Domain**
6. 输入 `aetherix.com`
7. 点击 **Add**

**看到的页面：**

Vercel 会显示 DNS 配置信息。如果您已经在 Cloudflare 中配置了 DNS，Vercel 会自动验证。

**看到的结果：**

状态应该显示 **Valid Configuration**（绿色）

**踩坑点：**
- ⚠️ DNS 验证可能需要几分钟到几小时
- ✅ 如果一直显示 "Pending"，等待 30 分钟后刷新页面

---

## 第 35 步：验证 SSL 证书

**作用：** 确保您的网站使用 HTTPS 加密连接

**操作步骤：**

1. 在 Vercel 的 Domains 页面中，找到 `aetherix.com`
2. 看到 **SSL** 状态
3. 应该显示 **Valid** 和一个绿色的 ✓

**如果显示 "Pending"：**

1. 等待 5-10 分钟
2. 刷新页面
3. 通常会自动变成 **Valid**

**踩坑点：**
- ✅ Vercel 会自动申请 Let's Encrypt 免费 SSL 证书，无需手动操作
- ❌ 如果一直显示 "Pending"，检查 DNS 是否正确配置

---

## 第 36 步：在浏览器中访问 aetherix.com

**作用：** 验证您的网站是否能正常访问

**操作步骤：**

1. 打开浏览器
2. 在地址栏中输入：

```
https://aetherix.com
```

按 **Enter**

**看到的结果：**

您应该看到 AETHERIX 首页，包括：
- ✅ 顶部导航栏
- ✅ 7 个风控功能卡片
- ✅ 深空赛博金融设计风格
- ✅ 地址栏显示绿色的锁形图标（表示 HTTPS 安全连接）

**踩坑点：**
- ⚠️ 第一次访问可能比较慢，因为 DNS 还在全球传播
- ✅ 如果看到 404 错误，等待 10 分钟后重试

---

## 第 37 步：测试线上 Google 登录

**作用：** 验证 Google OAuth 在线上环境是否正常工作

**操作步骤：**

1. 在 https://aetherix.com 首页上，点击右上角的 **登录** 按钮
2. 看到登录页面，点击 **使用 Google 登录** 按钮
3. 浏览器会跳转到 Google 登录页面
4. 用您的 Google 账户登录
5. Google 会要求您授权，点击 **允许**
6. 浏览器会跳转回 AETHERIX，显示您已登录

**看到的标志：**
- ✅ 页面右上角显示您的 Google 账户名
- ✅ 可以看到 **登出** 按钮

**踩坑点：**
- ❌ 如果显示 `redirect_uri_mismatch` 错误，检查 Google Cloud 中配置的回调 URL 是否是 `https://aetherix.com/auth/google/callback`
- ✅ 确保用的是线上环境的 Google OAuth 凭证，不是本地测试用的

---

## 第 38 步：测试线上 AI 风控功能

**作用：** 验证后端 AI 自动调度系统在线上是否正常工作

**操作步骤：**

1. 登录后，在首页上找到 **行情预判推演** 卡片
2. 点击 **立即体验** 按钮
3. 输入一个加密货币符号，比如 `BTC`
4. 点击 **分析** 按钮
5. 等待 AI 分析（通常 5-10 秒）

**看到的结果：**
- ✅ AI 会返回关于 BTC 的市场分析
- ✅ 包含价格预测、风险评估等内容

**踩坑点：**
- ⚠️ 第一次调用 AI 可能会比较慢
- ✅ 如果能看到 AI 的分析结果，说明整个系统都正常了！

---

## 第 39 步：启用 Cloudflare 的免费功能

**作用：** 充分利用 Cloudflare 的免费功能，加快网站速度、提供安全防护

**操作步骤：**

1. 打开 Cloudflare Dashboard：https://dash.cloudflare.com
2. 点击 `aetherix.com`
3. 在左边菜单中，点击 **Caching**
4. 找到 **Cache Everything**，点击启用
5. 在左边菜单中，点击 **Speed**
6. 找到 **Auto Minify**，勾选 CSS、JavaScript、HTML
7. 找到 **Brotli Compression**，点击启用
8. 在左边菜单中，点击 **Security**
9. 找到 **WAF（Web Application Firewall）**，点击启用

**看到的结果：**

这些功能会自动启用，您的网站会变得更快、更安全

**踩坑点：**
- ✅ 这些都是免费功能，放心启用
- ✅ 启用后需要 5-10 分钟才能生效

---

## 第 40 步：配置 SEO 优化

**作用：** 让搜索引擎（Google、Bing 等）能够找到您的网站

**操作步骤：**

1. 在 VS Code 中，打开 `SEO_OPTIMIZATION.md` 文件
2. 按照文档中的步骤配置：
   - **Google Search Console** - 提交网站地图
   - **Google Analytics** - 追踪网站流量
   - **Robots.txt** - 告诉搜索引擎如何爬取您的网站
   - **Sitemap** - 提供网站的所有页面列表

**具体步骤：**

### 步骤 40.1：提交到 Google Search Console

1. 访问 https://search.google.com/search-console
2. 点击 **URL prefix**
3. 输入 `https://aetherix.com`
4. 点击 **Continue**
5. 按照提示验证网站所有权（通常通过 DNS 记录）
6. 验证完成后，点击 **Request indexing**

### 步骤 40.2：提交网站地图

1. 在 Google Search Console 中，点击 **Sitemaps**
2. 输入 `https://aetherix.com/sitemap.xml`
3. 点击 **Submit**

### 步骤 40.3：设置 Google Analytics

1. 访问 https://analytics.google.com
2. 点击 **Create Account**
3. 填写网站信息
4. 获取 **Tracking ID**
5. 在 AETHERIX 的 HTML 中添加 Google Analytics 代码

**踩坑点：**
- ✅ SEO 优化是长期工作，不会立即见效
- ✅ 通常需要 2-4 周，Google 才会开始索引您的网站

---

## 第 41 步：验证全球可访问性

**作用：** 确保世界各地的用户都能快速访问您的网站

**操作步骤：**

1. 打开浏览器，访问 https://www.speedtest.net/performance/aetherix.com
2. 这个工具会测试您的网站在全球各地的访问速度
3. 应该看到绿色的 ✓，表示网站正常

**其他验证工具：**

- **SSL Labs**：https://www.ssllabs.com/ssltest/analyze.html?d=aetherix.com
  - 验证 SSL 证书是否正确
  - 应该显示 A+ 或 A 等级

- **DNS Checker**：https://dnschecker.org/
  - 验证 DNS 记录是否正确配置
  - 应该显示 Cloudflare 的 Nameservers

- **What's My DNS**：https://www.whatsmydns.net/?d=aetherix.com
  - 检查 DNS 在全球各地的传播情况

**踩坑点：**
- ✅ 如果 SSL Labs 显示 A 或 A+ 等级，说明安全配置很好
- ✅ 如果 DNS Checker 显示所有地区都是绿色，说明 DNS 已经全球传播

---

## 第 42 步：配置自动备份和监控

**作用：** 确保您的网站数据安全，并及时发现问题

**操作步骤：**

1. 在 Vercel Dashboard 中，点击 AETHERIX 项目
2. 点击 **Settings**
3. 点击 **Monitoring**
4. 启用 **Error Tracking**（错误追踪）
5. 启用 **Performance Monitoring**（性能监控）

**这样做的好处：**
- ✅ 如果网站出错，Vercel 会自动通知您
- ✅ 可以看到网站的性能指标

**踩坑点：**
- ✅ 这些功能都是免费的
- ✅ 启用后可以更好地了解网站的运行情况

---

## ✅ 第二阶段完成检查

现在您已经完成了全球上线！检查以下项目是否都完成了：

- [ ] 创建了 GitHub 账户
- [ ] 创建了 GitHub 仓库
- [ ] 配置了 Git（用户名和邮箱）
- [ ] 上传了代码到 GitHub
- [ ] 创建了 Vercel 账户
- [ ] 在 Vercel 中导入了项目
- [ ] 配置了线上环境的环境变量
- [ ] 创建了线上用的 Google OAuth 凭证
- [ ] 在 Vercel 中部署了项目
- [ ] 购买了 aetherix.com 域名
- [ ] 创建了 Cloudflare 账户
- [ ] 在 Cloudflare 中添加了网站
- [ ] 在 Namecheap 中更新了 Nameservers
- [ ] 在 Cloudflare 中配置了 DNS 记录
- [ ] 在 Vercel 中绑定了自定义域名
- [ ] 验证了 SSL 证书
- [ ] 在浏览器中访问了 https://aetherix.com
- [ ] 测试了线上 Google 登录
- [ ] 测试了线上 AI 风控功能
- [ ] 启用了 Cloudflare 的免费功能
- [ ] 配置了 SEO 优化
- [ ] 验证了全球可访问性
- [ ] 配置了自动备份和监控

**如果以上都完成了，恭喜！AETHERIX 已经全球上线！🎉**

---

---

# 上线前自检清单

**⚠️ 重要：在正式宣传您的网站之前，请逐一检查以下项目，确保一切正常运行。**

---

## 🔍 功能检查

### 用户认证
- [ ] Google 登录可以正常工作
- [ ] 登录后能看到用户信息
- [ ] 登出功能正常
- [ ] 重新登录不会出错

### 7 大风控功能
- [ ] 行情预判推演 - 能返回 AI 分析结果
- [ ] 暗盘隐性风险预警 - 能识别风险
- [ ] 持仓 AI 风控保镖 - 能给出持仓建议
- [ ] 交易风格定制推送 - 能保存用户偏好
- [ ] 舆情真假过滤 - 能判断新闻真假
- [ ] 极端行情急救系统 - 能在市场暴跌时给出建议
- [ ] 悬浮 AI 对话舱 - 能进行实时对话

### 数据库
- [ ] 用户数据正确保存
- [ ] 订阅记录正确保存
- [ ] 风险预警记录正确保存
- [ ] 没有数据丢失或损坏

### API 接口
- [ ] 所有 API 端点都能正常响应
- [ ] 错误处理正确（返回合适的错误信息）
- [ ] 速率限制正常工作
- [ ] 没有 CORS 错误

---

## 🌐 网站访问检查

### 域名和 SSL
- [ ] https://aetherix.com 能正常访问
- [ ] https://www.aetherix.com 能正常访问
- [ ] 地址栏显示绿色锁形图标（HTTPS 安全）
- [ ] SSL 证书有效期充足

### 性能
- [ ] 首页加载时间 < 3 秒
- [ ] 点击按钮响应迅速
- [ ] AI 分析结果返回时间 < 10 秒
- [ ] 没有明显的卡顿或延迟

### 跨浏览器兼容性
- [ ] Chrome 浏览器正常
- [ ] Safari 浏览器正常
- [ ] Firefox 浏览器正常
- [ ] Edge 浏览器正常

### 响应式设计
- [ ] 桌面版显示正常
- [ ] 平板版显示正常
- [ ] 手机版显示正常
- [ ] 所有功能在各设备上都能使用

---

## 🔐 安全检查

### 数据加密
- [ ] 用户邮箱被加密存储
- [ ] 用户持仓数据被脱敏
- [ ] API 传输使用 HTTPS
- [ ] 没有敏感信息在日志中

### 用户隐私
- [ ] 没有收集不必要的用户信息
- [ ] 用户数据不会被第三方访问
- [ ] 有隐私政策页面
- [ ] 用户可以删除自己的数据

### Google OAuth
- [ ] Client ID 和 Secret 没有在代码中硬编码
- [ ] 只在环境变量中存储
- [ ] 线上用的凭证与本地用的不同
- [ ] 回调 URL 正确配置

---

## 📊 SEO 和分析检查

### 搜索引擎优化
- [ ] 网站已提交到 Google Search Console
- [ ] Sitemap 已提交
- [ ] Robots.txt 配置正确
- [ ] Meta 标签（title、description）正确
- [ ] 结构化数据（Schema.org）配置正确

### 分析工具
- [ ] Google Analytics 已安装
- [ ] 能正确追踪用户访问
- [ ] 能看到页面浏览量、用户数等指标
- [ ] 没有 JavaScript 错误

### 社交媒体
- [ ] Open Graph 标签配置正确（分享时显示缩略图）
- [ ] Twitter Card 标签配置正确
- [ ] 网站可以正常分享到社交媒体

---

## 📱 移动端检查

### 手机访问
- [ ] 在 iPhone 上能正常访问
- [ ] 在 Android 手机上能正常访问
- [ ] 按钮大小合适，容易点击
- [ ] 文字大小合适，容易阅读

### 触摸交互
- [ ] 所有按钮都能用手指点击
- [ ] 没有需要鼠标 hover 的功能
- [ ] 表单输入正常
- [ ] 弹窗能正常关闭

---

## 🚨 错误检查

### 浏览器控制台
- [ ] 打开浏览器开发者工具（F12）
- [ ] 查看 Console 标签
- [ ] 没有红色的 JavaScript 错误
- [ ] 没有黄色的警告信息

### 网络请求
- [ ] 打开 Network 标签
- [ ] 刷新页面
- [ ] 所有请求都返回 200 或 304 状态码
- [ ] 没有 404 或 500 错误

### 性能
- [ ] 打开 Performance 标签
- [ ] 记录页面加载
- [ ] 首次内容绘制（FCP）< 1.5 秒
- [ ] 最大内容绘制（LCP）< 2.5 秒

---

## 📧 邮件和通知检查

### 邮件配置
- [ ] 用户注册邮件能正常发送
- [ ] 邮件内容正确
- [ ] 邮件链接能正常打开
- [ ] 没有邮件被标记为垃圾

### 通知
- [ ] 风险预警通知能正常发送
- [ ] 通知内容清晰准确
- [ ] 用户可以关闭通知
- [ ] 没有过度发送通知

---

## 💾 备份和恢复检查

### 数据备份
- [ ] 数据库已配置自动备份
- [ ] 备份文件存储在安全位置
- [ ] 备份频率合适（至少每天一次）
- [ ] 可以恢复备份数据

### 灾难恢复
- [ ] 有应急预案
- [ ] 知道如何快速恢复网站
- [ ] 有联系方式在出问题时通知用户

---

## 📝 文档和支持检查

### 用户文档
- [ ] 有使用指南
- [ ] 有常见问题解答（FAQ）
- [ ] 有视频教程
- [ ] 文档清晰易懂

### 技术文档
- [ ] 有 API 文档
- [ ] 有数据库 Schema 文档
- [ ] 有部署指南
- [ ] 有故障排查指南

### 联系方式
- [ ] 有邮箱地址
- [ ] 有联系表单
- [ ] 有社交媒体账号
- [ ] 有响应时间承诺

---

## 🎯 最终检查

在正式宣传之前，请完成以下最后的检查：

- [ ] 所有功能都已测试
- [ ] 没有已知的 bug
- [ ] 网站性能满足要求
- [ ] 安全措施已实施
- [ ] SEO 已优化
- [ ] 移动端正常工作
- [ ] 没有错误或警告
- [ ] 备份和恢复已配置
- [ ] 文档完整
- [ ] 支持渠道已建立

**如果以上所有项目都打上了 ✓，您的网站已准备好上线了！🚀**

---

## 🎉 恭喜！

您已经成功完成了 AETHERIX Web3 AI 风控平台的完整部署！

从本地开发到全球上线，您已经：

1. ✅ 在 MacBook Pro M5 上完整运行了项目
2. ✅ 测试了所有 7 大风控功能
3. ✅ 配置了 Google OAuth 登录
4. ✅ 部署到了全球 Vercel CDN
5. ✅ 绑定了自定义 .com 域名
6. ✅ 配置了 Cloudflare 加速和防护
7. ✅ 优化了 SEO
8. ✅ 验证了全球可访问性

现在，全球任何地区的用户都可以通过 https://aetherix.com 访问您的平台，使用 Google 登录，体验 AI 风控功能。

**下一步建议：**

1. 在 Twitter、Telegram、Discord 上宣传您的网站
2. 邀请早期用户测试和反馈
3. 根据用户反馈持续优化
4. 监控网站性能和用户行为
5. 定期更新功能和内容

**祝您的 AETHERIX 平台大获成功！🎊**

---

**文档版本：** 1.0  
**最后更新：** 2026 年 6 月 30 日  
**作者：** Manus AI  
**联系方式：** AmenJevoson@gmail.com
