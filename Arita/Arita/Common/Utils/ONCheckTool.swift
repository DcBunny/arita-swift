//
//  ONCheckTool.swift
//  OneAPP
//
//  Created by houwenjie on 2017/6/27.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

class ONCheckTool {
    static func checkPhoneNum(phone: String?) -> String? {
        if phone == nil || phone?.characters.count == 0 {
            return "请输入手机号码"
        }
        
        if phone! =~ phoneRegex {
            return nil
        } else {
            return "手机号码有误，请重新输入"
        }
    }
    
    static func checkEmail(email: String?) -> String? {
        
        if email == nil || email?.characters.count == 0 {
            return "请输入邮箱"
        }
        
        if email! =~ mailRegex {
            return nil
        } else {
            return "邮箱有误，请重新输入"
        }
        
    }
    
    static func checkPassword(password: String?) -> String? {
        
        if (password?.characters.count)! < 8 {
            return "密码长度至少为8位"
        }
        
        do {
            let numRegularExpression = try NSRegularExpression.init(pattern: "[0-9]", options:.caseInsensitive)
            let numCount = numRegularExpression.numberOfMatches(in: password!, options: .reportProgress, range: NSMakeRange(0, (password?.characters.count)!))
            
            let letterRegularExpression = try NSRegularExpression(pattern: "[A-Za-z]", options:.caseInsensitive)
            let letterCount = letterRegularExpression.numberOfMatches(in: password!, options: .reportProgress, range: NSMakeRange(0, (password?.characters.count)!))
            
            if (numCount == (password?.characters.count)! || letterCount == (password?.characters.count)!) {
                return "密码不能为纯数字/字母"
            }
            
        } catch {
            print("")
        }
        
        return nil
    }
}
