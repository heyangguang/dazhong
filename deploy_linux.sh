#!/bin/bash

# =========================================
# 试车反馈评价系统 - Linux一键部署脚本
# AI自动生成 - 企业级部署标准
# =========================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 部署配置
APP_NAME="vehicle-evaluation-system"
APP_USER="vehicleeval"
APP_DIR="/opt/${APP_NAME}"
SERVICE_NAME="vehicleeval"
NGINX_SITE="${APP_NAME}"
DB_NAME="vehicle_evaluation"

# 打印带颜色的信息
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

# 打印横幅
print_banner() {
    echo -e "${BLUE}"
    echo "============================================"
    echo "   试车反馈评价系统 - 智能部署工具 v1.0"
    echo "      AI Generated Deployment Script"
    echo "============================================"
    echo -e "${NC}"
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "此脚本必须以root权限运行"
        exit 1
    fi
}

# 检查系统类型
check_system() {
    print_info "检查系统环境..."
    
    if [[ -f /etc/redhat-release ]]; then
        OS="centos"
        PACKAGE_MANAGER="yum"
    elif [[ -f /etc/debian_version ]]; then
        OS="ubuntu"
        PACKAGE_MANAGER="apt-get"
    else
        print_error "不支持的操作系统"
        exit 1
    fi
    
    print_success "检测到系统: $OS"
}

# 更新系统包
update_system() {
    print_info "更新系统包..."
    
    if [[ "$OS" == "ubuntu" ]]; then
        apt-get update -y
        apt-get upgrade -y
    else
        yum update -y
    fi
    
    print_success "系统更新完成"
}

# 安装基础依赖
install_dependencies() {
    print_info "安装系统依赖..."
    
    PACKAGES="python3 python3-pip python3-venv git nginx sqlite3 supervisor curl wget"
    
    if [[ "$OS" == "ubuntu" ]]; then
        apt-get install -y $PACKAGES python3-dev build-essential
    else
        yum install -y $PACKAGES python3-devel gcc
    fi
    
    print_success "依赖安装完成"
}

# 创建应用用户
create_app_user() {
    print_info "创建应用用户..."
    
    if id "$APP_USER" &>/dev/null; then
        print_warning "用户 $APP_USER 已存在"
    else
        useradd -m -s /bin/bash $APP_USER
        print_success "用户 $APP_USER 创建成功"
    fi
}

# 创建目录结构
create_directories() {
    print_info "创建目录结构..."
    
    # 创建应用目录
    mkdir -p $APP_DIR
    mkdir -p $APP_DIR/logs
    mkdir -p $APP_DIR/backups
    mkdir -p $APP_DIR/uploads
    mkdir -p $APP_DIR/temp
    
    # 设置权限
    chown -R $APP_USER:$APP_USER $APP_DIR
    chmod -R 755 $APP_DIR
    
    print_success "目录创建完成"
}

