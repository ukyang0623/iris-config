#!/bin/bash

# 自动化Git环境配置脚本
set -e # 遇到错误立即退出

echo "=== 开始自动化Git环境配置 ==="

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

# 1. 生成SSH密钥对
generate_ssh_key() {
    log_info "步骤1: 生成SSH密钥对"
    
    # 检查是否已存在SSH密钥
    if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
        log_warning "检测到已存在的SSH密钥文件"
        read -p "是否覆盖现有密钥? (y/N): " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            log_info "使用现有SSH密钥"
            return 0
        fi
    fi
    
    # 获取用户邮箱
    read -p "请输入您的GitHub邮箱地址: " email
    if [ -z "$email" ]; then
        log_error "邮箱地址不能为空"
        exit 1
    fi
    
    # 选择密钥类型
    log_info "选择密钥类型:"
    echo "1) ED25519 (推荐)"
    echo "2) RSA 4096"
    read -p "请选择(默认1): " key_type
    
    case $key_type in
        2|"rsa")
            key_type="rsa"
            key_file="$HOME/.ssh/id_rsa"
            ssh-keygen -t rsa -b 4096 -C "$email" -f "$key_file"
            ;;
        *)
            key_type="ed25519"
            key_file="$HOME/.ssh/id_ed25519"
            ssh-keygen -t ed25519 -C "$email" -f "$key_file"
            ;;
    esac
    
    # 设置正确的权限
    chmod 700 ~/.ssh
    chmod 600 "$key_file"
    chmod 644 "$key_file.pub"
    
    log_success "SSH密钥已生成: $key_file"
}

# 2. 将公钥上传到GitHub
upload_to_github() {
    log_info "步骤2: 配置GitHub SSH公钥"
    
    # 检测公钥文件
    if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
        pub_key_file="$HOME/.ssh/id_ed25519.pub"
    elif [ -f "$HOME/.ssh/id_rsa.pub" ]; then
        pub_key_file="$HOME/.ssh/id_rsa.pub"
    else
        log_error "未找到SSH公钥文件"
        exit 1
    fi
   
    # 显示公钥内容
    log_info "您的公钥内容:"
    cat "$pub_key_file"
    echo ""
    
    # 复制公钥到剪贴板（如果支持）
    if command -v pbcopy >/dev/null 2>&1; then
        # macOS
        cat "$pub_key_file" | pbcopy
        log_info "公钥已复制到剪贴板 (macOS)"
    elif command -v xclip >/dev/null 2>&1; then
        # Linux
        cat "$pub_key_file" | xclip -selection clipboard
        log_info "公钥已复制到剪贴板 (Linux)"
    elif command -v clip >/dev/null 2>&1; then
        # Windows
        cat "$pub_key_file" | clip
        log_info "公钥已复制到剪贴板 (Windows)"
    else
        log_warning "无法自动复制到剪贴板，请手动复制上述公钥内容"
    fi
    
    log_info "请手动完成以下步骤:"
    echo "1. 登录 GitHub → Settings → SSH and GPG keys"
    echo "2. 点击 'New SSH key'"
    echo "3. 标题: $(hostname)-$(date +%Y%m%d)"
    echo "4. 密钥类型: Authentication Key"
    echo "5. 粘贴公钥内容"
    echo "6. 点击 'Add SSH key'"
    
    read -p "完成后按回车键继续..." dummy
}

# 3. 测试GitHub连接
test_github_connection() {
    log_info "步骤3: 测试GitHub连接"
    
    # 等待用户完成公钥添加
    read -p "请确保已在GitHub添加公钥，然后按回车键继续测试连接..." dummy
    
    # 测试SSH连接
    log_info "测试SSH连接到GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        log_success "GitHub SSH连接测试成功!"
    else
        log_warning "SSH连接测试未返回成功信息，但可能仍可正常工作"
        ssh -T git@github.com || true
    fi
}

