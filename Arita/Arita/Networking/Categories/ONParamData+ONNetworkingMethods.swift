//
//  ONParamData+ONNetworkingMethods.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/9.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    /** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
    func ON_urlParamString() -> String {
        let sortedArray = self.ON_transformedUrlParamsArray()
        return sortedArray.ON_paramsString()
    }
    
    /** 转义参数 */
    func ON_transformedUrlParamsArray() -> Array<String> {
        var result = Array<String>()
        
        var stringValue = ""
        for (_, obj) in self.enumerated() {
            stringValue = ON_transformToString(obj.value)
            stringValue = CFURLCreateStringByAddingPercentEscapes(nil, stringValue as CFString, nil, "!*'();:@&;=+$,/?%#[]" as CFString, CFStringBuiltInEncodings.UTF8.rawValue) as String
            
            if stringValue.characters.count > 0 {
                result.append("\(obj.key)=\(stringValue)")
            }
        }

        let sortedArray = result.sorted()
        
        return sortedArray
    }
    
    /** ONParamData转化为String */
    func ON_transformToString(_ value: Any) -> String {
        var stringResult = ""
        
        if value is ONParamData {
            for (_, obj) in (value as! ONParamData).enumerated() {
                stringResult = ON_transformToString(obj.value)
                
                stringResult = CFURLCreateStringByAddingPercentEscapes(nil, stringResult as CFString, nil, "!*'();:@&;=+$,/?%#[]" as CFString, CFStringBuiltInEncodings.UTF8.rawValue) as String
                
                var result = Array<String>()
                if stringResult.characters.count > 0 {
                    result.append("\(obj.key)=\(stringResult)")
                    stringResult = result.sorted().ON_paramsString()
                }
            }
        } else if (value is String) {
            stringResult = value as! String
        } else {
            stringResult = "\(value)"
        }
            
        return stringResult
    }
}
