//
//  ONCache.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/8.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

class ONCache {
    /// 单例
    static let sharedInstance = ONCache()
    
    private var oncache: NSCache<NSString, ONCacheObject>?
    
    private init() {
        oncache = NSCache()
        oncache!.countLimit = ONNetworkingConfigurationManager.sharedInstance.cacheCountLimit
    }
    
    public func saveCacheWithData(_ cachedData: Data, serviceIdentifier: String, methodName: String, requestParams: ONParamData?) {
        saveCacheWithData(cachedData, key: keyWithServiceIdentifier(serviceIdentifier, methodName: methodName, requestParams: requestParams))
    }
    
    public func fetchCachedDataWithServiceIdentifier(_ serviceId: String, methodName: String, requestParams: ONParamData?) -> Data? {
        return fetchCachedDataWithKey(keyWithServiceIdentifier(serviceId, methodName: methodName, requestParams: requestParams))
    }
    
    public func deleteCacheWithServiceId(_ serviceId: String, methodName: String, requestParams: ONParamData?) {
        deleteCacheWithKey(keyWithServiceIdentifier(serviceId, methodName: methodName, requestParams: requestParams))
    }
    
    public func keyWithServiceIdentifier(_ serviceId: String, methodName: String, requestParams: ONParamData?) -> String {
        // 有些请求可能没有参数，比如post或者get无参数
        guard requestParams != nil else { return serviceId + methodName }
        return (serviceId + methodName + requestParams!.ON_urlParamString())
    }
    
    public func fetchCachedDataWithKey(_ key: String) -> Data? {
        let cachedObject = oncache!.object(forKey: NSString(string: key))
        if cachedObject == nil || cachedObject!.isOutdated() || cachedObject!.isEmpty() {
            return nil
        } else {
            return cachedObject!.content
        }
    }
    
    public func saveCacheWithData(_ cachedData: Data, key: String) {
        var cachedObject = oncache!.object(forKey: NSString(string: key))
        if cachedObject == nil {
            cachedObject = ONCacheObject(withContent: cachedData)
        }
        
        cachedObject!.updateContent(cachedData)
        oncache!.setObject(cachedObject!, forKey: NSString(string: key))
    }
    
    public func deleteCacheWithKey(_ key: String) {
        oncache!.removeObject(forKey: NSString(string: key))
    }
    
    public func clean() {
        oncache!.removeAllObjects()
    }
}
