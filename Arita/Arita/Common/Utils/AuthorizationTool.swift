//
//  AuthorizationTool.swift
//  Arita
//
//  Created by 潘东 on 2017/10/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import Photos
import AssetsLibrary
import AVFoundation

/// 权限状态
enum AuthStatus {
    /// 已获得权限
    case determined
    /// 未决定
    case notDetermined
    /// 未获得权限
    case canNotUse
}

/**
 AuthorizationTool 手机权限工具
 */
class AuthorizationTool {
    /// 是否可以使用相册
    static func canUsePhotos() -> AuthStatus {
        if #available(iOS 8.0, *) {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .restricted || status == .denied {
                return .canNotUse
            } else if status == .notDetermined {
                return .notDetermined
            }
            
            return .determined
        } else {
            let auth = ALAssetsLibrary.authorizationStatus()
            if auth == .restricted || auth == .denied {
                return .canNotUse
            } else if auth == .notDetermined {
                return .notDetermined
            }
            
            return .determined
        }
    }
    
    /// 请求相册授权
    static func requestPhotoAuthorization() -> Bool {
        var result = false
        PHPhotoLibrary.requestAuthorization{ status in
            if status == .denied {
                result = false
            } else {
                result = true
            }
        }
        
        return result
    }
    
    /// 是否可以使用相机
    static func canUseCamera() -> AuthStatus {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == .restricted || status == .denied {
            return .canNotUse
        } else if status == .notDetermined {
            return .notDetermined
        }
        
        return .determined
    }
    
}
