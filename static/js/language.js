// 全局语言管理
const LanguageManager = {
    // 当前语言
    currentLang: localStorage.getItem('language') || 'zh',
    
    // 翻译字典
    translations: {
        // 通用
        'common.back': { zh: '返回', en: 'Back' },
        'common.save': { zh: '保存', en: 'Save' },
        'common.cancel': { zh: '取消', en: 'Cancel' },
        'common.add': { zh: '添加', en: 'Add' },
        'common.edit': { zh: '编辑', en: 'Edit' },
        'common.delete': { zh: '删除', en: 'Delete' },
        'common.search': { zh: '搜索', en: 'Search' },
        'common.export': { zh: '导出', en: 'Export' },
        'common.view': { zh: '查看', en: 'View' },
        'common.submit': { zh: '提交', en: 'Submit' },
        'common.confirm': { zh: '确认', en: 'Confirm' },
        'common.loading': { zh: '加载中...', en: 'Loading...' },
        'common.noData': { zh: '暂无数据', en: 'No data' },
        
        // 首页
        'home.title': { zh: '试车评价系统', en: 'Vehicle Evaluation System' },
        'home.selectActivity': { zh: '请选择活动', en: 'Please select activity' },
        'home.vehicleInfo': { zh: '车辆信息', en: 'Vehicle Info' },
        'home.startEvaluation': { zh: '评价', en: 'Evaluate' },
        'home.instruction': { zh: '请您点击"评价"按钮进入评价界面。<br>请将iPad留在车内。', en: 'Please click "Evaluate" button to enter evaluation interface.<br>Please leave the iPad in the car.' },
        
        // 分类页面
        'category.title': { zh: '请选择评价分类', en: 'Please select evaluation category' },
        'category.newEvaluation': { zh: '新建评价', en: 'New Evaluation' },
        'category.viewEvaluations': { zh: '评价列表', en: 'Evaluation List' },
        'category.noEvaluations': { zh: '暂无评价', en: 'No evaluations' },
        
        // 评价页面
        'evaluation.title': { zh: '评价', en: 'Evaluation' },
        'evaluation.evaluator': { zh: '评价人员', en: 'Evaluator' },
        'evaluation.selectEvaluator': { zh: '请选择评价人', en: 'Please select evaluator' },
        'evaluation.score': { zh: '评分', en: 'Score' },
        'evaluation.content': { zh: '评价内容', en: 'Evaluation Content' },
        'evaluation.placeholder': { zh: '请输入您的评价内容...', en: 'Please enter your evaluation...' },
        'evaluation.saveSuccess': { zh: '评价保存成功！', en: 'Evaluation saved successfully!' },
        'evaluation.saveFailed': { zh: '评价保存失败，请重试', en: 'Failed to save evaluation, please try again' },
        'evaluation.hint': { zh: '此页面需要输入评价内容、评价人员和评价分数。完成后请点击右下角保存按钮！', en: 'Please enter evaluation content, evaluator and score. Click save button at bottom right when done!' },
        
        // 后台管理
        'admin.title': { zh: '后台管理系统', en: 'Admin Management System' },
        'admin.login': { zh: '登录', en: 'Login' },
        'admin.logout': { zh: '退出登录', en: 'Logout' },
        'admin.username': { zh: '用户名', en: 'Username' },
        'admin.password': { zh: '密码', en: 'Password' },
        'admin.rememberMe': { zh: '记住我', en: 'Remember me' },
        'admin.forgotPassword': { zh: '忘记密码？', en: 'Forgot password?' },
        
        // 管理菜单
        'admin.vehicleManagement': { zh: '车型管理', en: 'Vehicle Management' },
        'admin.evaluatorManagement': { zh: '评价人管理', en: 'Evaluator Management' },
        'admin.activityManagement': { zh: '活动管理', en: 'Activity Management' },
        'admin.categoryManagement': { zh: '分类管理', en: 'Category Management' },
        'admin.reportExport': { zh: '报告导出', en: 'Report Export' },
        
        // 车型管理
        'vehicle.name': { zh: '车型名称', en: 'Vehicle Name' },
        'vehicle.model': { zh: '型号', en: 'Model' },
        'vehicle.infoFile': { zh: '车辆信息文件', en: 'Vehicle Info File' },
        'vehicle.addVehicle': { zh: '添加车型', en: 'Add Vehicle' },
        
        // 评价人管理
        'evaluator.name': { zh: '姓名', en: 'Name' },
        'evaluator.department': { zh: '部门', en: 'Department' },
        'evaluator.addEvaluator': { zh: '添加评价人', en: 'Add Evaluator' },
        
        // 活动管理
        'activity.name': { zh: '活动名称', en: 'Activity Name' },
        'activity.date': { zh: '日期', en: 'Date' },
        'activity.relatedVehicle': { zh: '关联车型', en: 'Related Vehicle' },
        'activity.selectVehicle': { zh: '请选择车型', en: 'Please select vehicle' },
        'activity.selectEvaluators': { zh: '选择评价人（可多选）', en: 'Select Evaluators (multiple)' },
        'activity.evaluatorCount': { zh: '评价人数', en: 'Evaluator Count' },
        'activity.addActivity': { zh: '添加活动', en: 'Add Activity' },
        'activity.viewEvaluations': { zh: '查看评价', en: 'View Evaluations' },
        'activity.exportReport': { zh: '导出报告', en: 'Export Report' },
        
        // 分类管理
        'category.name': { zh: '分类名称', en: 'Category Name' },
        'category.nameEn': { zh: '英文名称', en: 'English Name' },
        'category.icon': { zh: '图标', en: 'Icon' },
        'category.order': { zh: '排序', en: 'Order' },
        'category.status': { zh: '状态', en: 'Status' },
        'category.evaluationCount': { zh: '评价数', en: 'Evaluation Count' },
        'category.enabled': { zh: '启用', en: 'Enabled' },
        'category.disabled': { zh: '禁用', en: 'Disabled' },
        'category.addCategory': { zh: '添加分类', en: 'Add Category' },
        
        // 评价详情
        'evaluation.totalCount': { zh: '总评价数', en: 'Total Evaluations' },
        'evaluation.avgScore': { zh: '平均评分', en: 'Average Score' },
        'evaluation.allCategories': { zh: '所有分类', en: 'All Categories' },
        'evaluation.allScores': { zh: '所有评分', en: 'All Scores' },
        'evaluation.excellent': { zh: '优秀', en: 'Excellent' },
        'evaluation.good': { zh: '良好', en: 'Good' },
        'evaluation.average': { zh: '一般', en: 'Average' },
        'evaluation.poor': { zh: '差', en: 'Poor' },
        'evaluation.searchPlaceholder': { zh: '搜索评价内容...', en: 'Search evaluation content...' },
        'evaluation.time': { zh: '评价时间', en: 'Evaluation Time' },
        
        // 表格通用
        'table.id': { zh: 'ID', en: 'ID' },
        'table.createdAt': { zh: '创建时间', en: 'Created At' },
        'table.actions': { zh: '操作', en: 'Actions' },
        
        // 消息
        'message.confirmDelete': { zh: '确定删除吗？', en: 'Are you sure to delete?' },
        'message.operationSuccess': { zh: '操作成功', en: 'Operation successful' },
        'message.operationFailed': { zh: '操作失败', en: 'Operation failed' },
        'message.pleaseSelect': { zh: '请选择', en: 'Please select' },
        'message.pleaseEnter': { zh: '请输入', en: 'Please enter' },
        'message.required': { zh: '必填', en: 'Required' },
        'message.invalidFormat': { zh: '格式不正确', en: 'Invalid format' },
        'message.uploadFailed': { zh: '上传失败', en: 'Upload failed' },
        'message.downloadReport': { zh: '下载报告', en: 'Download Report' }
    },
    
    // 获取翻译
    t(key) {
        const translation = this.translations[key];
        if (!translation) {
            console.warn(`Translation not found for key: ${key}`);
            return key;
        }
        return translation[this.currentLang] || translation['zh'] || key;
    },
    
    // 切换语言
    switchLanguage(lang) {
        this.currentLang = lang;
        localStorage.setItem('language', lang);
        this.updatePageLanguage();
    },
    
    // 更新页面语言
    updatePageLanguage() {
        // 更新所有带有 data-lang 属性的元素
        document.querySelectorAll('[data-lang]').forEach(element => {
            const key = element.getAttribute('data-lang');
            const translation = this.t(key);
            
            if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                element.placeholder = translation;
            } else {
                element.innerHTML = translation;
            }
        });
        
        // 更新语言切换器状态
        document.querySelectorAll('.lang-switch span').forEach(span => {
            span.classList.remove('active');
        });
        const activeLang = document.querySelector(`.lang-${this.currentLang}`);
        if (activeLang) {
            activeLang.classList.add('active');
        }
        
        // 触发自定义事件
        window.dispatchEvent(new CustomEvent('languageChanged', { detail: this.currentLang }));
    },
    
    // 初始化
    init() {
        // 页面加载时更新语言
        document.addEventListener('DOMContentLoaded', () => {
            this.updatePageLanguage();
        });
        
        // 监听语言切换
        document.addEventListener('click', (e) => {
            if (e.target.matches('.lang-zh, .lang-en')) {
                const lang = e.target.classList.contains('lang-zh') ? 'zh' : 'en';
                this.switchLanguage(lang);
            }
        });
    }
};

// 初始化语言管理器
LanguageManager.init();

// 导出全局函数
window.t = (key) => LanguageManager.t(key);
window.switchLang = (lang) => LanguageManager.switchLanguage(lang);