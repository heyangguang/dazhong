from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from datetime import datetime

db = SQLAlchemy()

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

class Vehicle(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    model = db.Column(db.String(100))
    info_file = db.Column(db.String(200))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
class Activity(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    date = db.Column(db.Date)
    vehicle_id = db.Column(db.Integer, db.ForeignKey('vehicle.id'))
    vehicle = db.relationship('Vehicle', backref='activities')
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
class Evaluator(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    department = db.Column(db.String(100))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False, unique=True)
    name_en = db.Column(db.String(50))  # 英文名称
    icon = db.Column(db.String(100))  # 图标类型
    order = db.Column(db.Integer, default=0)  # 排序
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)


class ActivityEvaluator(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    activity_id = db.Column(db.Integer, db.ForeignKey('activity.id'), nullable=False)
    evaluator_id = db.Column(db.Integer, db.ForeignKey('evaluator.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # 关系
    activity = db.relationship('Activity', backref='activity_evaluators')
    evaluator = db.relationship('Evaluator', backref='activity_evaluators')
    
    # 确保同一个活动中评价人不重复
    __table_args__ = (db.UniqueConstraint('activity_id', 'evaluator_id'),)

    
class Evaluation(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    activity_id = db.Column(db.Integer, db.ForeignKey('activity.id'))
    vehicle_id = db.Column(db.Integer, db.ForeignKey('vehicle.id'))
    evaluator_id = db.Column(db.Integer, db.ForeignKey('evaluator.id'))
    category_id = db.Column(db.Integer, db.ForeignKey('category.id'), nullable=True)  # 暂时设为可选
    category = db.Column(db.String(50))  # 保留用于向后兼容
    score = db.Column(db.Integer)
    content = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    activity = db.relationship('Activity', backref='evaluations')
    vehicle = db.relationship('Vehicle', backref='evaluations')
    evaluator = db.relationship('Evaluator', backref='evaluations')
    category_obj = db.relationship('Category', backref='evaluations', foreign_keys=[category_id])