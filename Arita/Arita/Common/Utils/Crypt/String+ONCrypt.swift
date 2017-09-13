//
//  NSString+DTKit.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import UIKit
import ONFoundation

// hash方法
extension String {
    /// md5
    ///
    /// - Returns: the encoded string.
    func md5String() -> String? {
        return self.digestHex(.md5);
    }
    public var bytes:UnsafeRawPointer{
        let data = self.data(using: String.Encoding.utf8)!
        return (data as NSData).bytes
    }
    
}

// 对称加密扩展
extension String{
    /// Encrypt string in CBC mode, iv will be filled with Zero if not specificed
    public func aesEncrypt(_ key:String,iv:String? = nil) -> Data? {
        let data = self.data(using: String.Encoding.utf8)
        return data?.aesEncrypt(key, iv: iv)
    }
    /// Decrypt a base64 string in CBC mode, iv will be filled with Zero if not specificed
    public func aesDecryptFromBase64(_ key:String, iv:String? = nil) ->String? {
        let data = self.base64DecodedData()
        guard let raw_data = data?.aesDecrypt(key, iv: iv) else{
            return nil
        }
        return String(data: raw_data, encoding: String.Encoding.utf8)
    }
    public func des3Encrypt(_ key:String,iv:String? = nil) -> Data? {
        let data = self.data(using: String.Encoding.utf8)
        return data?.trippleDesEncrypt(key, iv: iv)
    }
    /// Decrypt a base64 string in CBC mode, iv will be filled with Zero if not specificed
    public func des3DecryptFromBase64(_ key:String, iv:String? = nil) ->String? {
        let data = self.base64DecodedData()
        guard let raw_data = data?.trippleDesDecrypt(key, iv: iv) else{
            return nil
        }
        return String(data: raw_data, encoding: String.Encoding.utf8)
    }
}

