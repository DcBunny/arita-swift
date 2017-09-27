//
//  ONService.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

// 所有ONService的派生类都要符合这个protocol
protocol ONServiceProtocol: class {
    // Required
    func offlineApiBaseUrl() -> String
    func onlineApiBaseUrl() -> String
    
    func offlineApiVersion() -> String
    func onlineApiVersion() -> String
    
    func offlineApiCommonPath() -> String
    func onlineApiCommonPath() -> String
    
    // Optional
    /// 线上环境或者线下环境的标志位。
    ///
    /// 通过设置*ONNetworkingConfiguration.plist*文件中得isOnline属性来设置环境，YES为线上环境，NO为线下环境，plist文件默认为NO
    func isOnline() -> Bool
    /// 为某些Service需要拼凑额外字段到URL处
    func extraParmas() -> ONParamData
    
    /// 为某些Service需要拼凑额外的HTTPToken，如accessToken
    func extraHttpHeadParmasWithMethodName(_ method: String) -> ONParamData
    
    /// 提供拦截器集中处理Service错误问题，比如token失效要抛通知等
    func shouldCallBackByFailedOnCallingAPI(_ response: ONURLResponse?) -> Bool
}

extension ONServiceProtocol {
    func isOnline() -> Bool {
        return ONNetworkingConfigurationManager.sharedInstance.serviceIsOnline
    }
    
    func extraParmas() -> ONParamData {
        return [:] as ONParamData
    }
    
    func extraHttpHeadParmasWithMethodName(_ method: String) -> ONParamData {
        return [:] as ONParamData
    }
    
    func shouldCallBackByFailedOnCallingAPI(_ response: ONURLResponse?) -> Bool {
        return true
    }
}

class ONService {
    
    weak var child: ONServiceProtocol?

    required init() {
        if let aChild = self as? ONServiceProtocol {
            child = aChild
        } else {
           assertionFailure("ONService的派生类必须遵守协议ONServiceProtocol")
        }
    }

    //MARK: - getters and setters
    var apiBaseUrl: String {
        get {
            return child!.isOnline() ? child!.onlineApiBaseUrl() : child!.offlineApiBaseUrl()
        }
    }
    
    var apiVersion: String {
        get {
            return child!.isOnline() ? child!.onlineApiVersion() : child!.offlineApiVersion()
        }
    }
    
    var apiCommonPath: String {
        get {
            return child!.isOnline() ? child!.onlineApiCommonPath() : child!.offlineApiCommonPath()
        }
    }
    
    func urlGeneratingRuleByMethodName(_ methodName: String) -> String {
        var urlString: String
        if apiVersion.characters.count != 0 {
            urlString = apiBaseUrl + "/" + apiCommonPath + "/" + apiVersion + "/" + methodName
        } else {
            urlString = apiBaseUrl + "/" + apiCommonPath + "/" + methodName
        }
        
        return urlString
    }
}
