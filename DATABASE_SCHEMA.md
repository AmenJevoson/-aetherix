# AETHERIX 数据库 Schema 完整文档

**项目名称：** AETHERIX - Web3 原生 AI 风控生态终端  
**数据库类型：** MySQL 8.0+ / TiDB  
**字符集：** utf8mb4  
**排序规则：** utf8mb4_unicode_ci

---

## 📋 表结构概览

| 表名 | 用途 | 记录数估计 |
|------|------|----------|
| `users` | 用户账户 | 10K-100K |
| `subscriptions` | 邮件订阅 | 100K-1M |
| `holdings` | 用户持仓 | 50K-500K |
| `risk_alerts` | 风险预警 | 100K-1M |
| `market_predictions` | 行情预测 | 10K-100K |
| `audit_logs` | 审计日志 | 1M+ |
| `ai_responses` | AI 响应缓存 | 100K-1M |
| `user_preferences` | 用户偏好 | 10K-100K |

---

## 📊 详细表结构

### 1. users（用户表）

**用途：** 存储用户账户信息和认证数据

```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户 ID',
  openId VARCHAR(64) UNIQUE NOT NULL COMMENT 'OAuth 唯一标识（google_xxx）',
  name TEXT COMMENT '用户名',
  email VARCHAR(320) COMMENT '邮箱地址（脱敏存储）',
  loginMethod VARCHAR(64) COMMENT '登录方式（google/email）',
  role ENUM('user', 'admin') DEFAULT 'user' COMMENT '用户角色',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  lastSignedIn TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '最后登录时间',
  
  KEY idx_openId (openId),
  KEY idx_email (email),
  KEY idx_role (role),
  KEY idx_createdAt (createdAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户账户表';
```

**字段说明：**
- `openId`：Google OAuth 返回的唯一 ID，格式为 `google_{google_id}`
- `email`：加密存储，前端脱敏显示
- `role`：用户角色（user=普通用户，admin=管理员）
- `lastSignedIn`：用于统计活跃用户

---

### 2. subscriptions（订阅表）

**用途：** 管理邮件订阅和通知偏好

```sql
CREATE TABLE subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '订阅 ID',
  email VARCHAR(320) UNIQUE NOT NULL COMMENT '订阅邮箱',
  status ENUM('active', 'inactive', 'unsubscribed') DEFAULT 'active' COMMENT '订阅状态',
  subscriptionType SET('weekly_report', 'risk_alerts', 'market_news') DEFAULT 'weekly_report' COMMENT '订阅类型',
  subscribedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '订阅时间',
  unsubscribedAt TIMESTAMP NULL COMMENT '取消订阅时间',
  lastEmailSentAt TIMESTAMP NULL COMMENT '最后发送邮件时间',
  
  KEY idx_email (email),
  KEY idx_status (status),
  KEY idx_subscribedAt (subscribedAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='邮件订阅表';
```

**字段说明：**
- `status`：active=已订阅，inactive=暂停，unsubscribed=已取消
- `subscriptionType`：支持多种订阅类型

---

### 3. holdings（持仓表）

**用途：** 存储用户加密货币持仓信息

```sql
CREATE TABLE holdings (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '持仓 ID',
  userId INT NOT NULL COMMENT '用户 ID',
  symbol VARCHAR(20) NOT NULL COMMENT '币种符号（BTC/ETH/etc）',
  amount DECIMAL(20, 8) NOT NULL COMMENT '持仓数量',
  entryPrice DECIMAL(20, 8) COMMENT '买入价格',
  currentPrice DECIMAL(20, 8) COMMENT '当前价格',
  costBasis DECIMAL(20, 2) COMMENT '成本基础（加密存储）',
  riskLevel ENUM('low', 'medium', 'high', 'critical') DEFAULT 'medium' COMMENT '风险等级',
  notes TEXT COMMENT '备注',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  KEY idx_userId (userId),
  KEY idx_symbol (symbol),
  KEY idx_riskLevel (riskLevel),
  UNIQUE KEY unique_user_symbol (userId, symbol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户持仓表';
```

