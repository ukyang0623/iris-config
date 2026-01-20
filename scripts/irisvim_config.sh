#!/bin/bash

# NeoVim Nightly 版本自动化安装脚本
# 特别优化用于 curl | bash 方式执行
set -euo pipefail

# 颜色定义用于输出美化
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 安全的用户输入函数（处理管道执行时的输入问题）
safe_read() {
    local prompt="$1"
    local variable="$2"
    local default="$3"
    
    if [[ -t 0 ]]; then
        # 交互式终端，可以正常读取
        read -p "$prompt" "$variable"
    else
        # 非交互式（管道执行），使用默认值
        printf "%s\n" "$default"
        log_warning "非交互式模式，使用默认值: $default"
    fi
}

# 检测系统架构和类型
detect_system() {
    log_info "检测系统信息..."
    
    ARCH=$(uname -m)
    case "$ARCH" in
        "x86_64") ARCH="x86_64" ;;
        "aarch64"|"arm64") ARCH="aarch64" ;;
        *) log_error "不支持的架构: $ARCH"; exit 1 ;;
    esac
    
    OS=$(uname -s)
    if [[ "$OS" != "Linux" && "$OS" != "Darwin" ]]; then
        log_error "不支持的操作系统: $OS"; exit 1
    fi
    
    log_info "系统: $OS, 架构: $ARCH"
}

# 下载并安装 NeoVim
install_neovim() {
    log_info "开始安装 NeoVim Nightly 版本..."
    
    # 定义下载URL [1,4](@ref)
    if [[ "$OS" == "Linux" ]]; then
	DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
        INSTALL_DIR="/usr/local/nvim-linux-x86_64"
    elif [[ "$OS" == "Darwin" ]]; then
        if [[ "$ARCH" == "x86_64" ]]; then
            DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz"
            INSTALL_DIR="/usr/local/nvim-macos-x86_64"
        else
            DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz"
            INSTALL_DIR="/usr/local/nvim-macos-arm64"
        fi
    fi
    
    # 创建临时目录
    local temp_dir=$(mktemp -d)
    local download_file="$temp_dir/nvim.tar.gz"
    
    # 下载 NeoVim [3](@ref)
    log_info "下载 NeoVim..."
    if ! curl -fsSL -o "$download_file" "$DOWNLOAD_URL"; then
        log_error "下载失败: $DOWNLOAD_URL"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # 检查下载文件
    if [[ ! -s "$download_file" ]]; then
        log_error "下载文件为空或不存在"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # 备份现有安装
    if [[ -d "$INSTALL_DIR" ]]; then
        local backup_dir="$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "备份现有安装: $backup_dir"
        sudo mv "$INSTALL_DIR" "$backup_dir"
    fi
    
    # 解压并安装 [4](@ref)
    log_info "解压到 $INSTALL_DIR..."
    sudo mkdir -p "$INSTALL_DIR"
    sudo tar xzf "$download_file" -C "/usr/local"
    
    # 清理临时文件
    rm -rf "$temp_dir"
    
    log_success "NeoVim 安装完成"
}

# 配置环境变量
configure_environment() {
    log_info "配置环境变量..."
    
    local nvim_bin="$INSTALL_DIR/bin"
    
    # 检测当前使用的shell
    local current_shell=$(basename "$SHELL")
    local config_file=""
    
    case "$current_shell" in
        "bash") config_file="$HOME/.bashrc" ;;
        "zsh") config_file="$HOME/.zshrc" ;;
        *) config_file="$HOME/.profile" ;;
    esac
    
    # 添加PATH配置
    if ! grep -q "usr/local/nvim" "$config_file" 2>/dev/null; then
        echo "export PATH=\"$nvim_bin:\$PATH\"" >> "$config_file"
        log_info "已更新 $config_file"
    fi
    
    # 创建别名 [5](@ref)
    if ! grep -q "alias nv=" "$config_file" 2>/dev/null; then
        echo "alias nv='nvim'" >> "$config_file"
        log_info "已添加别名: nv -> nvim"
    fi
    
    # 立即生效（如果可能）
    if [[ -t 0 ]]; then
        export PATH="$nvim_bin:$PATH"
        alias nv='nvim'
    fi

    source $config_file
    
    log_success "环境变量配置完成"
}

# 验证安装
verify_installation() {
    log_info "验证安装..."
    
    local nvim_bin="$INSTALL_DIR/bin/nvim"
    
    if [[ ! -f "$nvim_bin" ]]; then
        log_error "NeoVim 可执行文件未找到: $nvim_bin"
        return 1
    fi
    
    # 检查版本
    local version=$("$nvim_bin" --version | head -n1 || echo "未知版本")
    log_success "安装成功: $version"
    
    # 检查是否在PATH中
    if command -v nvim >/dev/null 2>&1; then
        log_success "NeoVim 已在 PATH 中"
    else
        log_warning "NeoVim 不在 PATH 中，需要重新登录或执行: source ~/.bashrc (或 ~/.zshrc)"
    fi
}

# 显示使用说明
show_usage() {
    echo ""
    log_success "🎉 NeoVim 安装完成！"
    echo ""
    echo "=== 使用说明 ==="
    echo "📝 立即使用:"
    echo "    nvim    # 启动 NeoVim"
    echo "    nv      # 别名，同样启动 NeoVim"
    echo ""
    echo "🔧 环境生效:"
    echo "    执行以下命令使配置立即生效:"
    echo "    source ~/.bashrc   # 如果使用 bash"
    echo "    source ~/.zshrc    # 如果使用 zsh"
    echo ""
    echo "📋 验证安装:"
    echo "    nvim --version"
    echo "    nv --version"
    echo ""
    log_info "下次打开终端时，nv 命令将自动可用"
}

# 主执行函数
main() {
    echo "=== NeoVim Nightly 版本自动化安装脚本 ==="
    echo ""
    
    # 显示系统信息
    detect_system
    
    # 确认安装
    if [[ -t 0 ]]; then
        read -p "是否继续安装? (y/N): " confirm </dev/tty
        if [[ ! "${confirm:-}" =~ ^[Yy]$ ]]; then
            log_info "安装已取消"
            exit 0
        fi
    else
        log_info "非交互式模式，自动继续安装..."
    fi
    
    # 执行安装步骤
    install_neovim
    configure_environment
    verify_installation
    show_usage
}

# 脚本执行入口
if [[ "$(basename "$0")" == "$(basename "$BASH_SOURCE")" ]] ||
   { [[ "$0" == *"sh" ]] || [[ "$0" == *"bash" ]]; } && { [[ -t 0 ]] || [[ -p /dev/stdin ]]; }; then
    main "$@"
fi
