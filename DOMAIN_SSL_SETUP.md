# AETHERIX 域名采购、DNS 解析和 SSL 证书配置完整教程

**项目名称：** AETHERIX - Web3 原生 AI 风控生态终端  
**目标域名：** aetherix.com  
**所有者邮箱：** AmenJevoson@gmail.com

---

## 📋 目录

1. [域名采购](#域名采购)
2. [DNS 解析配置](#dns-解析配置)
3. [SSL 证书配置](#ssl-证书配置)
4. [验证和测试](#验证和测试)
5. [故障排查](#故障排查)
6. [维护和续期](#维护和续期)

---

## 域名采购

### 方案 1：通过 Namecheap 采购（推荐）

#### 步骤 1：访问 Namecheap

1. 打开浏览器，访问 https://www.namecheap.com
2. 在搜索框中输入 `aetherix.com`
3. 点击 **Search**

#### 步骤 2：检查域名可用性

![Namecheap 搜索结果](https://via.placeholder.com/800x400?text=Namecheap+Search+Results)

- 如果显示 **Available**，点击 **Add to Cart**
- 如果显示 **Unavailable**，尝试其他 TLD（.io、.ai、.xyz 等）

#### 步骤 3：选择注册期限

```
推荐配置：
- 注册期限：3 年（更便宜）
- 自动续期：启用
- WHOIS 隐私保护：启用（保护个人信息）
```

**价格参考（2026 年）：**
- .com：$8.88/年（首年）
- .io：$35.88/年
- .ai：$79.99/年

#### 步骤 4：添加到购物车

1. 选择注册期限（建议 3 年）
2. 勾选 **WHOIS Privacy Protection**（推荐）
3. 点击 **Add to Cart**

#### 步骤 5：结账

1. 点击 **View Cart**
2. 检查订单总额
3. 点击 **Proceed to Checkout**
4. 使用 Google 账户或邮箱登录/注册
5. 填入账单地址（可使用虚拟地址）
6. 选择支付方式（信用卡、PayPal、支付宝等）
7. 完成支付

#### 步骤 6：验证邮箱

1. 检查您的邮箱（AmenJevoson@gmail.com）
2. 查找来自 Namecheap 的验证邮件
3. 点击验证链接
4. 等待域名激活（通常 5-15 分钟）

---

### 方案 2：通过 Google Domains 采购

#### 步骤 1：访问 Google Domains

1. 打开浏览器，访问 https://domains.google.com
2. 使用 Google 账户登录
3. 在搜索框中输入 `aetherix.com`
4. 点击 **Search**

#### 步骤 2：选择域名

- 如果可用，点击 **Register**
- 选择注册期限（1-10 年）
- 点击 **Continue**

#### 步骤 3：结账

1. 填入联系信息
2. 选择隐私保护选项
3. 选择支付方式
4. 完成支付

#### 步骤 4：验证

- Google 会自动配置 DNS
- 域名通常在 24 小时内激活

---

### 方案 3：通过 GoDaddy 采购

#### 步骤 1：访问 GoDaddy

1. 打开浏览器，访问 https://www.godaddy.com
2. 在搜索框中输入 `aetherix.com`
3. 点击 **Search**

#### 步骤 2：添加到购物车

- 点击 **Add to Cart**
- 选择注册期限
- 点击 **Continue to Cart**

#### 步骤 3：结账

1. 登录或创建账户
2. 填入账单信息
3. 选择支付方式
4. 完成支付

#### 步骤 4：验证

- 检查邮箱验证邮件
- 点击验证链接
- 等待域名激活

---

## DNS 解析配置

### 前置准备

在配置 DNS 之前，确定您的部署平台：

| 平台 | DNS 配置 | 优势 |
|------|---------|------|
| **Vercel** | CNAME 指向 vercel.app | 最简单，自动 SSL |
| **AWS** | A 记录指向 ALB | 最稳定，需手动配置 |
| **Railway** | CNAME 指向 railway.app | 中等复杂度 |
| **Cloudflare** | NS 记录指向 Cloudflare | 最灵活，需额外配置 |

**推荐：Vercel（最简单）**

---

### 方案 1：Vercel 部署 DNS 配置（推荐）

#### 步骤 1：在 Vercel 中添加域名

1. 登录 Vercel Dashboard：https://vercel.com/dashboard
2. 选择您的 AETHERIX 项目
3. 进入 **Settings → Domains**
4. 点击 **Add Domain**
5. 输入 `aetherix.com`
6. 点击 **Add**

#### 步骤 2：获取 DNS 配置信息

Vercel 会显示以下信息：

```
Type: CNAME
Name: aetherix.com
Value: cname.vercel-dns.com
```

或者：

```
Type: A
Name: aetherix.com
Value: 76.76.19.132

Type: CNAME
Name: www.aetherix.com
Value: cname.vercel-dns.com
```

#### 步骤 3：在 Namecheap 中配置 DNS

1. 登录 Namecheap：https://www.namecheap.com/myaccount/login
2. 进入 **Domain List**
3. 找到 `aetherix.com`，点击 **Manage**
4. 进入 **Advanced DNS** 标签

#### 步骤 4：添加 DNS 记录

**删除现有记录（如有）：**
- 删除所有 A 记录
- 删除所有 CNAME 记录

**添加新记录：**

| 类型 | 主机 | 值 | TTL |
|------|------|-----|-----|
| A | @ | 76.76.19.132 | 3600 |
| CNAME | www | cname.vercel-dns.com | 3600 |

**步骤详解：**

1. 点击 **Add Record**
2. 选择 **Type: A**
3. 输入 **Host: @**（表示根域名）
4. 输入 **Value: 76.76.19.132**
5. 设置 **TTL: 3600**
6. 点击 **Save**

7. 再次点击 **Add Record**
8. 选择 **Type: CNAME**
9. 输入 **Host: www**
10. 输入 **Value: cname.vercel-dns.com**
11. 设置 **TTL: 3600**
12. 点击 **Save**

#### 步骤 5：等待 DNS 传播

```
DNS 传播时间：
- 立即：部分 ISP
- 1-2 小时：大多数 ISP
- 24-48 小时：完全传播
```

#### 步骤 6：在 Vercel 中验证

1. 返回 Vercel Dashboard
2. 进入 **Settings → Domains**
3. 查看 `aetherix.com` 的状态
4. 等待状态变为 **Valid Configuration**（绿色）

---

### 方案 2：AWS 部署 DNS 配置

#### 步骤 1：获取 ALB DNS 名称

1. 登录 AWS Console：https://console.aws.amazon.com
2. 进入 **EC2 → Load Balancers**
3. 找到您的 Application Load Balancer
4. 复制 **DNS name**（例如：aetherix-alb-123456.us-east-1.elb.amazonaws.com）

#### 步骤 2：在 Namecheap 中配置 DNS

1. 登录 Namecheap
2. 进入 **Domain List → Manage**
3. 进入 **Advanced DNS** 标签

#### 步骤 3：添加 DNS 记录

| 类型 | 主机 | 值 | TTL |
|------|------|-----|-----|
| CNAME | @ | aetherix-alb-123456.us-east-1.elb.amazonaws.com | 3600 |
| CNAME | www | aetherix-alb-123456.us-east-1.elb.amazonaws.com | 3600 |

**注意：** AWS ALB 不支持 A 记录指向，必须使用 CNAME

#### 步骤 4：验证

```bash
# 使用 nslookup 验证 DNS 配置
nslookup aetherix.com

# 输出应该显示 ALB DNS 名称
```

---

### 方案 3：Railway 部署 DNS 配置

#### 步骤 1：获取 Railway 域名

1. 登录 Railway Dashboard：https://railway.app/dashboard
2. 选择您的 AETHERIX 项目
3. 进入 **Settings → Domains**
4. 复制自动生成的域名（例如：aetherix-xxx.railway.app）

#### 步骤 2：在 Namecheap 中配置 DNS

1. 登录 Namecheap
2. 进入 **Domain List → Manage**
3. 进入 **Advanced DNS** 标签

#### 步骤 3：添加 DNS 记录

| 类型 | 主机 | 值 | TTL |
|------|------|-----|-----|
| CNAME | @ | aetherix-xxx.railway.app | 3600 |
| CNAME | www | aetherix-xxx.railway.app | 3600 |

---

### 方案 4：Cloudflare DNS 配置（高级）

#### 步骤 1：在 Cloudflare 中添加网站

1. 访问 https://dash.cloudflare.com
2. 点击 **Add a Site**
3. 输入 `aetherix.com`
4. 点击 **Add Site**
5. 选择免费计划
6. 点击 **Continue**

#### 步骤 2：更新 Namecheap 的 Nameservers

Cloudflare 会提供 2 个 Nameservers，例如：
```
ns1.cloudflare.com
ns2.cloudflare.com
```

1. 登录 Namecheap
2. 进入 **Domain List → Manage**
3. 进入 **Nameservers** 标签
4. 选择 **Custom DNS**
5. 输入 Cloudflare 的 Nameservers
6. 点击 **Save**

#### 步骤 3：在 Cloudflare 中配置 DNS 记录

1. 返回 Cloudflare Dashboard
2. 进入 **DNS** 标签
3. 添加 A 记录：
   - **Name:** aetherix.com
   - **Type:** A
   - **Content:** 您的服务器 IP
   - **TTL:** Auto
   - **Proxy status:** Proxied（橙色云）

4. 添加 CNAME 记录：
   - **Name:** www
   - **Type:** CNAME
   - **Content:** aetherix.com
   - **TTL:** Auto
   - **Proxy status:** Proxied

#### 步骤 4：启用 Cloudflare 功能

在 Cloudflare 中启用以下功能以提升性能和安全性：

- **Caching:** 启用缓存
- **Speed:** 启用自动优化
- **Security:** 启用 WAF（Web Application Firewall）
- **SSL/TLS:** 设置为 Full（见下一节）

---

## SSL 证书配置

### 方案 1：Vercel 自动 SSL（推荐）

Vercel 会**自动为您的域名申请和配置 SSL 证书**，无需任何操作。

#### 验证 SSL 证书

1. 在浏览器中访问 https://aetherix.com
2. 点击地址栏的锁形图标
3. 查看证书信息
4. 确认证书由 **Let's Encrypt** 或 **Vercel** 签发

#### SSL 证书自动续期

- Vercel 会在证书过期前自动续期
- 无需手动操作
- 续期通常在过期前 30 天进行

---

### 方案 2：Let's Encrypt 免费 SSL（自托管）

如果您使用自己的服务器，可以使用 Let's Encrypt 获取免费 SSL 证书。

#### 步骤 1：安装 Certbot

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx

# CentOS/RHEL
sudo yum install certbot python3-certbot-nginx

# macOS
brew install certbot
```

#### 步骤 2：获取 SSL 证书

```bash
# 使用 Nginx 自动配置
sudo certbot certonly --nginx -d aetherix.com -d www.aetherix.com

# 或使用 Standalone 模式（需要停止 Nginx）
sudo certbot certonly --standalone -d aetherix.com -d www.aetherix.com
```

#### 步骤 3：按照提示操作

```
Enter email address: AmenJevoson@gmail.com
Agree to terms: Y
Share email: N（可选）
```

#### 步骤 4：配置 Nginx

编辑 `/etc/nginx/sites-available/aetherix`：

```nginx
server {
    listen 443 ssl http2;
    server_name aetherix.com www.aetherix.com;

    # SSL 证书路径
    ssl_certificate /etc/letsencrypt/live/aetherix.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/aetherix.com/privkey.pem;

    # SSL 配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    # 其他配置...
    location / {
        proxy_pass http://localhost:3000;
    }
}

# HTTP 重定向到 HTTPS
server {
    listen 80;
    server_name aetherix.com www.aetherix.com;
    return 301 https://$server_name$request_uri;
}
```

#### 步骤 5：重启 Nginx

```bash
sudo systemctl restart nginx
```

#### 步骤 6：设置自动续期

```bash
# 测试续期
sudo certbot renew --dry-run

# 启用自动续期
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# 验证定时任务
sudo systemctl status certbot.timer
```

---

### 方案 3：AWS Certificate Manager（AWS 部署）

如果您使用 AWS ALB，可以使用 AWS Certificate Manager。

#### 步骤 1：在 AWS ACM 中请求证书

1. 登录 AWS Console
2. 进入 **Certificate Manager**
3. 点击 **Request a certificate**
4. 输入域名：
   - `aetherix.com`
   - `www.aetherix.com`
5. 选择 **DNS validation**
6. 点击 **Request**

#### 步骤 2：验证域名所有权

1. 在 ACM 中查看待验证的记录
2. 复制 DNS 记录信息
3. 在 Namecheap 中添加 CNAME 记录
4. 等待验证完成（通常 5-15 分钟）

#### 步骤 3：在 ALB 中配置证书

1. 进入 **EC2 → Load Balancers**
2. 选择您的 ALB
3. 进入 **Listeners**
4. 编辑 HTTPS 监听器
5. 选择 ACM 证书
6. 保存

#### 步骤 4：配置 HTTP 重定向

1. 编辑 HTTP 监听器（80 端口）
2. 添加重定向规则
3. 重定向到 HTTPS（443 端口）

---

## 验证和测试

### 步骤 1：DNS 验证

```bash
# 查询 DNS 记录
nslookup aetherix.com

# 输出应该显示您的服务器 IP 或 CNAME

# 详细 DNS 查询
dig aetherix.com

# 查询特定记录类型
dig aetherix.com A
dig aetherix.com CNAME
```

### 步骤 2：SSL 证书验证

```bash
# 检查 SSL 证书
openssl s_client -connect aetherix.com:443

# 查看证书详情
openssl x509 -in /etc/letsencrypt/live/aetherix.com/fullchain.pem -text -noout

# 检查证书过期时间
openssl x509 -in /etc/letsencrypt/live/aetherix.com/fullchain.pem -noout -dates
```

### 步骤 3：浏览器测试

1. 打开浏览器
2. 访问 https://aetherix.com
3. 检查以下内容：
   - 地址栏显示绿色锁形图标
   - 没有 SSL 警告
   - 页面正常加载
   - 所有资源都通过 HTTPS 加载

### 步骤 4：在线检查工具

使用以下工具验证 DNS 和 SSL 配置：

- **SSL Labs SSL Report:** https://www.ssllabs.com/ssltest/analyze.html?d=aetherix.com
- **DNS Checker:** https://dnschecker.org/
- **Whois Lookup:** https://www.whois.com/whois/aetherix.com
- **HTTP Headers:** https://httpheader.tools/

---

## 故障排查

### 问题 1：DNS 不生效

**症状：** 访问域名显示 "无法连接"

**解决方案：**

```bash
# 1. 检查 DNS 记录是否正确
nslookup aetherix.com

# 2. 检查 DNS 传播状态
# 访问 https://www.whatsmydns.net/?d=aetherix.com

# 3. 清除本地 DNS 缓存
# Windows
ipconfig /flushdns

# macOS
sudo dscacheutil -flushcache

# Linux
sudo systemctl restart systemd-resolved

# 4. 等待 DNS 传播（最长 48 小时）
```

### 问题 2：SSL 证书错误

**症状：** 浏览器显示 "您的连接不安全" 或 "证书错误"

**解决方案：**

```bash
# 1. 检查证书是否正确安装
openssl s_client -connect aetherix.com:443

# 2. 检查证书有效期
openssl x509 -in /path/to/cert.pem -noout -dates

# 3. 检查证书链
openssl s_client -connect aetherix.com:443 -showcerts

# 4. 如果使用 Let's Encrypt，重新申请证书
sudo certbot renew --force-renewal

# 5. 重启 Web 服务器
sudo systemctl restart nginx
# 或
sudo systemctl restart apache2
```

### 问题 3：HTTPS 重定向不工作

**症状：** 访问 http://aetherix.com 不会重定向到 https

**解决方案：**

检查 Nginx 配置：

```nginx
# 确保有 HTTP 到 HTTPS 的重定向
server {
    listen 80;
    server_name aetherix.com www.aetherix.com;
    return 301 https://$server_name$request_uri;
}
```

重启 Nginx：

```bash
sudo systemctl restart nginx
```

### 问题 4：混合内容警告

**症状：** 浏览器显示 "此页面包含不安全的内容"

**解决方案：**

确保所有资源都使用 HTTPS：

```bash
# 检查页面源代码中的 HTTP 链接
grep -i "http://" /path/to/html/files

# 更新所有 HTTP 链接为 HTTPS
sed -i 's/http:\/\//https:\/\//g' /path/to/html/files
```

---

## 维护和续期

### 定期检查

```bash
# 每月检查一次证书过期时间
0 0 1 * * certbot renew --quiet

# 检查 DNS 记录
0 0 * * 0 nslookup aetherix.com >> /var/log/dns-check.log
```

### SSL 证书续期

#### Let's Encrypt 自动续期

```bash
# 查看续期计划
sudo certbot renew --dry-run

# 手动续期
sudo certbot renew

# 强制续期
sudo certbot renew --force-renewal
```

#### 更新 SSL 证书

```bash
# 如果需要添加新域名
sudo certbot certonly --nginx -d aetherix.com -d www.aetherix.com -d api.aetherix.com

# 更新 Nginx 配置指向新证书
```

### 域名续期

#### Namecheap 自动续期

1. 登录 Namecheap
2. 进入 **Domain List**
3. 找到 `aetherix.com`
4. 点击 **Manage**
5. 进入 **Renewal Settings**
6. 启用 **Auto Renew**

#### 手动续期

```bash
# 在 Namecheap 中手动续期
1. 登录 Namecheap
2. 进入 Domain List
3. 点击 "Renew" 按钮
4. 选择续期年限
5. 完成支付
```

---

## 完整配置检查清单

部署前请确保完成以下所有项目：

- [ ] 域名已购买（aetherix.com）
- [ ] 域名所有者已验证（AmenJevoson@gmail.com）
- [ ] DNS 记录已配置
- [ ] DNS 已传播（使用 whatsmydns.net 验证）
- [ ] SSL 证书已申请
- [ ] SSL 证书已安装
- [ ] HTTPS 可访问（https://aetherix.com）
- [ ] HTTP 重定向到 HTTPS
- [ ] SSL 证书有效期已验证
- [ ] 自动续期已启用
- [ ] SSL Labs 评分为 A 或 A+
- [ ] 所有资源都通过 HTTPS 加载
- [ ] 浏览器中没有安全警告

---

## 快速参考

### DNS 记录快速配置

**Vercel 部署：**
```
A 记录：@ → 76.76.19.132
CNAME 记录：www → cname.vercel-dns.com
```

**AWS 部署：**
```
CNAME 记录：@ → your-alb-dns.elb.amazonaws.com
CNAME 记录：www → your-alb-dns.elb.amazonaws.com
```

**Railway 部署：**
```
CNAME 记录：@ → your-railway-domain.railway.app
CNAME 记录：www → your-railway-domain.railway.app
```

### SSL 证书快速命令

```bash
# 申请证书
sudo certbot certonly --nginx -d aetherix.com -d www.aetherix.com

# 测试续期
sudo certbot renew --dry-run

# 查看证书信息
openssl x509 -in /etc/letsencrypt/live/aetherix.com/fullchain.pem -text -noout

# 查看证书过期时间
openssl x509 -in /etc/letsencrypt/live/aetherix.com/fullchain.pem -noout -dates
```

---

## 支持和帮助

- 📧 **Namecheap 支持：** support@namecheap.com
- 📧 **Let's Encrypt 支持：** https://letsencrypt.org/contact/
- 📧 **Vercel 支持：** https://vercel.com/support
- 📧 **AWS 支持：** https://console.aws.amazon.com/support/

---

**域名和 SSL 配置完成后，您的 AETHERIX 平台将完全准备好上线！🚀**
