//
//  LatestGoodsAlbumManager.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/23.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/**
 ** 获取最新的良品专辑
 */
class LatestGoodsAlbumManager: ONAPIBaseManager {
    override init() {
        super.init()
        
        self.validator = self
    }
}

extension LatestGoodsAlbumManager: ONAPIManager {
    func methodName() -> String {
        return "album_list_fresh"
    }
    
    func serviceType() -> String {
        return kArita
    }
    
    func requestType() -> ONAPIManagerRequestType {
        return .get
    }
}

extension LatestGoodsAlbumManager: ONAPIManagerValidator {
    func manager(_ manager: ONAPIBaseManager, isCorrectWithParamsData data: ONParamData) -> Bool {
        return true
    }
    
    func manager(_ manager: ONAPIBaseManager, isCorrectWithCallBackData data: Data) -> Bool {
        // 这里检测返回的数据是否是正确的，比如判断返回码是否正确。
        return true
    }
}
