//
//  ONNetworkingConfigurationManager.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Alamofire

let isOnline = "isOnline"
let shouldCached = "shouldCache"

class ONNetworkingConfigurationManager {
    
    /// 单例
    static let sharedInstance = ONNetworkingConfigurationManager()
    private init() {
        serviceIsOnline = getValueFromPlist(isOnline)
        shouldCache = getValueFromPlist(shouldCached)
    }
    
    /// 网络连接是否正常
    public var isReachable = NetworkReachabilityManager(host: "www.baidu.com")?.isReachable
    /// 是否是线上环境
    public var serviceIsOnline: Bool!
    /// 是否需要缓存，默认为False
    public var shouldCache: Bool = false
    /// API请求超时时间，默认时间为20s
    public var apiNetworkingTimeoutSeconds: TimeInterval = Double(20.0)
    /// 缓存超时时间，默认时间为300s
    public var cacheOutdateTimeSeconds: TimeInterval = Double(300)
    /// 缓存大小，默认为1000个对象(这里可能是1000张图片对象或者别的对象的数量)
    public var cacheCountLimit: Int = 1000
    
    /// 默认值为false，当值为true时，HTTP请求除了GET请求，其他的请求都会将参数放到HTTPBody中，如下所示
    /// request.HTTPBody = JSONSerialization.data(withJSONObject: requestParams, options: JSONSerialization.WritingOptions.prettyPrinted)
    public var shouldSetParamsInHTTPBodyButGET: Bool = false
}

extension ONNetworkingConfigurationManager {
    fileprivate func getValueFromPlist(_ key: String) -> Bool {
        let fileManager = FileManager.default
        let networkingConfigurationPath = Bundle.main.path(forResource: "ONNetworkingConfiguration", ofType: ".plist")
        let isNetworkingConfigurationExisted = fileManager.fileExists(atPath: networkingConfigurationPath!)
        
        guard isNetworkingConfigurationExisted else {
            assertionFailure("ONNetworkingConfiguration.plist文件不存在，请创建文件，并且增加属性值(布尔值)isOnline用以表征是否为线上环境")
            return false
        }
        
        let myDict = NSDictionary(contentsOfFile: networkingConfigurationPath!)
        guard let result = myDict!.value(forKey: key) as? Bool else {
            if key == isOnline {
                assertionFailure("ONNetworkingConfiguration.plist文件不存在属性值(布尔值)isOnline，请添加属性值isOnline")
            }
            
            return false
        }
        
        return result
    }
}
