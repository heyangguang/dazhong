// 自定义Alert组件
function showAlert(message, type = 'info', buttonText = '确定') {
    // 创建alert容器
    const alertDiv = document.createElement('div');
    alertDiv.className = 'custom-alert';
    
    // 根据类型选择图标
    let iconHTML = '';
    switch(type) {
        case 'success':
            iconHTML = '<svg width="30" height="30" viewBox="0 0 24 24" fill="none"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>';
            break;
        case 'error':
            iconHTML = '<svg width="30" height="30" viewBox="0 0 24 24" fill="none"><path d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>';
            break;
        default:
            iconHTML = '<svg width="30" height="30" viewBox="0 0 24 24" fill="none"><path d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>';
    }
    
    alertDiv.innerHTML = `
        <div class="custom-alert-content">
            <div class="custom-alert-icon ${type}">
                ${iconHTML}
            </div>
            <div class="custom-alert-message">${message}</div>
            <button class="custom-alert-button" onclick="closeCustomAlert(this)">${buttonText}</button>
        </div>
    `;
    
    document.body.appendChild(alertDiv);
    
    // 显示alert
    setTimeout(() => {
        alertDiv.style.display = 'block';
    }, 10);
    
    // 返回Promise以支持await
    return new Promise((resolve) => {
        alertDiv.querySelector('.custom-alert-button').addEventListener('click', () => {
            resolve();
        });
    });
}

function closeCustomAlert(button) {
    const alertDiv = button.closest('.custom-alert');
    alertDiv.style.display = 'none';
    setTimeout(() => {
        alertDiv.remove();
    }, 300);
}

// 覆盖原生alert
window.alert = function(message) {
    return showAlert(message, 'info');
};

// 提供额外的方法
window.alertSuccess = function(message) {
    return showAlert(message, 'success');
};

window.alertError = function(message) {
    return showAlert(message, 'error');
};

// 多语言支持
const translations = {
    zh: {
        confirm: '确定',
        cancel: '取消',
        save_success: '保存成功',
        save_failed: '保存失败，请重试',
        delete_confirm: '确定要删除吗？',
        operation_success: '操作成功',
        operation_failed: '操作失败',
        please_select: '请选择',
        please_input: '请输入',
        password_error: '密码错误',
        switch_success: '切换成功',
        no_data: '暂无数据'
    },
    en: {
        confirm: 'OK',
        cancel: 'Cancel',
        save_success: 'Saved successfully',
        save_failed: 'Save failed, please try again',
        delete_confirm: 'Are you sure to delete?',
        operation_success: 'Operation successful',
        operation_failed: 'Operation failed',
        please_select: 'Please select',
        please_input: 'Please enter',
        password_error: 'Password error',
        switch_success: 'Switch successful',
        no_data: 'No data'
    }
};

// 获取当前语言
function getCurrentLang() {
    return localStorage.getItem('language') || 'zh';
}

// 获取翻译文本
function t(key) {
    const lang = getCurrentLang();
    return translations[lang][key] || translations['zh'][key] || key;
}