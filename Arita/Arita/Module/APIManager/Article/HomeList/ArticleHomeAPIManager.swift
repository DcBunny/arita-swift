//
//  ArticleHomeAPIManager.swift
//  Arita
//
//  Created by 潘东 on 2017/10/23.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ** 获取首页文章数据
 */
class ArticleHomeAPIManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
    
    //MARK: - 翻页功能需要实现的方法
    override func reformParams(_ params: ONParamData) -> ONParamData {
        var apiParams = params
        apiParams["timestamp"] = timeStamp
        return apiParams
    }
    
    public func loadNextPage() {
        if self.isLoading {
            return
        }
        
        if currentNum < totalNum {
            _ = self.loadData()
        } else {
            self.cancelAllRequests()
            self.errorType = .noMoreData
            self.delegate?.managerCallAPIDidFailed(manager: self)
        }
    }
    
    var timeStamp = "0"
    var totalNum = 0
    var currentNum = 0
}

extension ArticleHomeAPIManager: ONAPIManager {
    func methodName() -> String {
        return "get_indexdata"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension ArticleHomeAPIManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}
