#!/usr/bin/env python3
from app import app, db
from models import User, Vehicle, Activity, Evaluator, Evaluation, Category, ActivityEvaluator
from werkzeug.security import generate_password_hash
from datetime import datetime
import os

with app.app_context():
    # 删除所有表
    print("删除所有表...")
    db.drop_all()
    
    # 创建所有表
    print("创建所有表...")
    db.create_all()
    
    # 初始化管理员账号
    print("初始化管理员账号...")
    admin = User(
        username='admin',
        password=generate_password_hash('admin123')
    )
    db.session.add(admin)
    
    # 初始化分类数据
    print("初始化分类数据...")
    default_categories = [
        Category(name='动力总成', name_en='Powertrain', icon='powertrain', order=1),
        Category(name='底盘', name_en='Chassis', icon='chassis', order=2),
        Category(name='内饰', name_en='Interior', icon='interior', order=3),
        Category(name='外饰', name_en='Exterior', icon='exterior', order=4),
        Category(name='声学', name_en='Acoustic', icon='acoustic', order=5),
        Category(name='电子电器', name_en='Electronic', icon='electronic', order=6),
        Category(name='其它', name_en='Others', icon='other', order=7)
    ]
    for category in default_categories:
        db.session.add(category)
    
    # 初始化车型数据
    print("初始化车型数据...")
    vehicles = [
        Vehicle(name='Pos.6-vw316/8 CM_B A SUVe Black Label', model='SUVe Black Label'),
        Vehicle(name='BMW X5 xDrive40i', model='X5'),
        Vehicle(name='Mercedes-Benz GLE 450', model='GLE'),
        Vehicle(name='Audi Q7 55 TFSI', model='Q7')
    ]
    for vehicle in vehicles:
        db.session.add(vehicle)
    
    # 初始化评价人数据
    print("初始化评价人数据...")
    evaluators = [
        Evaluator(name='张三', department='动力总成部'),
        Evaluator(name='李四', department='底盘部'),
        Evaluator(name='王五', department='内饰部'),
        Evaluator(name='赵六', department='外饰部'),
        Evaluator(name='陈七', department='电子电器部'),
        Evaluator(name='刘八', department='质量部'),
        Evaluator(name='孙九', department='研发部'),
        Evaluator(name='周十', department='测试部')
    ]
    for evaluator in evaluators:
        db.session.add(evaluator)
    
    db.session.commit()
    
    # 初始化活动数据
    print("初始化活动数据...")
    activities = [
        Activity(
            name='CFF Warm主试车 - 2024年1月',
            date=datetime(2024, 1, 15).date(),
            vehicle_id=1
        ),
        Activity(
            name='冬季测试活动 - 2024年2月',
            date=datetime(2024, 2, 20).date(),
            vehicle_id=2
        ),
        Activity(
            name='春季评测活动 - 2024年3月',
            date=datetime(2024, 3, 10).date(),
            vehicle_id=3
        )
    ]
    for activity in activities:
        db.session.add(activity)
    
    db.session.commit()
    
    # 为活动关联评价人
    print("为活动关联评价人...")
    # 第一个活动关联前4个评价人
    for i in range(1, 5):
        ae = ActivityEvaluator(activity_id=1, evaluator_id=i)
        db.session.add(ae)
    
    # 第二个活动关联后4个评价人
    for i in range(5, 9):
        ae = ActivityEvaluator(activity_id=2, evaluator_id=i)
        db.session.add(ae)
    
    db.session.commit()
    
    # 初始化一些示例评价数据
    print("初始化示例评价数据...")
    sample_evaluations = [
        Evaluation(
            activity_id=1,
            vehicle_id=1,
            evaluator_id=1,
            category='动力总成',
            category_id=1,
            score=8,
            content='动力输出平顺，加速响应良好，但在高速行驶时噪音略大。建议优化发动机隔音材料。'
        ),
        Evaluation(
            activity_id=1,
            vehicle_id=1,
            evaluator_id=2,
            category='底盘',
            category_id=2,
            score=9,
            content='悬架调校偏向舒适，过弯侧倾控制良好。刹车脚感线性，制动力充足。'
        ),
        Evaluation(
            activity_id=1,
            vehicle_id=1,
            evaluator_id=3,
            category='内饰',
            category_id=3,
            score=7,
            content='内饰用料考究，做工精细。中控屏幕反应灵敏，但部分按键位置不够合理。'
        )
    ]
    for eval in sample_evaluations:
        db.session.add(eval)
    
    db.session.commit()
    
    print("\n数据库重置完成！")
    print("默认管理员账号: admin / admin123")
    print("访问地址: http://localhost:5000")