# 克隆或更新代码
deploy_code() {
    print_info "部署应用代码..."
    
    cd $APP_DIR
    
    # 这里假设代码已经在当前目录
    # 实际部署时可以从Git仓库克隆
    if [[ -d "/root/dazhong" ]]; then
        cp -r /root/dazhong/* $APP_DIR/
        print_success "代码复制完成"
    else
        print_error "源代码目录不存在"
        exit 1
    fi
    
    # 设置权限
    chown -R $APP_USER:$APP_USER $APP_DIR
}

# 创建Python虚拟环境
setup_virtualenv() {
    print_info "创建Python虚拟环境..."
    
    cd $APP_DIR
    sudo -u $APP_USER python3 -m venv venv
    
    # 创建requirements.txt
    cat > requirements.txt << EOF
Flask==2.3.2
Flask-Login==0.6.2
Flask-SQLAlchemy==3.0.5
SQLAlchemy==2.0.19
python-docx==0.8.11
Werkzeug==2.3.6
gunicorn==21.2.0
EOF
    
    # 安装Python包
    sudo -u $APP_USER venv/bin/pip install --upgrade pip
    sudo -u $APP_USER venv/bin/pip install -r requirements.txt
    
    print_success "虚拟环境设置完成"
}

# 初始化数据库
init_database() {
    print_info "初始化数据库..."
    
    cd $APP_DIR
    
    # 创建数据库初始化脚本
    cat > init_db.py << 'EOF'
from app import app, db
from models import Category

with app.app_context():
    # 创建所有表
    db.create_all()
    
    # 检查是否已有数据
    if Category.query.count() == 0:
        # 添加默认分类
        categories = [
            Category(name='动力系统', name_en='Powertrain'),
            Category(name='底盘', name_en='Chassis'),
            Category(name='内饰', name_en='Interior'),
            Category(name='外观', name_en='Exterior'),
            Category(name='声学', name_en='Acoustics'),
            Category(name='电子', name_en='Electronics'),
            Category(name='其他', name_en='Others')
        ]
        
        for category in categories:
            db.session.add(category)
        
        db.session.commit()
        print("默认分类已添加")
    
    print("数据库初始化完成")
EOF
    
    # 运行初始化脚本
    sudo -u $APP_USER venv/bin/python init_db.py
    
    print_success "数据库初始化完成"
}

# 配置Nginx
configure_nginx() {
    print_info "配置Nginx..."
    
    # 创建Nginx配置
    cat > /etc/nginx/sites-available/$NGINX_SITE << EOF
server {
    listen 80;
    server_name localhost;
    
    client_max_body_size 50M;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
    
    location /static {
        alias $APP_DIR/static;
        expires 30d;
    }
    
    location /uploads {
        alias $APP_DIR/uploads;
        expires 30d;
    }
}
EOF
    
    # 启用站点
    ln -sf /etc/nginx/sites-available/$NGINX_SITE /etc/nginx/sites-enabled/
    
    # 测试配置
    nginx -t
    
    # 重启Nginx
    systemctl restart nginx
    systemctl enable nginx
    
    print_success "Nginx配置完成"
}

# 配置Systemd服务
configure_systemd() {
    print_info "配置系统服务..."
    
    # 创建systemd服务文件
    cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=Vehicle Evaluation System
After=network.target

[Service]
Type=exec
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
ExecStart=$APP_DIR/venv/bin/gunicorn -w 4 -b 127.0.0.1:8000 --timeout 120 --access-logfile $APP_DIR/logs/access.log --error-logfile $APP_DIR/logs/error.log app:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # 重新加载systemd
    systemctl daemon-reload
    
    # 启动服务
    systemctl start $SERVICE_NAME
    systemctl enable $SERVICE_NAME
    
    print_success "系统服务配置完成"
}

# 配置防火墙
configure_firewall() {
    print_info "配置防火墙..."
    
    if command -v ufw &> /dev/null; then
        ufw allow 80/tcp
        ufw allow 443/tcp
        ufw allow 22/tcp
        print_success "UFW防火墙配置完成"
    elif command -v firewall-cmd &> /dev/null; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
        print_success "Firewalld防火墙配置完成"
    else
        print_warning "未检测到防火墙服务"
    fi
}

# 创建定时备份任务
setup_backup() {
    print_info "设置自动备份..."
    
    # 创建备份脚本
    cat > $APP_DIR/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/vehicle-evaluation-system/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_FILE="/opt/vehicle-evaluation-system/instance/vehicle_evaluation.db"

# 创建备份
if [ -f "$DB_FILE" ]; then
    cp $DB_FILE $BACKUP_DIR/vehicle_evaluation_$DATE.db
    
    # 保留最近7天的备份
    find $BACKUP_DIR -name "*.db" -mtime +7 -delete
fi
EOF
    
    chmod +x $APP_DIR/backup.sh
    chown $APP_USER:$APP_USER $APP_DIR/backup.sh
    
    # 添加cron任务
    echo "0 2 * * * $APP_USER $APP_DIR/backup.sh" >> /etc/crontab
    
    print_success "自动备份设置完成"
}

# 性能优化
optimize_performance() {
    print_info "优化系统性能..."
    
    # 调整系统参数
    cat >> /etc/sysctl.conf << EOF

# 性能优化参数
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 30
EOF
    
    sysctl -p
    
    print_success "性能优化完成"
}

# 生成部署报告
generate_report() {
    print_info "生成部署报告..."
    
    REPORT_FILE="$APP_DIR/deployment_report_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > $REPORT_FILE << EOF
=====================================
     部署报告
=====================================
部署时间: $(date)
系统版本: $(uname -a)
Python版本: $(python3 --version)
部署目录: $APP_DIR
服务状态: $(systemctl is-active $SERVICE_NAME)
Nginx状态: $(systemctl is-active nginx)

访问地址:
- 前端地址: http://$(hostname -I | awk '{print $1}')
- 后台地址: http://$(hostname -I | awk '{print $1}')/admin

默认管理员:
- 用户名: admin
- 密码: admin123

重要目录:
- 应用目录: $APP_DIR
- 日志目录: $APP_DIR/logs
- 备份目录: $APP_DIR/backups
- 上传目录: $APP_DIR/uploads

维护命令:
- 查看服务状态: systemctl status $SERVICE_NAME
- 重启服务: systemctl restart $SERVICE_NAME
- 查看日志: tail -f $APP_DIR/logs/error.log
=====================================
EOF
    
    cat $REPORT_FILE
    print_success "部署报告已生成: $REPORT_FILE"
}

# 主函数
main() {
    print_banner
    
    # 执行部署步骤
    check_root
    check_system
    update_system
    install_dependencies
    create_app_user
    create_directories
    deploy_code
    setup_virtualenv
    init_database
    configure_nginx
    configure_systemd
    configure_firewall
    setup_backup
    optimize_performance
    generate_report
    
    print_success "部署完成！"
    print_info "访问 http://$(hostname -I | awk '{print $1}') 查看系统"
    print_info "默认管理员账号: admin / admin123"
}

# 执行主函数
main