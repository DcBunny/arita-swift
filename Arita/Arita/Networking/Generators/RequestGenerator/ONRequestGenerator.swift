//
//  ONRequestGenerator.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/7.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Alamofire

class ONRequestGenerator {
    //MARK: - life cycle
    static let sharedInstance = ONRequestGenerator()
    
    private init() {}
    
    //MARK: - public func
    func generateGETRequestWithServiceId(_ serviceId: String, requestParams: ONParamData, methodName: String) -> URLRequest {
        return generateRequestWithServiceId(serviceId, requestParams: requestParams, methodName: methodName, requestWithMethod: .get)
    }
    
    func generatePOSTRequestWithServiceId(_ serviceId: String, requestParams: ONParamData, methodName: String) -> URLRequest {
        return generateRequestWithServiceId(serviceId, requestParams: requestParams, methodName: methodName, requestWithMethod: .post)
    }
    
    func generatePUTRequestWithServiceId(_ serviceId: String, requestParams: ONParamData, methodName: String) -> URLRequest {
        return generateRequestWithServiceId(serviceId, requestParams: requestParams, methodName: methodName, requestWithMethod: .post)
    }
    
    func generateDELETERequestWithServiceId(_ serviceId: String, requestParams: ONParamData, methodName: String) -> URLRequest {
        return generateRequestWithServiceId(serviceId, requestParams: requestParams, methodName: methodName, requestWithMethod: .delete)
    }
    
    func generateRequestWithServiceId(_ serviceId: String, requestParams: ONParamData, methodName: String, requestWithMethod method: HTTPMethod) -> URLRequest {
        let service = ONServiceFactory.sharedInstance.serviceWithId(serviceId)
        let urlSrtring = service!.urlGeneratingRuleByMethodName(methodName)
        let totalRequestParams = totalRequestParamsByService(service!, requestParams: requestParams)
        
        let url = URL(string: urlSrtring)!
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: ONNetworkingConfigurationManager.sharedInstance.apiNetworkingTimeoutSeconds)
        urlRequest.httpMethod = method.rawValue
        let encoding = Alamofire.URLEncoding.default
        do {
            try urlRequest = encoding.encode(urlRequest, with: totalRequestParams)
        } catch {
            assertionFailure("request请求设置参数失败，请检查原因")
        }
        
        if (method != .get) && (ONNetworkingConfigurationManager.sharedInstance.shouldSetParamsInHTTPBodyButGET) {
            assert(JSONSerialization.isValidJSONObject(requestParams), "参数无法转换为JSON，请检查参数格式")
           
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestParams, options: [])
            } catch {
                assertionFailure("参数可以转换为JSON格式，但转化失败，请检查原因")
            }
        }
        
        if service!.child?.extraHttpHeadParmasWithMethodName(methodName).count != 0 {
            for extraHttpHeadParam in service!.child!.extraHttpHeadParmasWithMethodName(methodName) {
                urlRequest.setValue(extraHttpHeadParam.value as? String, forHTTPHeaderField: extraHttpHeadParam.key)
            }
        }

        urlRequest.requestParams = totalRequestParams
        
        return urlRequest
    }
    
    //MARK: - private func
    /// 根据Service拼接额外参数
    /// - parameter service: 需要拼接参数的Service
    /// - parameter requestParams: 原始的参数
    /// - returns: 拼接额外参数后的完整参数
    func totalRequestParamsByService(_ service: ONService, requestParams: ONParamData) -> ONParamData {
        var totalRequestParams = requestParams
        
        guard service.child!.extraParmas().count != 0 else {
            return totalRequestParams
        }
        for extraParam in service.child!.extraParmas() {
            totalRequestParams[extraParam.key] = extraParam.value
        }
        
        return totalRequestParams
    }
}
