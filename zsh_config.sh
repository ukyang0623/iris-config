#!/bin/bash

# Zsh 自动化安装配置脚本
set -e  # 遇到错误立即退出

echo "=== 开始自动化安装和配置 Zsh 环境 ==="

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

# 1. 安装 Zsh
install_zsh() {
    log_info "步骤1: 安装 Zsh"
    
    # 检查是否已安装 Zsh
    if command -v zsh &> /dev/null; then
        log_warning "Zsh 已安装，版本: $(zsh --version | head -n1)"
        return 0
    fi
    
    # 根据系统类型选择安装命令
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        log_info "检测到 Debian/Ubuntu 系统，使用 apt 安装"
        sudo apt update
        sudo apt install -y zsh curl git
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        log_info "检测到 CentOS/RHEL 系统，使用 yum 安装"
        sudo yum install -y zsh curl git
    elif command -v brew &> /dev/null; then
        # macOS
        log_info "检测到 macOS 系统，使用 brew 安装"
        brew install zsh curl git
    else
        log_error "不支持的系统或包管理器"
        exit 1
    fi
    
    # 验证安装
    if command -v zsh &> /dev/null; then
        log_success "Zsh 安装成功，版本: $(zsh --version | head -n1)"
    else
        log_error "Zsh 安装失败"
        exit 1
    fi
}

# 2. 安装 Oh My Zsh
install_oh_my_zsh() {
    log_info "步骤2: 安装 Oh My Zsh"
    
    # 检查是否已安装 Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh My Zsh 已安装，跳过此步骤"
        return 0
    fi
    
    # 备份现有的 .zshrc（如果存在）
    if [ -f "$HOME/.zshrc" ]; then
        backup_file="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$HOME/.zshrc" "$backup_file"
        log_info "已备份原 .zshrc: $backup_file"
    fi
    
    # 安装 Oh My Zsh（使用官方脚本）
    log_info "下载并安装 Oh My Zsh..."
    if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
        log_success "Oh My Zsh 安装成功, 请输入CTRL-D继续"
    else
        log_error "Oh My Zsh 安装失败，尝试手动安装"
        
        # 手动安装作为备选方案
        git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
        
        log_success "Oh My Zsh 手动安装完成"
    fi
}

# 3. 安装必要插件
install_plugins() {
    log_info "步骤3: 安装 Zsh 插件"
    
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    local themes_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
    
    # 创建插件目录
    mkdir -p "$plugins_dir"
    mkdir -p "$themes_dir"
    
    # 安装 zsh-autosuggestions（自动建议）
    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        log_info "安装 zsh-autosuggestions 插件..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugins_dir/zsh-autosuggestions"
    else
        log_warning "zsh-autosuggestions 插件已存在，跳过安装"
    fi
    
    # 安装 zsh-syntax-highlighting（语法高亮）
    if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        log_info "安装 zsh-syntax-highlighting 插件..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    else
        log_warning "zsh-syntax-highlighting 插件已存在，跳过安装"
    fi
    
    # 安装 zsh-completions（自动补全）
    if [ ! -d "$plugins_dir/zsh-completions" ]; then
        log_info "安装 zsh-completions 插件..."
        git clone https://github.com/zsh-users/zsh-completions.git "$plugins_dir/zsh-completions"
    else
        log_warning "zsh-completions 插件已存在，跳过安装"
    fi
    
    # 安装 autojump（目录快速跳转）
    if command -v apt-get &> /dev/null; then
        sudo apt install -y autojump
    elif command -v yum &> /dev/null; then
        sudo yum install -y autojump
    elif command -v brew &> /dev/null; then
        brew install autojump
    fi
    
    log_success "所有插件安装完成"
}

# 4. 安装 PowerLevel10k 主题
install_powerlevel10k() {
    log_info "步骤4: 安装 PowerLevel10k 主题"
    
    local themes_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
    
    # 安装 PowerLevel10k
    if [ ! -d "$themes_dir/powerlevel10k" ]; then
        log_info "安装 PowerLevel10k 主题..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$themes_dir/powerlevel10k"
        log_success "PowerLevel10k 主题安装成功"
    else
        log_warning "PowerLevel10k 主题已存在，跳过安装"
    fi
}

