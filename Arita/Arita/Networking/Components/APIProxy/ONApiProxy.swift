//
//  ONApiProxy.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/7.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Alamofire

typealias ONApiCallback = (ONURLResponse) -> ()

class ONApiProxy {
    
    var dispathcTable: [Int: URLSessionTask]
    
    //MARK: - life cycle
    static let sharedInstance = ONApiProxy()
    
    private init() {
        dispathcTable = [Int: URLSessionTask]()
    }
    
    //MARK: - public methods
    func callGETWithParams(params: ONParamData, serviceId: String, methodName: String, success: @escaping ONApiCallback, fail: @escaping ONApiCallback) -> Int {
        let request = ONRequestGenerator.sharedInstance.generateGETRequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request: request, success: success, fail: fail)
        
        return requestId
    }
    
    func callPOSTWithParams(params: ONParamData, serviceId: String, methodName: String, success: @escaping ONApiCallback, fail: @escaping ONApiCallback) -> Int {
        let request = ONRequestGenerator.sharedInstance.generatePOSTRequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request: request, success: success, fail: fail)
        
        return requestId
    }
    
    func callPUTWithParams(params: ONParamData, serviceId: String, methodName: String, success: @escaping ONApiCallback, fail: @escaping ONApiCallback) -> Int {
        let request = ONRequestGenerator.sharedInstance.generatePUTRequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request: request, success: success, fail: fail)
        
        return requestId
    }
    
    func callDELETEWithParams(params: ONParamData, serviceId: String, methodName: String, success: @escaping ONApiCallback, fail: @escaping ONApiCallback) -> Int {
        let request = ONRequestGenerator.sharedInstance.generateDELETERequestWithServiceId(serviceId, requestParams: params, methodName: methodName)
        let requestId = callApiWithRequest(request: request, success: success, fail: fail)
        
        return requestId
    }
    
    func cancelRequestWithRequestId(_ requestId: Int) {
        let requestOperation = dispathcTable[requestId]
        requestOperation?.cancel()
        dispathcTable.removeValue(forKey: requestId)
    }
    
    func cancelRequestWithRequestIdList(_ requestIdList: [Int]) {
        for requestId in requestIdList {
            cancelRequestWithRequestId(requestId)
        }
    }
    
    //MARK: - private methods
    /** 这个函数存在的意义在于，如果将来要把Alamofire换掉，只要修改这个函数的实现即可。 */
    private func callApiWithRequest(request: URLRequest, success: @escaping ONApiCallback, fail: @escaping ONApiCallback) -> Int {
        log.debug("\n==================================\n\nRequest Start: \n\n \(String(describing: request.url))\n\n==================================")
        
        // 跑到这里的block的时候，就已经是主线程了。
        var task: URLSessionTask? = nil
        task = Alamofire.request(request).responseJSON { response in
            let id = task!.taskIdentifier
            self.dispathcTable.removeValue(forKey: id)
            let httpResponse = response.response ?? HTTPURLResponse()
            let responseData = response.data
            let responseString = String(data: responseData!, encoding: String.Encoding.utf8)
            
            switch response.result {
            case .success:
                // 检查http response是否成立。
                ONLogger.logDebugInfoWithResponse(httpResponse, responseString: responseString!, request: request, error: nil)
                let urlResponse = ONURLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, status: ONURLResponseStatus.success)
                success(urlResponse)
                
            case .failure(let error):
                ONLogger.logDebugInfoWithResponse(httpResponse, responseString: responseString!, request: request, error: error)
                let urlResponse = ONURLResponse(withResponseString: responseString!, requestId: id, request: request, responseData: responseData!, error: error as NSError)
                fail(urlResponse)
            }
            }.task
        
        let requestId = task!.taskIdentifier
        
        return requestId
    }
}