**字段说明：**
- `amount`：使用 DECIMAL 确保精度
- `costBasis`：加密存储，不直接显示
- `riskLevel`：基于 AI 分析自动更新

---

### 4. risk_alerts（风险预警表）

**用途：** 记录系统生成的风险预警

```sql
CREATE TABLE risk_alerts (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预警 ID',
  userId INT NOT NULL COMMENT '用户 ID',
  symbol VARCHAR(20) NOT NULL COMMENT '币种符号',
  riskType ENUM('price_drop', 'liquidity_drain', 'whale_transfer', 'contract_risk', 'sentiment_negative', 'extreme_volatility') COMMENT '风险类型',
  riskLevel ENUM('low', 'medium', 'high', 'critical') NOT NULL COMMENT '风险等级',
  message TEXT NOT NULL COMMENT '预警信息',
  actionRecommendation TEXT COMMENT '建议操作',
  aiModel VARCHAR(50) COMMENT '生成此预警的 AI 模型',
  confidence DECIMAL(3, 2) COMMENT '置信度（0-1）',
  isRead BOOLEAN DEFAULT FALSE COMMENT '是否已读',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  KEY idx_userId (userId),
  KEY idx_symbol (symbol),
  KEY idx_riskLevel (riskLevel),
  KEY idx_riskType (riskType),
  KEY idx_createdAt (createdAt),
  KEY idx_isRead (isRead)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='风险预警表';
```

**字段说明：**
- `riskType`：6 种风险类型
- `aiModel`：记录生成此预警的模型（GPT-5.5/Claude 4.6/Canminus）
- `confidence`：AI 预测的置信度

---

### 5. market_predictions（行情预测表）

**用途：** 存储 AI 生成的行情预测

```sql
CREATE TABLE market_predictions (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '预测 ID',
  symbol VARCHAR(20) NOT NULL COMMENT '币种符号',
  timeframe ENUM('1h', '3h', '24h', '7d') NOT NULL COMMENT '预测时间框架',
  prediction ENUM('bullish', 'bearish', 'neutral') NOT NULL COMMENT '预测方向',
  targetPrice DECIMAL(20, 8) COMMENT '目标价格',
  stopLoss DECIMAL(20, 8) COMMENT '止损价格',
  takeProfit DECIMAL(20, 8) COMMENT '止盈价格',
  confidence DECIMAL(3, 2) COMMENT '置信度（0-1）',
  reasoning TEXT COMMENT '分析理由',
  aiModels JSON COMMENT '使用的 AI 模型列表',
  crossValidation BOOLEAN COMMENT '是否通过双模型交叉验证',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  expiresAt TIMESTAMP COMMENT '预测过期时间',
  
  KEY idx_symbol (symbol),
  KEY idx_timeframe (timeframe),
  KEY idx_createdAt (createdAt),
  KEY idx_expiresAt (expiresAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='行情预测表';
```

**字段说明：**
- `aiModels`：JSON 格式存储使用的模型列表
- `crossValidation`：是否通过 GPT-5.5 和 Claude 4.6 的双模型验证

---

### 6. audit_logs（审计日志表）

**用途：** 记录所有敏感操作

```sql
CREATE TABLE audit_logs (
  id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志 ID',
  userId INT COMMENT '用户 ID',
  action VARCHAR(100) NOT NULL COMMENT '操作类型',
  resource VARCHAR(100) NOT NULL COMMENT '资源类型',
  details JSON COMMENT '操作详情',
  ipHash VARCHAR(64) COMMENT 'IP 地址哈希',
  userAgent TEXT COMMENT '用户代理',
  status ENUM('success', 'failure') DEFAULT 'success' COMMENT '操作状态',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  
  KEY idx_userId (userId),
  KEY idx_action (action),
  KEY idx_resource (resource),
  KEY idx_createdAt (createdAt),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审计日志表';
```