# 4. 从GitHub仓库拉取.gitconfig配置
pull_gitconfig() {
    log_info "步骤4: 拉取.gitconfig配置"
    
    # read -p "请输入包含.gitconfig文件的GitHub仓库URL (例如: https://github.com/username/repo.git): " repo_url
    # if [ -z "$repo_url" ]; then
    #     log_warning "未提供仓库URL，跳过.gitconfig拉取"
    #     return 0
    # fi
    
    # 如果已有.gitconfig配置，则先备份
    if [ -f "$HOME/.gitconfig" ]; then
         backup_file="$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
         cp "$HOME/.gitconfig" "$backup_file"
         log_info "已备份原.gitconfig: $backup_file"
    fi

    # 临时目录用于克隆仓库
    temp_dir=$(mktemp -d)
    repo_url="https://github.com/ukyang0623/iris-config.git"
    
    # 克隆仓库，适配内网无ssl证书环境
    log_info "克隆iris-config..."
    if git clone -c http.sslverify=false "$repo_url" "$temp_dir"; then
        # 查找.gitconfig文件
        if [ -f "$temp_dir/.gitconfig" ]; then
            cp "$temp_dir/.gitconfig" "$HOME/.gitconfig"
            log_success ".gitconfig已复制到 $HOME/"
        elif [ -f "$temp_dir/gitconfig" ]; then
            cp "$temp_dir/gitconfig" "$HOME/.gitconfig"
            log_success "gitconfig已复制到 $HOME/.gitconfig"
        else
            log_warning "仓库中未找到.gitconfig或gitconfig文件"
            # 检查可能的标准配置文件位置
            find "$temp_dir" -name "*gitconfig*" -o -name "*git*config*" | while read file; do
                log_info "发现可能的相关文件: $file"
            done
        fi
        
        # 清理临时文件
        rm -rf "$temp_dir"
    else
        log_error "克隆仓库失败: $repo_url"
        rm -rf "$temp_dir"
        return 1
    fi
}

# 5. 配置用户信息
setup_git_config() {
    log_info "步骤5: 配置Git用户信息（如果无需配置，直接回车即可）"
    
    # 如果已有.gitconfig，备份原文件
    if [ -f "$HOME/.gitconfig" ]; then
    	# 设置全局Git配置
    	read -p "请输入Git用户名: " git_name
    	read -p "请输入Git邮箱: " git_email
    	read -p "请输入http代理（例如http://127.0.0.1:7897）: " http_proxy
    	read -p "请输入https代理（例如http://127.0.0.1:7897）: " https_proxy
	read -p "请输入是否需要跳过github SSL证书校验（y/n）: " ssl_verify
    
    	if [ -n "$git_name" ]; then
        	git config --global user.name "$git_name"
    	fi
    
    	if [ -n "$git_email" ]; then
        	git config --global user.email "$git_email"
    	fi

    	if [ -n "$http_proxy" ]; then
        	git config --global http.proxy "$http_proxy"
    	fi

    	if [ -n "$https_proxy" ]; then
        	git config --global https.proxy "$https_proxy"
    	fi

    	if [ -n "$ssl_verify" ]; then
    		case $key_type in
        		"y")
        			git config --global http.sslverify=false 
        			git config --global https.sslverify=false 
            		;;
    		esac
    	fi
    
    	# 设置一些常用配置
    	# git config --global push.default simple
    	# git config --global pull.rebase false
    	# git config --global init.defaultBranch main
    
    	log_success "Git基础配置已完成"
    else
	log_error "未找到.gitconfig配置文件，请重新执行脚本"
	return 1
    fi
    
}

# 6. 验证配置
verify_setup() {
    log_info "步骤6: 验证配置"
    
    echo "=== 当前Git配置 ==="
    git config --global --list
    
    echo ""
    echo "=== SSH密钥 ==="
    ls -la ~/.ssh/id_*
    
    echo ""
    log_success "自动化配置完成!"
    log_info "请手动验证: ssh -T git@github.com"
}

# 主执行函数
main() {
    echo "=== Git环境自动化配置脚本 ==="
    echo "此脚本将执行以下操作:"
    echo "1. 生成SSH密钥对"
    echo "2. 指导您将公钥添加到GitHub"
    echo "3. 测试GitHub连接"
    echo "4. 从GitHub仓库拉取.gitconfig配置"
    echo "5. 设置基本的Git配置"
    echo ""
    
    # 确认执行
    read -p "是否继续? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log_info "操作已取消"
        exit 0
    fi
    
    # 执行各个步骤
    generate_ssh_key
    upload_to_github
    test_github_connection
    pull_gitconfig
    setup_git_config
    verify_setup
}

# 脚本执行入口
if [[ "$(basename "$0")" == "$(basename "$BASH_SOURCE")" ]] || 
   { [[ "$0" == *"sh" ]] || [[ "$0" == *"bash" ]]; } && { [[ -t 0 ]] || [[ -p /dev/stdin ]]; }; then
    main "$@"
fi
