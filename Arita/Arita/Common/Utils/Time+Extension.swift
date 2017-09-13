//
//  Time+Extension.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

let greetingWord = ["早上好", "中午好", "下午好", "晚上好"]

struct Time {
    /**
     设备首页打招呼用语
     
     - parameter nickname: 需要打招呼的用户昵称
     - Returns: 完整的招呼语句
     */
    public static func greeting(with nickname: String?) -> String {
        let nowTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let dateString = formatter.string(from: nowTime)
        let time = Int(dateString)!
        
        var showNickname = ""
        if nickname != nil {
            showNickname = "，\(nickname!)"
        }
        
        if time >= 6 && time < 12 {
            return greetingWord[0] + showNickname + " : )"
        } else if time >= 12 && time < 13 {
            return greetingWord[1] + showNickname + " : )"
        } else if time >= 13 && time < 19 {
            return greetingWord[2] + showNickname + " : )"
        } else {
            return greetingWord[3] + showNickname + " : )"
        }
    }
}
