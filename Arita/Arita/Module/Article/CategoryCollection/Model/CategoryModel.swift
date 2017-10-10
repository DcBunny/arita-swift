//
//  CategoryModel.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/**
 CategoryModel **分类**页数据模型
 */
struct CategoryModel {
    public var categoryIcon: String?
    public var categoryName: String?
    public var updateTime: String?
    
    //TODO: - 后期删除
    public static func demoModel() -> [CategoryModel] {
        return [CategoryModel(categoryIcon: Icon.class01, categoryName: "创意集结号", updateTime: "10分钟前更新"),
                CategoryModel(categoryIcon: Icon.class02, categoryName: "用镜头说话", updateTime: "10分钟前更新"),
                CategoryModel(categoryIcon: Icon.class03, categoryName: "汽车之间", updateTime: "20分钟前更新"),
                CategoryModel(categoryIcon: Icon.class04, categoryName: "建筑黑板报", updateTime: "20分钟前更新"),
                CategoryModel(categoryIcon: Icon.class05, categoryName: "我爱我家", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class06, categoryName: "生活在别处", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class07, categoryName: "手工爱好者", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class08, categoryName: "趣你的", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class09, categoryName: "看不懂的艺术", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class10, categoryName: "插画物语", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class11, categoryName: "设计奇葩但有用", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class12, categoryName: "烧脑高科技", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class13, categoryName: "时尚时尚最时尚", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class14, categoryName: "一起去旅行", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class15, categoryName: "小宠当家", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class16, categoryName: "生活圆桌", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class17, categoryName: "热炒冷知识", updateTime: "昨天更新"),
                CategoryModel(categoryIcon: Icon.class18, categoryName: "吃很重要", updateTime: "昨天更新")
        ]
    }
    
    public static func initial() -> CategoryModel {
        return CategoryModel(categoryIcon: nil, categoryName: nil, updateTime: nil)
    }
}