**字段说明：**
- `ipHash`：IP 地址的 SHA-256 哈希（隐私保护）
- `details`：JSON 格式存储操作的详细信息

---

### 7. ai_responses（AI 响应缓存表）

**用途：** 缓存 AI 响应以提高性能

```sql
CREATE TABLE ai_responses (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '缓存 ID',
  userId INT COMMENT '用户 ID',
  queryHash VARCHAR(64) NOT NULL COMMENT '查询哈希',
  queryType VARCHAR(50) NOT NULL COMMENT '查询类型',
  response LONGTEXT NOT NULL COMMENT 'AI 响应内容',
  model VARCHAR(50) COMMENT 'AI 模型',
  tokensUsed INT COMMENT '使用的 token 数',
  cost DECIMAL(10, 6) COMMENT '成本',
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  expiresAt TIMESTAMP COMMENT '缓存过期时间',
  
  KEY idx_userId (userId),
  KEY idx_queryHash (queryHash),
  KEY idx_queryType (queryType),
  KEY idx_expiresAt (expiresAt)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI 响应缓存表';
```

**字段说明：**
- `queryHash`：查询内容的 SHA-256 哈希，用于快速查找
- `expiresAt`：缓存过期时间，过期后自动清理

---

### 8. user_preferences（用户偏好表）

**用途：** 存储用户的个性化设置

```sql
CREATE TABLE user_preferences (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '偏好 ID',
  userId INT NOT NULL UNIQUE COMMENT '用户 ID',
  riskTolerance ENUM('low', 'medium', 'high') DEFAULT 'medium' COMMENT '风险承受能力',
  preferredSectors JSON COMMENT '偏好的赛道',
  notificationSettings JSON COMMENT '通知设置',
  theme ENUM('light', 'dark') DEFAULT 'dark' COMMENT '主题',
  language VARCHAR(10) DEFAULT 'zh' COMMENT '语言',
  timezone VARCHAR(50) DEFAULT 'UTC' COMMENT '时区',
  updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  
  FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
  KEY idx_userId (userId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户偏好表';
```

**字段说明：**
- `preferredSectors`：JSON 格式存储用户感兴趣的赛道
- `notificationSettings`：JSON 格式存储通知偏好

---

## 🔑 索引策略

### 常用查询的索引

```sql
-- 用户相关查询
CREATE INDEX idx_users_openId ON users(openId);
CREATE INDEX idx_users_email ON users(email);

-- 持仓查询
CREATE INDEX idx_holdings_userId_symbol ON holdings(userId, symbol);

-- 风险预警查询
CREATE INDEX idx_risk_alerts_userId_createdAt ON risk_alerts(userId, createdAt DESC);

-- 行情预测查询
CREATE INDEX idx_market_predictions_symbol_timeframe ON market_predictions(symbol, timeframe);

-- 审计日志查询
CREATE INDEX idx_audit_logs_userId_createdAt ON audit_logs(userId, createdAt DESC);

-- AI 响应缓存查询
CREATE INDEX idx_ai_responses_queryHash_expiresAt ON ai_responses(queryHash, expiresAt);
```

---

## 🔐 数据安全措施

### 1. 加密字段

```sql
-- 邮箱地址加密
UPDATE users SET email = AES_ENCRYPT(email, 'encryption_key');

-- 成本基础加密
UPDATE holdings SET costBasis = AES_ENCRYPT(costBasis, 'encryption_key');
```

### 2. 脱敏视图

```sql
-- 创建脱敏视图（用于前端展示）
CREATE VIEW users_masked AS
SELECT 
  id,
  openId,
  name,
  CONCAT(SUBSTRING(email, 1, 1), '***@', SUBSTRING(email, FIND_IN_SET('@', email) + 1)) AS email_masked,
  role,
  createdAt
FROM users;
```

---

## 📈 性能优化建议

