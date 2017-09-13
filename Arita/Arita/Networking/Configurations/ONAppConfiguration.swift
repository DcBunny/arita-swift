//
//  ONAppConfiguration.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/9.
//  Copyright © 2017年 iot. All rights reserved.
//

import UIKit

class AppContext {
    
    //MARK: - life cycle
    static let sharedInstance = AppContext()
    
    private init() { }
    
    func getAPPVersion() -> String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
    
    func getOS() -> String {
        return UIDevice.current.systemName + " " + UIDevice.current.systemVersion
    }
    
    func getDevModel() -> String {
        return UIDevice.current.model
    }
    
    func getUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
