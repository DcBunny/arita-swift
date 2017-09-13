//
//  ONLogger.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/7.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

class ONLogger {
    /// 单例
    static let sharedInstance = ONLogger()
    private init() { }
    
    class func logDebugInfoWithRequest(_ request: URLRequest, apiName: String, service: ONService?, requestParams: ONParamData, httpMethod: String) {
        #if DEBUG
            var logString = "\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"
            
            logString.append("API Name: \t\t\(apiName.ON_defaultValue())\n")
            logString.append("Method: \t\t\(httpMethod.ON_defaultValue())\n")
            logString.append("Version: \t\t\(String(describing: service?.apiVersion.ON_defaultValue()))\n")
            logString.append("Service: \t\t\(String(describing: service.self))\n")
            logString.append("Status: \t\t\t offline\n")
            if requestParams.count == 0 {
                logString.append("Params: \nN/A")
            } else {
                logString.append("Params: \n\(requestParams)")
            }
            
            logString.ON_appendURLRequest(request)
            
            logString.append("\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n")
            
            log.debug(logString)
        #endif
    }
    
    class func logDebugInfoWithResponse(_ response: HTTPURLResponse, responseString: String, request: URLRequest, error: Error?) {
        #if DEBUG
            var logString = "\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"
            
            logString.append("Status: \t\(response.statusCode)\t(\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))\n\n")
            logString.append("Content: \n\t\(responseString)\n\n")
            if (error != nil) {
                logString.append("Error Localized Description:\t\t\t\t\t\t\t\(error!.localizedDescription)\n")
            }
            
            logString.append("\n---------------  Related Request Content  --------------\n")
            
            logString.ON_appendURLRequest(request)
            
            logString.append("\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n")
            
            log.debug(logString)
        #endif
    }
    
    class func logDebugInfoWithCachedResponse(_ response: ONURLResponse, methodName: String, serviceIdentifier service: ONService?) {
        #if DEBUG
            var logString = "\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"
            
            logString.append("API Name: \t\t\(methodName.ON_defaultValue())\n")
            logString.append("Version: \t\t\(String(describing: service?.apiVersion.ON_defaultValue()))\n")
            logString.append("Method Name: \t\t\(methodName))\n")
            logString.append("Service: \t\t\(String(describing: service.self))\n")
            logString.append("Params: \n\(String(describing: response.requestParams))\n\n")
            logString.append("Content:\n\t\(String(describing: response.contentString))\n\n")
            
            logString.append("\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n")
            
            log.debug(logString)
        #endif
    }
}
