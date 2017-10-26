//
//  CategoryModel.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 CategoryModel **分类**页数据模型
 */
struct CategoryModel {
    public var channelIcon: String
    public var channelName: String
    public var updateTime: String
    public var channelID: Int
    public var publicTime: String
    
    init(data channelInfo: JSON) {
        self.channelIcon = channelInfo["thumb_path"].stringValue
        self.channelName = channelInfo["channel_name"].stringValue
        self.updateTime = channelInfo["time_ago"].stringValue
        self.publicTime = channelInfo["publish_time"].stringValue
        self.channelID = channelInfo["ID"].intValue
    }
    
    //TODO: - 后期删除
    public static func initial() -> [CategoryModel] {
        return [CategoryModel(data: [
                    "thumb_path": Icon.class01,
                    "channel_name": "创意集结号",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class02,
                    "channel_name": "用镜头说话",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class03,
                    "channel_name": "汽车之间",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class04,
                    "channel_name": "建筑黑板报",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class05,
                    "channel_name": "我爱我家",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class06,
                    "channel_name": "生活在别处",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class07,
                    "channel_name": "手工爱好者",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class08,
                    "channel_name": "趣你的",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class09,
                    "channel_name": "看不懂的艺术",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class10,
                    "channel_name": "插画物语",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class11,
                    "channel_name": "设计奇葩但有用",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class12,
                    "channel_name": "烧脑高科技",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class13,
                    "channel_name": "时尚时尚最时尚",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class14,
                    "channel_name": "一起去旅行",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class15,
                    "channel_name": "小宠当家",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class16,
                    "channel_name": "生活圆桌",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class17,
                    "channel_name": "热炒冷知识",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ]),
                CategoryModel(data: [
                    "thumb_path": Icon.class18,
                    "channel_name": "吃很重要",
                    "time_ago": "10分钟前更新",
                    "publish_time": "2017-10-25 09:00:07",
                    "ID": 0
                    ])
        ]
    }
}
