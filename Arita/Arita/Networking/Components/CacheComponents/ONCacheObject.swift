//
//  ONCacheObject.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/9.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

class ONCacheObject {
    private(set) var content: Data
    private var lastUpdateTime: Date
    
    init(withContent content: Data) {
        self.content = content
        lastUpdateTime = Date(timeIntervalSinceNow: TimeInterval(0))
    }
    
    func updateContent(_ content: Data) {
        self.content = content
    }
    
    func isEmpty() -> Bool {
        return content.count == 0
    }
    
    func isOutdated() -> Bool {
        let timeInterval = Date().timeIntervalSince(lastUpdateTime)
        return timeInterval > ONNetworkingConfigurationManager.sharedInstance.cacheOutdateTimeSeconds
    }
}
