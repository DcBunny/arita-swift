//
//  Data+DTKit.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

// MARK: - Common
extension Data {
    /// json object decode
    ///
    /// - Returns: json object
    public func dt_jsonValueDecoded() -> Any? {
        let JSON = try? JSONSerialization.jsonObject(
            with: self,
            options: JSONSerialization.ReadingOptions.allowFragments)
        return JSON;
    }
    
    /// Array of UInt8
    public func arrayOfBytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }

}
