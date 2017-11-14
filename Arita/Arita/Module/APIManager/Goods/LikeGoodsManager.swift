//
//  LikeGoodsManager.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/**
 ** 添加收藏良品
 */
class LikeGoodsManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension LikeGoodsManager: ONAPIManager {
    func methodName() -> String {
        return "add_like_goods"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension LikeGoodsManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        // 这里检测接口参数是否正确，例如可以检查输入的电话号码是否是符合规范的，如果返回false，则不会进行实际的请求。
        //        if let errorMsg = ONCheckTool.checkPhoneNum(phone: data["username"] as? String) {
        //            self.errorMessage = errorMsg
        //            return false
        //        }
        
        //        if let errorMsg = ONCheckTool.checkPassword(password: data["password"] as? String) {
        //            self.errorMessage = errorMsg
        //            return false
        //        }
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}