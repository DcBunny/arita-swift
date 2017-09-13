//
//  UserCacheManager.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/// 用户缓存类
class UserCacheManager {
    
    /// 请求单例
    static let sharedInstance = UserCacheManager()
    
    /// 缓存工具类
    var syncCache: SyncHybridCache?
    
    /// 设置当前用户名，当用户初始化或者切换用户时调用此方法
    ///
    /// - Parameter username: 用户名，作为存储路径
    func setUserName(_ username: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true).first!
        let config = Config(
            // Your front cache type
            frontKind: .disk,
            // Your back cache type
            backKind: .disk,
            // Expiry date that will be applied by default for every added object
            // if it's not overridden in the add(key: object: expiry: completion:) method
            expiry: .never,
            // Maximum size of your cache storage
            maxSize: 0,
            // where to store the disk cache. If nil, it is placed in an automatically generated directory in Caches
            cacheDirectory: path
        )
        let cache = HybridCache(name: username, config: config)
        syncCache = SyncHybridCache.init(cache)
    }
    
}
