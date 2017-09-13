//
//  ONURLResponse.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/6.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

enum ONURLResponseStatus: Error {
    case success    // 作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的CTAPIBaseManager来决定。
    case failure(ONURLResponseFailStatus)
}

enum ONURLResponseFailStatus: Error {
    case timeout   /// 超时
    case nonetwork /// 默认除了超时以外的错误都是无网络错误。
}

class ONURLResponse: NSObject {
    
    let status: ONURLResponseStatus
    let contentString: String?
    
    let requestId: Int
    let request: URLRequest?
    let responseData: Data
    let error: NSError?
    var requestParams: ONParamData?
    
    let isCached: Bool
    
    //Mark: - life cycle
    init(withResponseString responseString: String, requestId: Int, request: URLRequest, responseData: Data, status: ONURLResponseStatus) {
        self.contentString = responseString
        self.status = status
        self.requestId = requestId
        self.responseData = responseData
        self.request = request
        self.isCached = false
        self.error = nil
        self.requestParams = request.requestParams
        
        super.init()
    }
    
    init(withResponseString responseString: String, requestId: Int, request: URLRequest, responseData: Data, error: NSError) {
        self.contentString = responseString
        self.requestId = requestId
        self.responseData = responseData
        self.request = request
        self.isCached = false
        self.error = error
        self.requestParams = request.requestParams
        
        if error.code == NSURLErrorTimedOut {
            self.status = ONURLResponseStatus.failure(.timeout)
        } else {
            self.status = ONURLResponseStatus.failure(.nonetwork)
        }
        
        super.init()
    }
    
    // 使用initWithData的response，它的isCache是YES，上面两个函数生成的response的isCache是NO
    // 主要用于缓存，由于使用参数和API名字拼成字符串来保存缓存。
    init(withData data: Data) {
        self.contentString = String(data: data, encoding: .utf8)
        self.requestId = 0
        self.responseData = data
        self.request = nil
        self.isCached = true
        self.error = nil
        self.requestParams = nil
        self.status = ONURLResponseStatus.success
        
        super.init()
    }
}
