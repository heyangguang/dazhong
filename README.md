# 🚗 试车反馈评价系统 (Vehicle Evaluation System)

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/Python-3.11+-green.svg" alt="Python">
  <img src="https://img.shields.io/badge/Flask-2.3.2-red.svg" alt="Flask">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  <img src="https://img.shields.io/badge/AI--Generated-100%25-purple.svg" alt="AI Generated">
</p>

## 📋 项目简介

试车反馈评价系统是一个专为汽车试驾评测设计的智能化管理平台。系统采用Flask框架开发，支持iPad端无登录评价和PC端后台管理，实现了评价数据的全流程数字化管理。

### 🌟 核心特性

- 🖥️ **双端支持**：iPad评价端 + PC管理端
- 🌐 **多语言**：中英文实时切换
- 📊 **七大评价维度**：动力、底盘、内饰、外观、声学、电子、其他
- 📝 **Word报告**：一键生成专业评价报告
- 🎨 **Glassmorphism设计**：现代化毛玻璃UI
- 🔒 **安全管理**：后台登录认证，前端免登录
- 🚀 **一键部署**：Linux/Windows自动化部署

## 🛠️ 技术栈

### 后端技术
- **框架**：Flask 2.3.2
- **数据库**：SQLite (可升级PostgreSQL)
- **ORM**：SQLAlchemy 2.0.19
- **认证**：Flask-Login 0.6.2
- **文档生成**：python-docx 0.8.11

### 前端技术
- **基础**：HTML5 + CSS3 + JavaScript
- **框架**：jQuery 3.6.0
- **UI风格**：Glassmorphism (毛玻璃效果)
- **响应式**：iPad优化设计

## 📦 快速开始

### 环境要求

- Python 3.11+
- pip 包管理器
- SQLite3
- 8GB+ 内存推荐

### 安装步骤

#### 方式一：一键部署（推荐）

**Linux系统：**
```bash
# 下载部署脚本
wget https://your-server/deploy_linux.sh

# 执行部署
sudo bash deploy_linux.sh
```

**Windows系统：**
```powershell
# 以管理员身份运行PowerShell
.\deploy_windows.ps1
```

#### 方式二：手动安装

1. **克隆项目**
```bash
git clone https://github.com/your-org/vehicle-evaluation-system.git
cd vehicle-evaluation-system
```

2. **创建虚拟环境**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\Scripts\activate  # Windows
```

3. **安装依赖**
```bash
pip install -r requirements.txt
```

4. **初始化数据库**
```bash
python init_db.py
```

5. **运行应用**
```bash
python app.py
```

6. **访问系统**
- 前端评价：http://localhost:5000
- 后台管理：http://localhost:5000/admin
- 默认账号：admin / admin123

## 📱 使用指南

### 评价端（iPad）

1. **选择车型**
   - 访问首页
   - 从下拉菜单选择要评价的车型
   - 点击"开始评价"

2. **填写评价**
   - 选择评价维度（7个分类）
   - 拖动滑块评分（1-10分）
   - 填写详细评价内容
   - 支持富文本编辑

3. **提交评价**
   - 检查评价内容
   - 点击"提交评价"
   - 系统自动保存

### 管理端（PC）

1. **登录系统**
   - 访问 /admin
   - 输入用户名密码
   - 进入管理后台

2. **数据管理**
   - 车型管理：添加/编辑/删除车型
   - 评价人管理：维护评价人信息
   - 活动管理：创建评价活动
   - 评价查看：查看所有评价记录

3. **报告导出**
   - 选择评价记录
   - 点击"导出Word"
   - 自动生成专业报告

## 📊 系统架构

```
vehicle-evaluation-system/
├── app.py              # 主应用文件
├── models.py           # 数据模型
├── init_db.py          # 数据库初始化
├── requirements.txt    # 依赖列表
├── deploy_linux.sh     # Linux部署脚本
├── deploy_windows.ps1  # Windows部署脚本
├── static/            # 静态资源
│   ├── css/          # 样式文件
│   ├── js/           # JavaScript文件
│   └── images/       # 图片资源
├── templates/         # HTML模板
│   ├── index.html    # 首页
│   ├── evaluation.html # 评价页
│   ├── admin.html    # 管理后台
│   └── ...
├── instance/          # 实例文件夹
│   └── vehicle_evaluation.db  # 数据库文件
└── docs/             # 项目文档
    ├── 需求规格说明书.md
    ├── 系统架构设计文档.md
    └── ...
```

## 🔧 配置说明

### 基础配置

```python
# app.py 中的配置项
SECRET_KEY = 'your-secret-key'  # 修改为随机密钥
SQLALCHEMY_DATABASE_URI = 'sqlite:///instance/vehicle_evaluation.db'
MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 最大上传16MB
```

### 生产环境配置

1. **更换数据库**
```python
# PostgreSQL示例
SQLALCHEMY_DATABASE_URI = 'postgresql://user:pass@localhost/dbname'
```

2. **启用HTTPS**
```nginx
server {
    listen 443 ssl;
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    # ...
}
```

## 🧪 测试

### 运行测试
```bash
# 单元测试
python -m pytest tests/

# 覆盖率测试
python -m pytest --cov=app tests/
```

### 测试账号
- 管理员：admin / admin123
- 测试评价人：已预置5个测试评价人

## 🚀 部署

### 生产环境部署建议

1. **使用Gunicorn**
```bash
gunicorn -w 4 -b 0.0.0.0:8000 app:app
```

2. **配置Nginx反向代理**
```nginx
location / {
    proxy_pass http://127.0.0.1:8000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

3. **设置自动备份**
```bash
# 已在部署脚本中配置每日2点自动备份
```

## 📝 API文档

### 主要接口

| 接口 | 方法 | 描述 | 认证 |
|------|------|------|------|
| `/` | GET | 首页 | 否 |
| `/evaluation/<model_id>` | GET | 评价页面 | 否 |
| `/submit_evaluation` | POST | 提交评价 | 否 |
| `/admin` | GET | 管理后台 | 是 |
| `/api/vehicles` | GET | 获取车型列表 | 否 |
| `/export_word/<id>` | GET | 导出Word报告 | 是 |

### 请求示例

```javascript
// 提交评价
$.ajax({
    url: '/submit_evaluation',
    method: 'POST',
    data: {
        vehicle_model_id: 1,
        category_id: 1,
        score: 8,
        evaluation_content: '评价内容...'
    },
    success: function(response) {
        console.log('提交成功');
    }
});
```

## 🛡️ 安全说明

- ✅ CSRF保护
- ✅ SQL注入防护
- ✅ XSS防护
- ✅ 会话管理
- ✅ 密码加密存储
- ✅ 访问控制

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

- 感谢所有贡献者
- 基于 Flask 框架开发
- UI设计灵感来自现代化设计趋势

## 📞 联系方式

- 项目维护：[维护团队邮箱]
- 问题反馈：[GitHub Issues](https://github.com/your-org/vehicle-evaluation-system/issues)
- 官方网站：[项目官网]

---

<p align="center">
  <strong>🤖 本项目由AI辅助开发，展示AI在软件工程中的强大能力</strong>
</p>