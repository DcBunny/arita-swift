//
//  Utilities.swift
//  OneAPP
//
//  Created by houwenjie on 2017/7/18.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation


internal func getParameterDictionary(_ parameterString: String) -> Dictionary<String, String> {
    let array = parameterString.components(separatedBy: ",")
    var parameterDictionary = Dictionary<String, String>()
    for string in array {
        let paramArray = string.components(separatedBy: "=")
        if paramArray.count == 2 {
            parameterDictionary[paramArray[0]] = paramArray[1]
        }
    }
    return parameterDictionary
}
