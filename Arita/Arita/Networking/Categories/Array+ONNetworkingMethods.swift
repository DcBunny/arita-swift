//
//  Array+ONNetworkingMethods.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/9.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

extension Array where Element == String {
    
    /** 字母排序之后形成的参数字符串 */
    func ON_paramsString() -> String {
        var paramString = ""
        for obj in self.enumerated() {
            if paramString.characters.count == 0 {
                paramString.append(obj.element)
            } else {
                paramString.append("&\(obj.element)")
            }
        }
        
        return paramString
    }
}
