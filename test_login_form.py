#!/usr/bin/env python3
import requests

# 测试登录表单提交
url = "http://localhost:5000/admin/login"

# 测试GET请求 - 获取登录页面
response = requests.get(url)
print(f"GET请求状态码: {response.status_code}")
print(f"页面是否包含登录表单: {'form' in response.text}")
print(f"页面是否包含用户名输入框: {'username' in response.text}")
print(f"页面是否包含密码输入框: {'password' in response.text}")

# 测试POST请求 - 提交登录表单
login_data = {
    'username': 'admin',
    'password': 'admin123'
}

session = requests.Session()
response = session.post(url, data=login_data, allow_redirects=False)
print(f"\n登录POST请求状态码: {response.status_code}")
print(f"重定向位置: {response.headers.get('Location', '无')}")

# 检查是否登录成功
if response.status_code == 302:
    print("登录成功！")