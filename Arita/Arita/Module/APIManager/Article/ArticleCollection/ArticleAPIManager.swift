//
//  ArticleAPIManager.swift
//  Arita
//
//  Created by 潘东 on 2017/10/25.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 *  获取某栏目n条文章数据(包括日签)
 */
class ArticleAPIManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension ArticleAPIManager: ONAPIManager {
    func methodName() -> String {
        return "get_articles_num"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension ArticleAPIManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}

