//
//  APIResultCheck.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 **返回内容检查
 */
struct APIResultCheck {
    public static func checkResult(_ manager: ONAPIBaseManager, isCorrectWithCallBackData  data: Data) -> Bool {
        let json = JSON(data: data)
        if json["code"].intValue != 0 {
            manager.errorMessage = json["msg"].stringValue
            return false
        }
        return true
    }
}
