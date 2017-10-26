//
//  ArticleModel.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 ArticleModel **文章列表**页主页的塔塔报(包括其他类型文章)的数据模型
 */
struct ArticleModel {
    public var articleDate: String
    public var articlePic: String
    public var articleTitle: String
    public var articleContent: String
    public var timeStamp: String
    public var authorName: String
    public var authorLogo: String
    
    init(data articleInfo: JSON) {
        self.articlePic = articleInfo["thumb_path"].stringValue
        self.articleTitle = articleInfo["title"].stringValue
        self.articleContent = articleInfo["description"].stringValue
        let start = articleInfo["publish_time"].stringValue.startIndex
        let end = articleInfo["publish_time"].stringValue.index(start, offsetBy: 10)
        self.articleDate = articleInfo["publish_time"].stringValue.substring(with: start..<end)
        self.timeStamp = articleInfo["publish_time"].stringValue
        self.authorName = articleInfo["name"].stringValue
        self.authorLogo = articleInfo["logo_path"].stringValue
    }
    
    static var initial: ArticleModel {
        return ArticleModel(data: [
            "thumb_path": "",
            "title": "加载中",
            "description": "文章正在加载中，稍候请享用",
            "publish_time": "2017-10-24 17:30:10",
            "logo_path": "",
            "name": "Wiser arise",
            ])
    }
}

struct ArticleViewModel {
    private var _articles: [ArticleModel]
    private var _totalCount: Int
    var articles: [ArticleModel] { return _articles }
    var totalCount: Int { return _totalCount }
    
    init(data: Any?) {
        _articles = [ArticleModel]()
        _totalCount = 0
        guard data != nil else { return }
        let json = JSON(data: data as! Data)
        let items = json["articleArr"].arrayValue
        _totalCount = json["totalNum"].intValue
        for item in items {
            let article = ArticleModel(data: item)
            _articles.append(article)
        }
    }
}

struct NormalArticleViewModel {
    private var _articles: [ArticleModel]
    private var _totalCount: Int
    var articles: [ArticleModel] { return _articles }
    var totalCount: Int { return _totalCount }
    
    init(data: Any?) {
        _articles = [ArticleModel]()
        _totalCount = 0
        guard data != nil else { return }
        let json = JSON(data: data as! Data)
        let items = json["articleArrNew"].arrayValue
        _totalCount = json["articlesNum"].intValue
        for item in items {
            let article = ArticleModel(data: item)
            _articles.append(article)
        }
    }
}
