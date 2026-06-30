# AETHERIX REST API 标准化接口文档

**项目名称：** AETHERIX - Web3 原生 AI 风控生态终端  
**API 版本：** 1.0.0  
**最后更新：** 2026-06-30

---

## 📋 目录

1. [API 基础信息](#api-基础信息)
2. [认证系统](#认证系统)
3. [用户管理](#用户管理)
4. [风控功能](#风控功能)
5. [订阅管理](#订阅管理)
6. [错误处理](#错误处理)
7. [数据安全](#数据安全)

---

## API 基础信息

### 基础 URL

```
生产环境：https://aetherix.com/api
开发环境：http://localhost:3000/api
```

### API 协议

- **协议：** tRPC + REST
- **内容类型：** application/json
- **字符编码：** UTF-8
- **响应格式：** JSON

### 请求头

所有请求应包含以下头部：

```http
Content-Type: application/json
Authorization: Bearer {sessionToken}  // 仅限需要认证的端点
```

---

## 认证系统

### 1. 获取 Google OAuth 登录 URL

**端点：** `GET /trpc/auth.getGoogleLoginUrl`

**描述：** 获取 Google OAuth 登录 URL，用于重定向用户到 Google 登录页面

**请求参数：** 无

**响应示例：**

```json
{
  "result": {
    "data": {
      "url": "https://accounts.google.com/o/oauth2/v2/auth?...",
      "state": "random_state_string"
    }
  }
}
```

**状态码：** 200

---

### 2. Google OAuth 回调处理

**端点：** `POST /trpc/auth.handleGoogleCallback`

**描述：** 处理 Google OAuth 回调，交换授权码获取用户信息

**请求体：**

```json
{
  "code": "authorization_code_from_google",
  "state": "state_from_login_url"
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "success": true,
      "user": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "role": "user"
      }
    }
  }
}
```

**状态码：** 200 (成功) / 401 (未授权) / 500 (服务器错误)

---

### 3. 获取当前用户信息

**端点：** `GET /trpc/auth.me`

**描述：** 获取当前登录用户的信息

**认证：** 必需

**请求参数：** 无

**响应示例：**

```json
{
  "result": {
    "data": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "role": "user",
      "createdAt": "2026-06-30T12:00:00Z"
    }
  }
}
```

**状态码：** 200 (成功) / 401 (未认证)

---

### 4. 登出

**端点：** `POST /trpc/auth.logout`

**描述：** 登出当前用户，清除会话

**认证：** 必需

**请求体：** 无

**响应示例：**

```json
{
  "result": {
    "data": {
      "success": true
    }
  }
}
```

**状态码：** 200

---

## 用户管理

### 用户角色系统

AETHERIX 支持两种用户角色：

| 角色 | 权限 | 描述 |
|------|------|------|
| `user` | 标准用户权限 | 普通用户，可使用所有风控功能 |
| `admin` | 管理员权限 | 系统管理员，可管理用户和系统配置 |

### 用户数据结构

```typescript
interface User {
  id: number;                    // 用户 ID
  openId: string;                // OAuth 唯一标识
  name: string | null;           // 用户名
  email: string | null;          // 邮箱（脱敏存储）
  loginMethod: string | null;    // 登录方式（google/email）
  role: 'user' | 'admin';        // 用户角色
  createdAt: Date;               // 创建时间
  updatedAt: Date;               // 更新时间
  lastSignedIn: Date;            // 最后登录时间
}
```

---

## 风控功能

### 1. 行情预判推演

**端点：** `POST /trpc/riskControl.predictMarket`

**描述：** AI 推演未来 3h/24h 行情走向

**认证：** 必需

**请求体：**

```json
{
  "symbol": "BTC",
  "timeframe": "3h",
  "riskLevel": "medium"
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "symbol": "BTC",
      "prediction": "bullish",
      "confidence": 0.85,
      "targetPrice": 45000,
      "stopLoss": 42000,
      "takeProfit": 48000,
      "reasoning": "AI analysis shows strong uptrend..."
    }
  }
}
```

---

### 2. 暗盘隐性风险预警

**端点：** `POST /trpc/riskControl.detectHiddenRisks`

**描述：** 抓取链上大额异动、流动性抽离

**认证：** 必需

**请求体：**

```json
{
  "symbol": "ETH",
  "sensitivity": "high"
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "symbol": "ETH",
      "riskLevel": "high",
      "risks": [
        {
          "type": "large_transfer",
          "amount": 10000,
          "description": "Large whale transfer detected"
        }
      ]
    }
  }
}
```

---

### 3. 持仓 AI 风控保镖

**端点：** `POST /trpc/riskControl.monitorHoldings`

**描述：** 监控用户持仓，定时推送风险提醒

**认证：** 必需

**请求体：**

```json
{
  "holdings": [
    {
      "symbol": "BTC",
      "amount": 1.5,
      "entryPrice": 40000
    }
  ]
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "status": "monitoring",
      "alerts": [
        {
          "symbol": "BTC",
          "type": "price_drop",
          "message": "Price dropped 5% below entry"
        }
      ]
    }
  }
}
```

---

### 4. 交易风格定制推送

**端点：** `POST /trpc/riskControl.getCustomRecommendations`

**描述：** 根据交易习惯推送定制化机会

**认证：** 必需

**请求体：**

```json
{
  "riskTolerance": "medium",
  "preferredSectors": ["DeFi", "Layer2"]
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "opportunities": [
        {
          "symbol": "AAVE",
          "reason": "Matches your DeFi preference",
          "riskScore": 0.6
        }
      ]
    }
  }
}
```

---

### 5. 舆情 AI 真假过滤

**端点：** `POST /trpc/riskControl.filterNews`

**描述：** 筛查全网资讯，剔除虚假消息

**认证：** 必需

**请求体：**

```json
{
  "keywords": ["Bitcoin", "Ethereum"],
  "sources": ["twitter", "news"]
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "news": [
        {
          "title": "Bitcoin Reaches New ATH",
          "credibility": 0.95,
          "source": "Reuters",
          "isFake": false
        }
      ]
    }
  }
}
```

---

### 6. 极端行情急救系统

**端点：** `POST /trpc/riskControl.emergencyRescue`

**描述：** 暴跌行情时生成避险操作指南

**认证：** 必需

**请求体：**

```json
{
  "symbol": "BTC",
  "priceDropPercent": -15,
  "holdings": [
    {
      "symbol": "BTC",
      "amount": 1.5
    }
  ]
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "urgency": "critical",
      "actions": [
        {
          "type": "spot",
          "recommendation": "Consider taking profits at 20% loss"
        },
        {
          "type": "futures",
          "recommendation": "Close leveraged positions immediately"
        }
      ]
    }
  }
}
```

---

### 7. 悬浮 AI 对话舱

**端点：** `POST /trpc/riskControl.askAI`

**描述：** 实时 AI 对话，获取风控建议

**认证：** 必需

**请求体：**

```json
{
  "question": "Should I buy Bitcoin at current price?",
  "context": {
    "currentPrice": 45000,
    "holdings": [{"symbol": "BTC", "amount": 1}]
  }
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "answer": "Based on current market conditions...",
      "confidence": 0.82,
      "sources": ["on-chain data", "sentiment analysis"]
    }
  }
}
```

---

## 订阅管理

### 1. 订阅邮件列表

**端点：** `POST /trpc/subscription.subscribe`

**描述：** 订阅 AETHERIX 周报和风控提醒

**认证：** 不需要

**请求体：**

```json
{
  "email": "user@example.com"
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "success": true,
      "message": "Successfully subscribed"
    }
  }
}
```

---

### 2. 取消订阅

**端点：** `POST /trpc/subscription.unsubscribe`

**描述：** 取消订阅

**认证：** 不需要

**请求体：**

```json
{
  "email": "user@example.com"
}
```

**响应示例：**

```json
{
  "result": {
    "data": {
      "success": true,
      "message": "Successfully unsubscribed"
    }
  }
}
```

---

## 错误处理

### 标准错误响应格式

```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "User is not authenticated",
    "details": {}
  }
}
```

### 常见错误码

| 错误码 | HTTP 状态 | 描述 |
|--------|-----------|------|
| `UNAUTHORIZED` | 401 | 用户未认证 |
| `FORBIDDEN` | 403 | 用户无权限 |
| `NOT_FOUND` | 404 | 资源不存在 |
| `BAD_REQUEST` | 400 | 请求参数错误 |
| `INTERNAL_SERVER_ERROR` | 500 | 服务器内部错误 |
| `SERVICE_UNAVAILABLE` | 503 | 服务暂时不可用 |

---

## 数据安全

### 隐私保护措施

1. **数据加密**
   - 所有敏感数据（钱包地址、持仓信息）使用 AES-256-GCM 加密
   - 传输层使用 HTTPS/TLS 1.3

2. **数据脱敏**
   - 邮箱地址脱敏显示（例：j***@example.com）
   - 钱包地址脱敏显示（例：0x1234...5678）
   - 持仓数量显示为范围（例：1-10 BTC）

3. **审计日志**
   - 所有敏感操作记录在审计日志
   - 包括用户 ID、操作类型、时间戳、IP 哈希

4. **双模型交叉校验**
   - 关键风险判断使用 GPT-5.5 + Claude 4.6 双模型验证
   - 两份结论分歧时增加风险提示

---

## 速率限制

### 限制规则

- **认证用户：** 100 请求/分钟
- **未认证用户：** 10 请求/分钟
- **AI 调用：** 20 请求/分钟

### 响应头

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1625097600
```

---

## 版本历史

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| 1.0.0 | 2026-06-30 | 初始版本发布 |

---

## 支持

如有问题，请联系：**AmenJevoson@gmail.com**

---

**文档生成时间：** 2026-06-30  
**API 状态：** 生产就绪 ✅
