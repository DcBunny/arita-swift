//
//  ArtcileHomeModel.swift
//  Arita
//
//  Created by 潘东 on 2017/10/23.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 首页需要显示的cell类型
enum CellType {
    /// 九宫格类型
    case jgg
    /// 塔塔报类型
    case tata
    /// 纯文本类型
    case allText
    /// 普通类型
    case normal
}

/**
 * 首页数据模型
 */
struct ArticleHomeModel {
    var cellType: CellType
    var titleText: String
    var picUrl: String
    var contentText: String
    var userName: String
    var sectionDate: String
    var timeStamp: String
    var channelId: Int
    var categoryId: Int
    var channelName: String
    var id: Int // 实际上是详情里的文章ID，需要后续做对比
    
    init(data articleInfo: JSON) {
        if articleInfo["show_jiu"] != JSON.null && articleInfo["show_jiu"] == 1 {
            self.cellType = .jgg
        } else if articleInfo["show_jiu"] == JSON.null {
            self.cellType = .tata
        } else if articleInfo["category_ID"].intValue == 7 {
            // categoryID = 7 代表纯文本
            self.cellType = .allText
        } else {
            self.cellType = .normal
        }
        self.userName = articleInfo["partnerName"].stringValue
        self.titleText = articleInfo["time_ago"].stringValue + " | " + articleInfo["channel_name"].stringValue
        self.contentText = articleInfo["title"].stringValue
        self.picUrl =  articleInfo["thumb_path"].stringValue
        let start = articleInfo["publish_time"].stringValue.startIndex
        let end = articleInfo["publish_time"].stringValue.index(start, offsetBy: 10)
        self.sectionDate = articleInfo["publish_time"].stringValue.substring(with: start..<end)
        self.timeStamp = articleInfo["publish_time"].stringValue
        self.channelId = articleInfo["channel_ID"].intValue
        self.categoryId = articleInfo["category_ID"].intValue
        self.channelName = articleInfo["channel_name"].stringValue
        self.id = articleInfo["ID"].intValue
    }
    
    static var initial: ArticleHomeModel {
        return ArticleHomeModel(data: [
            "thumb_path": "",
            "title": "加载中",
            "description": "正在加载中",
            "publish_time": "2017-10-24 17:30:10",
            "partnerName": "阿里塔",
            "time_ago": "6小时之前",
            "channel_name": "阿里塔",
            "channel_ID": 0,
            "category_ID": 0
            ])
    }
}

struct ArticleHomeViewModel {
    private var _articles: [[ArticleHomeModel]]
    private var _totalCount: Int
    private var _preData: [[ArticleHomeModel]]? = nil
    var articles: [[ArticleHomeModel]] { return _articles }
    var totalCount: Int { return _totalCount }
    
    init(data: Any?, with preData: [[ArticleHomeModel]]?) {
        _articles = [[ArticleHomeModel]]()
        _totalCount = 0
        _preData = preData
        guard data != nil else { return }
        let json = JSON(data: data as! Data)
        let items = json["articleArr"].arrayValue
        _totalCount = json["totalNum"].intValue
        var articleArray = [ArticleHomeModel]()
        for item in items {
            let article = ArticleHomeModel(data: item)
            articleArray.append(article)
        }
        /** 第一版算法，如果接口正常，可以直接用。
        if _preData != nil {
            let preArticle = _preData!.flatMap { $0 }
            articleArray = preArticle + articleArray
        }

        var sectionDateArray: [String] = []
        for article in articleArray {
            if !sectionDateArray.contains(article.sectionDate) {
                sectionDateArray.append(article.sectionDate)
            }
        }

        for i in 0..<sectionDateArray.count {
            var array = [ArticleHomeModel]()
            for article in articleArray {
                if article.sectionDate == sectionDateArray[i] {
                    array.append(article)
                }
            }
            _articles.append(array)
        }
         */
        // 第二版算法，为了解决目前时间线混乱的问题，后期可删除，也可以直接用
        if _preData != nil && _preData!.count != 0 {
            // 如果之前有数据，也就是加载更多
            var lastArticleArray = preData!.last
            var shouldRemoveArticleIndex: [Int] = []
            if lastArticleArray != nil && lastArticleArray!.count != 0 {
                for (index, article) in articleArray.enumerated() {
                    if article.sectionDate == lastArticleArray!.first!.sectionDate {
                        // 如果新拉下来的数据中有之前数据中最后一组文章组的，就直接加到最后一组文章组，然后在新拉下来的数据组中去掉此数据
                        lastArticleArray!.append(article)
                        shouldRemoveArticleIndex.append(index)
                    }
                }
                // 替换最后一个文章组，然后添加到需要返回的数组最开始
                _preData!.removeLast()
                _preData!.append(lastArticleArray!)
                _articles = _preData!
                // 新拉下来的数据组中去掉此数据
                let sortedRemovedArticleIndex = shouldRemoveArticleIndex.sorted(by: >)
                for index in sortedRemovedArticleIndex {
                    articleArray.remove(at: index)
                }
                
                // 剩下的新数组重新分组
                var sectionDateArray: [String] = []
                for article in articleArray {
                    if !sectionDateArray.contains(article.sectionDate) {
                        sectionDateArray.append(article.sectionDate)
                    }
                }
                
                for i in 0..<sectionDateArray.count {
                    var array = [ArticleHomeModel]()
                    for article in articleArray {
                        if article.sectionDate == sectionDateArray[i] {
                            array.append(article)
                        }
                    }
                    // 继续添加新增的文章组
                    _articles.append(array)
                }
            }
        } else {
            // 之前没有数据，也就是第一次加载
            var sectionDateArray: [String] = []
            guard articleArray.count != 0 else {
                _articles = []
                return
            }
            _articles.append([articleArray.first!])
            articleArray.removeFirst()
            for article in articleArray {
                if !sectionDateArray.contains(article.sectionDate) {
                    sectionDateArray.append(article.sectionDate)
                }
            }
            
            for i in 0..<sectionDateArray.count {
                var array = [ArticleHomeModel]()
                for article in articleArray {
                    if article.sectionDate == sectionDateArray[i] {
                        array.append(article)
                    }
                }
                _articles.append(array)
            }
        }
    }
}