### 1. 分区策略

```sql
-- 按时间分区审计日志（大表）
ALTER TABLE audit_logs PARTITION BY RANGE (YEAR(createdAt)) (
  PARTITION p2024 VALUES LESS THAN (2025),
  PARTITION p2025 VALUES LESS THAN (2026),
  PARTITION p2026 VALUES LESS THAN (2027),
  PARTITION pmax VALUES LESS THAN MAXVALUE
);
```

### 2. 定期清理

```sql
-- 清理过期的 AI 响应缓存
DELETE FROM ai_responses WHERE expiresAt < NOW();

-- 清理过期的市场预测
DELETE FROM market_predictions WHERE expiresAt < NOW();

-- 归档旧的审计日志（保留 1 年）
ARCHIVE TABLE audit_logs WHERE createdAt < DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

### 3. 查询优化

```sql
-- 使用 EXPLAIN 分析查询
EXPLAIN SELECT * FROM holdings WHERE userId = 1 AND symbol = 'BTC';

-- 使用覆盖索引
CREATE INDEX idx_holdings_cover ON holdings(userId, symbol, amount, entryPrice);
```

---

## 🔄 数据迁移

### 从其他系统迁移

```sql
-- 导入用户数据
INSERT INTO users (openId, name, email, loginMethod, role)
SELECT CONCAT('google_', external_id), name, email, 'google', 'user'
FROM external_users;

-- 导入持仓数据
INSERT INTO holdings (userId, symbol, amount, entryPrice)
SELECT user_id, symbol, quantity, buy_price
FROM external_holdings;
```

---

## 📊 监控和维护

### 1. 表大小监控

```sql
-- 查看表大小
SELECT 
  TABLE_NAME,
  ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'aetherix'
ORDER BY size_mb DESC;
```

### 2. 索引效率

```sql
-- 查看未使用的索引
SELECT * FROM sys.schema_unused_indexes;

-- 查看索引大小
SELECT * FROM sys.schema_index_statistics;
```

### 3. 定期维护

```sql
-- 分析表
ANALYZE TABLE users, subscriptions, holdings, risk_alerts;

-- 优化表
OPTIMIZE TABLE users, subscriptions, holdings, risk_alerts;

-- 检查表
CHECK TABLE users, subscriptions, holdings, risk_alerts;
```

---

## 📋 备份和恢复

### 完整备份

```bash
# 备份整个数据库
mysqldump -u root -p aetherix > aetherix-backup-$(date +%Y%m%d).sql

# 备份特定表
mysqldump -u root -p aetherix users subscriptions holdings > aetherix-core-backup.sql
```

### 恢复

```bash
# 恢复整个数据库
mysql -u root -p aetherix < aetherix-backup-20260630.sql

# 恢复特定表
mysql -u root -p aetherix < aetherix-core-backup.sql
```

---

## 🚀 扩展性规划

### 未来表结构扩展

```sql
-- 支持多链资产
CREATE TABLE cross_chain_holdings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  chainId INT NOT NULL,
  tokenAddress VARCHAR(100) NOT NULL,
  amount DECIMAL(20, 8),
  FOREIGN KEY (userId) REFERENCES users(id)
);

-- 支持 DeFi 头寸
CREATE TABLE defi_positions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  protocol VARCHAR(50),
  positionType ENUM('lending', 'borrowing', 'liquidity_pool'),
  collateral DECIMAL(20, 8),
  debt DECIMAL(20, 8),
  FOREIGN KEY (userId) REFERENCES users(id)
);

-- 支持交易历史
CREATE TABLE trade_history (
  id INT AUTO_INCREMENT PRIMARY KEY,
  userId INT NOT NULL,
  symbol VARCHAR(20),
  type ENUM('buy', 'sell'),
  amount DECIMAL(20, 8),
  price DECIMAL(20, 8),
  timestamp TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id)
);
```

---

**数据库设计完成。准备好部署了吗？🚀**
