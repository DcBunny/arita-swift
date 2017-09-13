//
//  OneApp2.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/9.
//  Copyright © 2017年 iot. All rights reserved.
//

import UIKit

class Arita: ONService, ONServiceProtocol {
    func offlineApiBaseUrl() -> String {
        return API.offlineApiBaseUrl
    }
    
    func onlineApiBaseUrl() -> String {
        return API.onlineApiBaseUrl
    }
    
    func offlineApiCommonPath() -> String {
        return API.offlineApiCommonPath
    }
    
    func onlineApiCommonPath() -> String {
        return API.onlineApiCommonPath
    }
    
    func offlineApiVersion() -> String {
        return API.offlineApiVersion
    }
    
    func onlineApiVersion() -> String {
        return API.onlineApiVersion
    }
    
    func extraHttpHeadParmasWithMethodName(_ method: String) -> ONParamData {
        let appContext = AppContext.sharedInstance
        var iotextString: String?
        let iotext = [
            "app_version": appContext.getAPPVersion(),
            "os": appContext.getOS(),
            "model": appContext.getDevModel(),
            "uuid": appContext.getUUID()
        ]
        do {
            let iotextData = try JSONSerialization.data(withJSONObject: iotext, options: JSONSerialization.WritingOptions(rawValue: 0))
            iotextString = String(data: iotextData, encoding: String.Encoding.utf8)
        } catch { }
        
        let token = UserManager.sharedInstance.currentUser?.authInfo?.token
        return ["iotext": iotextString ?? "",
                "token": token ?? ""]
    }
}
