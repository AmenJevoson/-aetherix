# AETHERIX - Multi-stage Docker Build
# 支持 Vercel、AWS、Railway 等多平台部署

# ============================================
# Stage 1: Dependencies
# ============================================
FROM node:22-alpine AS dependencies

WORKDIR /app

# 复制 package 文件
COPY package.json pnpm-lock.yaml ./

# 安装 pnpm
RUN npm install -g pnpm@10.4.1

# 安装依赖
RUN pnpm install --frozen-lockfile

# ============================================
# Stage 2: Builder
# ============================================
FROM node:22-alpine AS builder

WORKDIR /app

# 从 dependencies 阶段复制 node_modules
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=dependencies /app/pnpm-lock.yaml ./pnpm-lock.yaml

# 复制源代码
COPY . .

# 构建前端
RUN npm run build

# ============================================
# Stage 3: Runtime
# ============================================
FROM node:22-alpine AS runtime

WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm@10.4.1

# 仅复制必要的运行时文件
COPY --from=builder /app/package.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/drizzle ./drizzle

# 安装生产依赖
RUN pnpm install --prod --frozen-lockfile

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=3000

# 暴露端口
EXPOSE 3000

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# 启动应用
CMD ["node", "dist/index.js"]
