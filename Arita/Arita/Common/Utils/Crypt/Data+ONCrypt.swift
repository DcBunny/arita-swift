//
//  Data+DTKit.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

// 对称加密扩展
extension Data {
    /// 对称加密
    ///
    /// - Parameters:
    ///   - operation: 加密 or 解密
    ///   - algorithm: 加解密方式
    ///   - key: 密钥
    ///   - iv: 初始化向量 cbc模式必填
    /// - Returns: 加解密结果
    func commonCrypto(_ operation: CCOperation, algorithm: CCAlgorithm, key: String, iv: String? = nil) -> Data? {
        guard [16,24,32].contains(key.lengthOfBytes(using: String.Encoding.utf8)) else {
            return nil
        }
        //有iv是cbc 没有则是ecb
        let options = (iv != nil) ? kCCOptionPKCS7Padding : kCCOptionPKCS7Padding
        
        // Prepare data parameters
        let keyData: Data! = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes: UnsafePointer<UInt8> = keyData.withUnsafeBytes { $0 }
        //let keyBytes         = keyData.bytes.bindMemory(to: Void.self, capacity: keyData.count)
        let keyLength        = key.lengthOfBytes(using: String.Encoding.utf8)
        let dataLength       = Int(self.count)
        let dataBytes: UnsafePointer<UInt8> = self.withUnsafeBytes { $0 }
        var bufferData       = Data(count: Int(dataLength) + requiredBlockSize(algorithm))
        let bufferPointer: UnsafeMutablePointer<UInt8> = bufferData.withUnsafeMutableBytes { $0 }
        let bufferLength     = size_t(bufferData.count)
        
        let ivData = iv?.data(using: .utf8)
        let ivBuffer: UnsafePointer<UInt8>? = (ivData == nil) ? nil : ivData!.withUnsafeBytes { $0 }
        var bytesDecrypted   = Int(0)
        
        // Perform operation
        let cryptStatus = CCCrypt(
            operation,                  // Operation
            algorithm,                  // Algorithm
            CCOptions(options),         // Options
            keyBytes,                   // key data
            keyLength,                  // key length
            ivBuffer,                   // IV buffer
            dataBytes,                  // input data
            dataLength,                 // input length
            bufferPointer,              // output buffer
            bufferLength,               // output buffer length
            &bytesDecrypted)            // output bytes decrypted real length
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.count = bytesDecrypted // Adjust buffer size to real bytes
            return bufferData as Data
        }
        return nil
    }
    /// AES Encrypt data, iv will be filled with zero if not specificed
    public func aesEncrypt(_ key:String,iv:String? = nil) -> Data? {
        return commonCrypto(UInt32(kCCEncrypt), algorithm: CCAlgorithm(kCCAlgorithmAES128), key: key, iv: iv)
    }
    /// AES Decrypt data ,iv will be filled with zero if not specificed
    public func aesDecrypt(_ key:String,iv:String? = nil)->Data?{
        return commonCrypto(UInt32(kCCDecrypt), algorithm: CCAlgorithm(kCCAlgorithmAES128), key: key, iv: iv)
    }
    /// DES Encrypt data, iv will be filled with zero if not specificed
    public func desEncrypt(_ key:String,iv:String? = nil) -> Data? {
        return commonCrypto(UInt32(kCCEncrypt), algorithm: CCAlgorithm(kCCAlgorithmDES), key: key, iv: iv)
    }
    /// DES Decrypt data ,iv will be filled with zero if not specificed
    public func desDecrypt(_ key:String,iv:String? = nil)->Data?{
        return commonCrypto(UInt32(kCCDecrypt), algorithm: CCAlgorithm(kCCAlgorithmDES), key: key, iv: iv)
    }
    /// 3DES Encrypt data, iv will be filled with zero if not specificed
    public func trippleDesEncrypt(_ key:String,iv:String? = nil) -> Data? {
        return commonCrypto(UInt32(kCCEncrypt), algorithm: CCAlgorithm(kCCAlgorithm3DES), key: key, iv: iv)
    }
    /// 3DES Decrypt data ,iv will be filled with zero if not specificed
    public func trippleDesDecrypt(_ key:String,iv:String? = nil)->Data?{
        return commonCrypto(UInt32(kCCDecrypt), algorithm: CCAlgorithm(kCCAlgorithm3DES), key: key, iv: iv)
    }
    
    // Returns the needed size for the IV to be used in the algorithm (0 if no IV is needed).
    func requiredIVSize(_ algorithm: CCAlgorithm) -> Int {
        switch (algorithm) {
            case UInt32(kCCAlgorithmDES): return kCCBlockSizeDES
            case UInt32(kCCAlgorithm3DES): return kCCBlockSize3DES
            case UInt32(kCCAlgorithmAES): return kCCBlockSizeAES128
            case UInt32(kCCAlgorithmAES128): return kCCBlockSizeAES128
            case UInt32(kCCAlgorithmRC2): return kCCBlockSizeRC2
            case UInt32(kCCAlgorithmCAST): return kCCBlockSizeCAST
            case UInt32(kCCAlgorithmBlowfish): return kCCBlockSizeBlowfish
            default: return 0
        }
    }
    
    func requiredKeySize(_ algorithm: CCAlgorithm) -> Int {
        switch (algorithm) {
            case UInt32(kCCAlgorithmDES): return kCCKeySizeDES
            case UInt32(kCCAlgorithm3DES): return kCCKeySize3DES
            case UInt32(kCCAlgorithmAES): return kCCKeySizeAES256
            case UInt32(kCCAlgorithmAES128): return kCCKeySizeAES128
            case UInt32(kCCAlgorithmRC2): return kCCKeySizeMaxRC2
            case UInt32(kCCAlgorithmCAST): return kCCKeySizeMaxCAST
            case UInt32(kCCAlgorithmBlowfish): return kCCKeySizeMaxBlowfish
            default: return 0
        }
    }
    
    func requiredBlockSize(_ algorithm: CCAlgorithm) -> Int {
        switch (algorithm) {
            case UInt32(kCCAlgorithmDES): return kCCBlockSizeDES
            case UInt32(kCCAlgorithm3DES): return kCCBlockSize3DES
            case UInt32(kCCAlgorithmAES): return kCCBlockSizeAES128
            case UInt32(kCCAlgorithmAES128): return kCCBlockSizeAES128
            case UInt32(kCCAlgorithmRC2): return kCCBlockSizeRC2
            case UInt32(kCCAlgorithmCAST): return kCCBlockSizeCAST
            case UInt32(kCCAlgorithmBlowfish): return kCCBlockSizeBlowfish
            default: return 0
        }
    }

}
