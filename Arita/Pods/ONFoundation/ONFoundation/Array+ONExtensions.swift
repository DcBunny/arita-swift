//
//  Data+DTKit.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation

// MARK: - Common
extension Array {
    /// json object encode
    ///
    /// - Returns: data
    public func dt_jsonValueEncoded() -> Data? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data
    }
    /// json object encode
    ///
    /// - Returns: encode string
    public func dt_jsonValueEncodedString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return String.init(data: data, encoding: .utf8)
        }
        return nil;
    }
}
