//
//  NetwokConst.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/22.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Alamofire

/// 网络监听常亮
let kNetworkStatusChanged = "kNetworkStatusChanged"
let kNetworkStatus = "kNetworkStatus"
let kNetworkUnavailable = "kNetworkUnavailable"
let kNetworkAvailabel = "kNetworkAvailabel"
let manager = NetworkReachabilityManager(host: "www.baidu.com")
var isNetworkAvalaible = true
