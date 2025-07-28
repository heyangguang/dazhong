# =========================================
# 试车反馈评价系统 - Windows一键部署脚本
# AI自动生成 - 企业级部署标准
# 需要以管理员权限运行PowerShell
# =========================================

# 设置错误处理
$ErrorActionPreference = "Stop"

# 部署配置
$AppName = "vehicle-evaluation-system"
$AppDir = "C:\Apps\$AppName"
$PythonVersion = "3.11.0"
$ServiceName = "VehicleEvalService"
$ServiceDisplayName = "Vehicle Evaluation System"
$Port = 8000

# 颜色函数
function Write-Info {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param($Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Error {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Warning {
    param($Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

# 打印横幅
function Show-Banner {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Blue
    Write-Host "   试车反馈评价系统 - 智能部署工具 v1.0" -ForegroundColor Blue
    Write-Host "      AI Generated Deployment Script" -ForegroundColor Blue
    Write-Host "============================================" -ForegroundColor Blue
    Write-Host ""
}

# 检查管理员权限
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 检查并安装Chocolatey
function Install-Chocolatey {
    Write-Info "检查Chocolatey包管理器..."
    
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Info "安装Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # 刷新环境变量
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Success "Chocolatey安装完成"
    } else {
        Write-Success "Chocolatey已安装"
    }
}

# 安装系统依赖
function Install-Dependencies {
    Write-Info "安装系统依赖..."
    
    # 安装Python
    Write-Info "安装Python $PythonVersion..."
    choco install python --version=$PythonVersion -y --force
    
    # 安装Git
    Write-Info "安装Git..."
    choco install git -y
    
    # 安装SQLite
    Write-Info "安装SQLite..."
    choco install sqlite -y
    
    # 安装NSSM (服务管理器)
    Write-Info "安装NSSM..."
    choco install nssm -y
    
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    Write-Success "依赖安装完成"
}

# 创建目录结构
function Create-Directories {
    Write-Info "创建目录结构..."
    
    # 创建应用目录
    $directories = @(
        $AppDir,
        "$AppDir\logs",
        "$AppDir\backups",
        "$AppDir\uploads",
        "$AppDir\temp",
        "$AppDir\instance"
    )
    
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    Write-Success "目录创建完成"
}

# 部署应用代码
function Deploy-Code {
    Write-Info "部署应用代码..."
    
    # 复制代码文件
    $sourceDir = "C:\dazhong"  # 假设源代码在这个位置
    
    if (Test-Path $sourceDir) {
        Copy-Item -Path "$sourceDir\*" -Destination $AppDir -Recurse -Force
        Write-Success "代码复制完成"
    } else {
        # 如果本地没有代码，创建基本文件
        Write-Warning "源代码目录不存在，创建示例文件..."
        
        # 复制当前目录的文件
        $currentDir = Get-Location
        Copy-Item -Path "$currentDir\*" -Destination $AppDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 创建Python虚拟环境
function Setup-VirtualEnv {
    Write-Info "创建Python虚拟环境..."
    
    Set-Location $AppDir
    
    # 创建虚拟环境
    python -m venv venv
    
    # 创建requirements.txt
    $requirements = @"
Flask==2.3.2
Flask-Login==0.6.2
Flask-SQLAlchemy==3.0.5
SQLAlchemy==2.0.19
python-docx==0.8.11
Werkzeug==2.3.6
waitress==2.1.2
"@
    
    $requirements | Out-File -FilePath "requirements.txt" -Encoding UTF8
    
    # 激活虚拟环境并安装包
    & "$AppDir\venv\Scripts\python.exe" -m pip install --upgrade pip
    & "$AppDir\venv\Scripts\pip.exe" install -r requirements.txt
    
    Write-Success "虚拟环境设置完成"
}

# 初始化数据库
function Initialize-Database {
    Write-Info "初始化数据库..."
    
    Set-Location $AppDir
    
    # 创建数据库初始化脚本
    $initScript = @'
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
'@
    
    $initScript | Out-File -FilePath "init_db.py" -Encoding UTF8
    
    # 运行初始化脚本
    & "$AppDir\venv\Scripts\python.exe" init_db.py
    
    Write-Success "数据库初始化完成"
}

# 创建Windows服务启动脚本
function Create-ServiceScript {
    Write-Info "创建服务启动脚本..."
    
    # 创建启动脚本
    $startScript = @"
import os
import sys
sys.path.insert(0, r'$AppDir')

# 设置环境变量
os.environ['FLASK_APP'] = 'app.py'

from waitress import serve
from app import app

if __name__ == '__main__':
    print(f"Starting Vehicle Evaluation System on port $Port...")
    serve(app, host='0.0.0.0', port=$Port, threads=4)
"@
    
    $startScript | Out-File -FilePath "$AppDir\service_runner.py" -Encoding UTF8
    
    Write-Success "服务脚本创建完成"
}

# 配置Windows服务
function Configure-WindowsService {
    Write-Info "配置Windows服务..."
    
    # 停止并删除旧服务（如果存在）
    $existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($existingService) {
        Write-Warning "删除已存在的服务..."
        Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
        & nssm remove $ServiceName confirm
    }
    
    # 使用NSSM创建服务
    & nssm install $ServiceName "$AppDir\venv\Scripts\python.exe"
    & nssm set $ServiceName AppParameters "$AppDir\service_runner.py"
    & nssm set $ServiceName AppDirectory "$AppDir"
    & nssm set $ServiceName DisplayName "$ServiceDisplayName"
    & nssm set $ServiceName Description "AI生成的试车反馈评价系统"
    & nssm set $ServiceName Start SERVICE_AUTO_START
    
    # 设置日志
    & nssm set $ServiceName AppStdout "$AppDir\logs\service.log"
    & nssm set $ServiceName AppStderr "$AppDir\logs\error.log"
    & nssm set $ServiceName AppRotateFiles 1
    & nssm set $ServiceName AppRotateBytes 10485760
    
    # 启动服务
    Start-Service -Name $ServiceName
    
    Write-Success "Windows服务配置完成"
}

# 配置Windows防火墙
function Configure-Firewall {
    Write-Info "配置Windows防火墙..."
    
    # 添加防火墙规则
    New-NetFirewallRule -DisplayName "Vehicle Evaluation System" `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort $Port `
        -Action Allow `
        -ErrorAction SilentlyContinue
    
    Write-Success "防火墙配置完成"
}

# 创建桌面快捷方式
function Create-Shortcuts {
    Write-Info "创建快捷方式..."
    
    $WshShell = New-Object -comObject WScript.Shell
    
    # 创建前端访问快捷方式
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\试车评价系统.url")
    $Shortcut.TargetPath = "http://localhost:$Port"
    $Shortcut.Save()
    
    # 创建后台管理快捷方式
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\试车评价系统-管理后台.url")
    $Shortcut.TargetPath = "http://localhost:$Port/admin"
    $Shortcut.Save()
    
    Write-Success "快捷方式创建完成"
}

# 创建定时备份任务
function Setup-BackupTask {
    Write-Info "设置自动备份..."
    
    # 创建备份脚本
    $backupScript = @"
`$backupDir = "$AppDir\backups"
`$date = Get-Date -Format "yyyyMMdd_HHmmss"
`$dbFile = "$AppDir\instance\vehicle_evaluation.db"

if (Test-Path `$dbFile) {
    Copy-Item `$dbFile "`$backupDir\vehicle_evaluation_`$date.db"
    
    # 删除7天前的备份
    Get-ChildItem `$backupDir -Filter "*.db" | 
        Where-Object { `$_.LastWriteTime -lt (Get-Date).AddDays(-7) } | 
        Remove-Item
}
"@
    
    $backupScript | Out-File -FilePath "$AppDir\backup.ps1" -Encoding UTF8
    
    # 创建计划任务
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File `"$AppDir\backup.ps1`""
    $trigger = New-ScheduledTaskTrigger -Daily -At 2:00AM
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
    
    Register-ScheduledTask -TaskName "VehicleEvalBackup" `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Description "自动备份试车评价系统数据库" `
        -Force
    
    Write-Success "自动备份设置完成"
}

# 生成部署报告
function Generate-Report {
    Write-Info "生成部署报告..."
    
    $reportFile = "$AppDir\deployment_report_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    $report = @"
=====================================
     部署报告
=====================================
部署时间: $(Get-Date)
系统版本: $(Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)
Python版本: $(python --version 2>&1)
部署目录: $AppDir
服务名称: $ServiceName
服务状态: $((Get-Service -Name $ServiceName).Status)

访问地址:
- 前端地址: http://localhost:$Port
- 后台地址: http://localhost:$Port/admin

默认管理员:
- 用户名: admin
- 密码: admin123

重要目录:
- 应用目录: $AppDir
- 日志目录: $AppDir\logs
- 备份目录: $AppDir\backups
- 上传目录: $AppDir\uploads

维护命令:
- 查看服务状态: Get-Service -Name $ServiceName
- 重启服务: Restart-Service -Name $ServiceName
- 查看日志: Get-Content "$AppDir\logs\error.log" -Tail 50
- 手动备份: & "$AppDir\backup.ps1"
=====================================
"@
    
    $report | Out-File -FilePath $reportFile -Encoding UTF8
    $report | Write-Host
    
    Write-Success "部署报告已生成: $reportFile"
}

# 主函数
function Main {
    Show-Banner
    
    # 检查管理员权限
    if (!(Test-Administrator)) {
        Write-Error "此脚本需要管理员权限运行！"
        Write-Info "请右键点击PowerShell，选择'以管理员身份运行'"
        exit 1
    }
    
    try {
        # 执行部署步骤
        Install-Chocolatey
        Install-Dependencies
        Create-Directories
        Deploy-Code
        Setup-VirtualEnv
        Initialize-Database
        Create-ServiceScript
        Configure-WindowsService
        Configure-Firewall
        Create-Shortcuts
        Setup-BackupTask
        Generate-Report
        
        Write-Success "部署完成！"
        Write-Info "访问 http://localhost:$Port 查看系统"
        Write-Info "桌面快捷方式已创建"
        Write-Info "默认管理员账号: admin / admin123"
        
        # 询问是否打开浏览器
        $openBrowser = Read-Host "是否立即打开系统? (Y/N)"
        if ($openBrowser -eq 'Y' -or $openBrowser -eq 'y') {
            Start-Process "http://localhost:$Port"
        }
        
    } catch {
        Write-Error "部署失败: $_"
        exit 1
    }
}

# 执行主函数
Main