#!/bin/bash

# IRIS 环境配置安装脚本 - 优化用于 curl | bash 执行
# 功能：从 GitHub 远程获取并执行 Git 配置和 Zsh 配置脚本

set -euo pipefail

# 颜色定义用于输出美化
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 日志函数
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${CYAN}[STEP]${NC} $1"; }

# GitHub 仓库配置（请根据实际情况修改）
GITHUB_USER="ukyang0623"
GITHUB_REPO="iris-config"
GITHUB_BRANCH="refs/heads/main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}/scripts"

# 脚本URL配置
GIT_CONFIG_URL="${BASE_URL}/git_config.sh"
ZSH_CONFIG_URL="${BASE_URL}/zsh_config.sh"

# 安全下载并执行远程脚本函数
safe_download_execute() {
    local script_url="$1"
    local script_name="$2"
    local step_number="$3"
    
    log_step "步骤 ${step_number}: 下载并执行 ${script_name}"
    log_info "下载地址: $script_url"
    
    # 创建临时文件
    local temp_script=$(mktemp) || exit 1
    trap 'rm -f "$temp_script"' EXIT
    
    # 下载脚本
    if ! curl -fsSLk "$script_url" -o "$temp_script" 2>/dev/null; then
        log_error "下载失败: $script_name"
        rm -f "$temp_script"
        return 1
    fi
    
    # 检查文件是否为空
    if [[ ! -s "$temp_script" ]]; then
        log_error "下载的脚本为空: $script_name"
        rm -f "$temp_script"
        return 1
    fi
    
    # 检查脚本语法
    if ! bash -n "$temp_script" 2>/dev/null; then
        log_warning "脚本语法检查警告: $script_name"
    fi
    
    # 添加执行权限并执行
    chmod +x "$temp_script"
    log_info "开始执行 $script_name..."
    
    # 在子shell中执行，避免环境污染
    if bash "$temp_script"; then
        log_success "$script_name 执行完成"
        rm -f "$temp_script"
        return 0
    else
        local exit_code=$?
        log_error "$script_name 执行失败，退出码: $exit_code"
        rm -f "$temp_script"
        return $exit_code
    fi
}

# 环境检查函数
check_environment() {
    log_step "环境检查"
    
    # 检查操作系统
    local os_name=$(uname -s)
    log_info "操作系统: $os_name"
    
    # 检查必要工具
    local tools=("curl" "bash")
    for tool in "${tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            log_success "工具可用: $tool"
        else
            log_error "必要工具未安装: $tool"
            return 1
        fi
    done
    
    # 检查网络连接
    if ! curl -fsSLk --connect-timeout 10 "https://raw.githubusercontent.com" >/dev/null 2>&1; then
        log_warning "GitHub 连接可能不稳定，建议检查网络"
    fi
}

# 显示执行计划
show_execution_plan() {
    log_step "执行计划"
    echo "=================================================="
    echo "         IRIS 环境配置一键安装脚本"
    echo "=================================================="
    echo "📋 安装内容:"
    echo "  1. Git 环境配置"
    echo "  2. Zsh 环境配置"
    echo ""
    echo "🌐 脚本来源:"
    echo "  Git配置: $GIT_CONFIG_URL"
    echo "  Zsh配置: $ZSH_CONFIG_URL"
    echo "=================================================="
    echo ""
}

# 用户确认函数（适配管道执行）
get_user_confirmation() {
    if [[ -t 0 ]]; then
        log_warning "即将开始环境配置安装，这将会修改您的系统配置。"
        read -p "是否继续执行? (y/N): " confirm </dev/tty
        if [[ ! "${confirm:-}" =~ ^[Yy]$ ]]; then
            log_info "安装已取消"
            exit 0
        fi
    else
        log_info "非交互式模式，自动继续安装..."
        # 非交互式模式下等待3秒，让用户有机会中断
        for i in {3..1}; do
            echo -ne "将在 $i 秒后开始安装...\r"
            sleep 1
        done
        echo
    fi
}

# 验证安装结果
verify_installation() {
    log_step "验证安装结果"
    
    # 检查Git配置（如果可用）
    if command -v git >/dev/null 2>&1; then
        log_info "Git版本: $(git --version 2>/dev/null || echo "未知")"
    fi
    
    # 检查Zsh配置（如果可用）
    if command -v zsh >/dev/null 2>&1; then
        log_info "Zsh版本: $(zsh --version 2>/dev/null || echo "未知")"
    fi
    
    log_success "安装验证完成"
}

# 显示完成信息
show_completion_info() {
    echo ""
    log_success "🎉 IRIS 环境配置安装完成！"
    echo ""
    echo "=== 后续操作建议 ==="
    echo "📝 立即生效配置:"
    echo "  执行以下命令使配置立即生效:"
    echo "  source ~/.bashrc   # 如果使用 bash"
    echo "  source ~/.zshrc    # 如果使用 zsh"
    echo ""
    echo "🔧 切换Shell:"
    echo "  如果要默认使用Zsh，执行: chsh -s \$(which zsh)"
    echo ""
    echo "📋 验证配置:"
    echo "  git config --global --list  # 验证Git配置"
    echo "  zsh --version               # 验证Zsh版本"
    echo ""
}

# 错误处理函数
handle_error() {
    local exit_code=$1
    local step_name=$2
    
    log_error "在 $step_name 步骤失败，退出码: $exit_code"
    log_info "建议: 请检查网络连接或稍后重试"
    exit $exit_code
}

# 主执行函数
main() {
    echo "=================================================="
    echo "        IRIS 环境配置一键安装脚本"
    echo "=================================================="
    echo "📝 特别优化用于: curl ... | bash 方式执行"
    echo ""
    
    # 显示执行计划
    show_execution_plan
    
    # 用户确认
    get_user_confirmation
    
    # 环境检查
    if ! check_environment; then
        log_error "环境检查失败，请确保系统满足要求"
        exit 1
    fi
    
    # 执行Git配置脚本
    if safe_download_execute "$GIT_CONFIG_URL" "Git配置" "1"; then
        log_success "Git配置阶段完成"
    else
        handle_error $? "Git配置"
    fi
    
    echo "--------------------------------------------------"
    
    # 执行Zsh配置脚本
    if safe_download_execute "$ZSH_CONFIG_URL" "Zsh配置" "2"; then
        log_success "Zsh配置阶段完成"
    else
        handle_error $? "Zsh配置"
    fi
    
    # 验证安装结果
    verify_installation
    
    # 显示完成信息
    show_completion_info
}

# 脚本执行入口（特别优化用于 curl | bash 执行）
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] || 
   { [[ -n "$BASH_SOURCE" ]] && [[ "$0" =~ bash$ ]]; } then
    # 设置错误处理
    trap 'handle_error $? "未知步骤"' ERR
    
    # 执行主函数
    main "$@"
fi
