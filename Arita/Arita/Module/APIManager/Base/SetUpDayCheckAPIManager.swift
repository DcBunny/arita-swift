//
//  SetUpDayCheckAPIManager.swift
//  Arita
//
//  Created by 潘东 on 2017/11/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/// 获取启动页日签图片
class SetUpDayCheckAPIManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension SetUpDayCheckAPIManager: ONAPIManager {
    func methodName() -> String {
        return "get_article_thumbimg"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension SetUpDayCheckAPIManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}

