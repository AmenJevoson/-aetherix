#!/bin/bash

# ============================================
# AETHERIX 本地一键启动脚本
# ============================================
# 用法: bash start.sh [dev|prod|docker]

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：打印信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js 未安装。请先安装 Node.js 22+"
    exit 1
fi

print_info "Node.js 版本: $(node --version)"

# 检查 pnpm
if ! command -v pnpm &> /dev/null; then
    print_warning "pnpm 未安装，正在安装..."
    npm install -g pnpm
fi

print_info "pnpm 版本: $(pnpm --version)"

# 检查 .env 文件
if [ ! -f .env ]; then
    print_warning ".env 文件不存在，正在从 .env.example 创建..."
    cp .env.example .env
    print_warning "请编辑 .env 文件并填入实际的环境变量值"
fi

# 启动模式
MODE=${1:-dev}

case $MODE in
    dev)
        print_info "启动开发模式..."
        print_info "1. 安装依赖..."
        pnpm install

        print_info "2. 初始化数据库..."
        pnpm db:push

        print_info "3. 启动开发服务器..."
        print_success "应用启动成功！"
        print_info "前端: http://localhost:5173"
        print_info "后端: http://localhost:3000"
        print_info "API: http://localhost:3000/api/trpc"
        
        pnpm dev
        ;;

    prod)
        print_info "启动生产模式..."
        print_info "1. 安装依赖..."
        pnpm install --prod

        print_info "2. 构建应用..."
        pnpm build

        print_info "3. 启动生产服务器..."
        print_success "应用启动成功！"
        print_info "访问地址: http://localhost:3000"
        
        NODE_ENV=production pnpm start
        ;;

    docker)
        print_info "启动 Docker 容器..."
        
        if ! command -v docker &> /dev/null; then
            print_error "Docker 未安装。请先安装 Docker"
            exit 1
        fi

        print_info "1. 构建 Docker 镜像..."
        docker build -t aetherix:latest .

        print_info "2. 启动 Docker Compose..."
        docker-compose up -d

        print_success "Docker 容器启动成功！"
        print_info "应用地址: http://localhost"
        print_info "MySQL: localhost:3306"
        print_info "Redis: localhost:6379"
        print_info ""
        print_info "查看日志: docker-compose logs -f app"
        print_info "停止容器: docker-compose down"
        ;;

    *)
        print_error "未知的启动模式: $MODE"
        echo ""
        echo "用法: bash start.sh [dev|prod|docker]"
        echo ""
        echo "模式说明:"
        echo "  dev    - 开发模式（Vite 热更新）"
        echo "  prod   - 生产模式（优化构建）"
        echo "  docker - Docker 容器模式（完整栈）"
        exit 1
        ;;
esac