# 5. 配置 .zshrc
configure_zshrc() {
    log_info "步骤5: 配置 .zshrc"
    
    local zshrc_file="$HOME/.zshrc"
    
    # 备份原 .zshrc
    if [ -f "$zshrc_file" ]; then
        backup_file="$zshrc_file.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$zshrc_file" "$backup_file"
        log_info "已备份原 .zshrc: $backup_file"
    fi
    
    # 创建新的 .zshrc 配置
    cat > "$zshrc_file" << 'EOF'
# 启用 PowerLevel10k 主题
ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh My Zsh 安装目录
export ZSH="$HOME/.oh-my-zsh"

# 插件列表
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    autojump
    extract
    sudo
    web-search
)

# 加载系统环境变量
source /etc/profile

# 加载 Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 插件配置
# zsh-autosuggestions 配置
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# zsh-syntax-highlighting 配置（需在最后加载）
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autojump 配置
if [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh
elif [ -f /usr/local/etc/profile.d/autojump.sh ]; then
    source /usr/local/etc/profile.d/autojump.sh
fi

# 自定义别名
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias srczsh="source ~/.zshrc"
alias ll="ls -alh"

# 历史命令配置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# PowerLevel10k 即时提示（提升启动速度）
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PowerLevel10k 配置文件
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
    
    log_success ".zshrc 配置完成"
}

# 6. 设置默认 Shell
set_default_shell() {
    log_info "步骤6: 设置 Zsh 为默认 Shell"
    
    current_shell=$(basename "$SHELL")
    if [ "$current_shell" = "zsh" ]; then
        log_warning "Zsh 已经是默认 Shell"
        return 0
    fi
    
    # 获取 zsh 路径
    zsh_path=$(command -v zsh)
    if [ -z "$zsh_path" ]; then
        log_error "未找到 Zsh 路径"
        return 1
    fi
    
    # 更改默认 Shell
    if chsh -s "$zsh_path"; then
        log_success "已设置 Zsh 为默认 Shell"
    else
        log_warning "无法自动更改默认 Shell，请手动执行: chsh -s $(which zsh)"
    fi
}

# 7. 完成配置和提示
final_setup() {
    log_info "步骤7: 完成最终配置"
    
    echo ""
    echo "=== 安装完成 ==="
    log_success "Zsh 环境配置已完成！"
    
    echo ""
    echo "=== 下一步操作 ==="
    echo "1. 重新启动终端"
    echo "2. 首次启动时会运行 PowerLevel10k 配置向导"
    echo "3. 如需重新配置 PowerLevel10k，执行: p10k configure"
    echo "4. 常用命令:"
    echo "   - zshconfig: 编辑 .zshrc 配置"
    echo "   - srczsh: 重新加载 .zshrc"
    echo "   - ohmyzsh: 编辑 Oh My Zsh 配置"
    
    echo ""
    echo "=== 已安装的插件 ==="
    echo "✓ zsh-autosuggestions - 命令自动建议"
    echo "✓ zsh-syntax-highlighting - 语法高亮"
    echo "✓ zsh-completions - 自动补全"
    echo "✓ autojump - 目录快速跳转"
    echo "✓ extract - 一键解压"
    echo "✓ sudo - 双击 ESC 添加 sudo"
    echo "✓ web-search - 终端内快速搜索"
    
    echo ""
    log_info "现在可以重新启动终端体验新的 Zsh 环境！"
}

# 主执行函数
main() {
    echo "=== Zsh 自动化安装配置脚本 ==="
    echo "此脚本将执行以下操作:"
    echo "1. 安装 Zsh"
    echo "2. 安装 Oh My Zsh"
    echo "3. 安装常用插件"
    echo "4. 安装 PowerLevel10k 主题"
    echo "5. 配置 .zshrc"
    echo "6. 设置 Zsh 为默认 Shell"
    echo ""
    
    # 确认执行
    read -p "是否继续? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "操作已取消"
        exit 0
    fi
    
    # 执行各个步骤
    install_zsh
    install_oh_my_zsh
    install_plugins
    install_powerlevel10k
    configure_zshrc
    set_default_shell
    final_setup
}

# 脚本执行入口
if [ "$(basename "$0")" = "$(basename "$BASH_SOURCE")" ]; then
    main "$@"
fi
