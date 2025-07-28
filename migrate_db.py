#!/usr/bin/env python3
import sqlite3
import os

# 备份数据库
if os.path.exists('evaluation.db'):
    os.system('cp evaluation.db evaluation_backup.db')
    print("数据库已备份到 evaluation_backup.db")

# 连接数据库
conn = sqlite3.connect('evaluation.db')
cursor = conn.cursor()

# 检查表是否存在
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = cursor.fetchall()
print("现有表：", [t[0] for t in tables])

# 创建category表
try:
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) NOT NULL UNIQUE,
        name_en VARCHAR(50),
        icon VARCHAR(100),
        'order' INTEGER DEFAULT 0,
        is_active BOOLEAN DEFAULT 1,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''')
    print("创建category表成功")
except Exception as e:
    print(f"创建category表失败: {e}")

# 创建activity_evaluator表
try:
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS activity_evaluator (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_id INTEGER NOT NULL,
        evaluator_id INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (activity_id) REFERENCES activity(id),
        FOREIGN KEY (evaluator_id) REFERENCES evaluator(id),
        UNIQUE(activity_id, evaluator_id)
    )
    ''')
    print("创建activity_evaluator表成功")
except Exception as e:
    print(f"创建activity_evaluator表失败: {e}")

# 检查evaluation表是否有category_id列
cursor.execute("PRAGMA table_info(evaluation)")
columns = cursor.fetchall()
column_names = [col[1] for col in columns]

if 'category_id' not in column_names:
    print("添加category_id列到evaluation表...")
    try:
        cursor.execute('ALTER TABLE evaluation ADD COLUMN category_id INTEGER')
        print("成功添加category_id列")
    except Exception as e:
        print(f"添加category_id列失败: {e}")

# 插入默认分类数据
default_categories = [
    ('动力总成', 'Powertrain', 'powertrain', 1),
    ('底盘', 'Chassis', 'chassis', 2),
    ('内饰', 'Interior', 'interior', 3),
    ('外饰', 'Exterior', 'exterior', 4),
    ('声学', 'Acoustic', 'acoustic', 5),
    ('电子电器', 'Electronic', 'electronic', 6),
    ('其它', 'Others', 'other', 7)
]

for name, name_en, icon, order in default_categories:
    try:
        cursor.execute('''
        INSERT OR IGNORE INTO category (name, name_en, icon, 'order', is_active)
        VALUES (?, ?, ?, ?, 1)
        ''', (name, name_en, icon, order))
    except Exception as e:
        print(f"插入分类{name}失败: {e}")

# 更新现有评价的category_id
print("更新现有评价的category_id...")
cursor.execute("SELECT id, name FROM category")
categories = cursor.fetchall()
category_map = {name: id for id, name in categories}

for cat_name, cat_id in category_map.items():
    cursor.execute('''
    UPDATE evaluation 
    SET category_id = ? 
    WHERE category = ?
    ''', (cat_id, cat_name))

conn.commit()
print("数据库迁移完成！")

# 显示迁移后的统计
cursor.execute("SELECT COUNT(*) FROM category")
cat_count = cursor.fetchone()[0]
print(f"分类总数: {cat_count}")

cursor.execute("SELECT COUNT(*) FROM evaluation WHERE category_id IS NOT NULL")
eval_count = cursor.fetchone()[0]
print(f"已更新category_id的评价数: {eval_count}")

conn.close()