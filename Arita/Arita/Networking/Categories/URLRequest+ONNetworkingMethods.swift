//
//  URLRequest+ONNetworkingMethods.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/7.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

extension URLRequest {
    /**
     *  请求参数
     *
     */
    var requestParams: ONParamData? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.RequestParams) as? ONParamData
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.RequestParams, newValue , .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // MARK: - Accociate Instance Key
    private struct AssociaKey{
        static var RequestParams: String = "requestParams"
    }
}
