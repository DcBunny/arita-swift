//
//  UserInfoAPIManager.swift
//  Arita
//
//  Created by 潘东 on 2017/11/1.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/// 获取用户基本信息
class UserInfoAPIManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension UserInfoAPIManager: ONAPIManager {
    func methodName() -> String {
        return "get_user_info"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension UserInfoAPIManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}
