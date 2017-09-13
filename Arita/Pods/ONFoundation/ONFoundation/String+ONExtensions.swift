//
//  NSString+DTKit.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Common
extension String {
    /// Character count
    public var length: Int {
        return self.characters.count
    }
    /// url encode
    ///
    /// - Returns: the encoded string.
    public func stringByURLEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    /// url decode
    ///
    /// - Returns: the decoded string.
    public func stringByURLDecode() -> String? {
        return self.removingPercentEncoding
    }
    
    /// 去除字符串首尾的空格
    ///
    /// - Returns: the trimmed string
    public func trim() -> String? {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    /// Checks if string is empty or consists only of whitespace and newline characters
    public var isBlank: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// base64 encode
    ///
    /// - Returns: base64 encoded string
    public func base64EncodedString() -> String? {
        let data = self.data(using: .utf8)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
    
    /// base64 decode
    ///
    /// - Returns: base64 decoded string
    public func base64DecodedString() -> String? {
        if let data = Data.init(base64Encoded: self) {
             return String.init(data: data, encoding: .utf8)
        }
        return nil;
    }
    
    /// base64 decode
    ///
    /// - Returns: base64 decode data
    public func base64DecodedData() -> Data? {
        let data = Data.init(base64Encoded: self)
        return data;
    }
    
    
    /// 计算文本size
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - size: size
    ///   - lineBreakMode: lineBreakMode
    /// - Returns: 计算出的size
    public func sizeForFont(_ font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode?) -> CGSize {
        var attrib: [String: AnyObject] = [NSFontAttributeName: font]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSParagraphStyleAttributeName)
        }
        return ((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attrib, context: nil)).size
    }
    
    /// Checks if String contains Emoji
    public func includesEmoji() -> Bool {
        for i in 0...length {
            let c: unichar = (self as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    internal func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advanced(by: nsRange.location)
        let to16 = from16.advanced(by: nsRange.length)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    /// Find matches of regular expression in string
    public func matchesForRegexInText(_ regex: String!) -> [String] {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        let results = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.length)) ?? []
        return results.map { self.substring(with: self.rangeFromNSRange($0.range)!) }
    }
    
    /// Array of UInt8
    public var arrayOfBytes:[UInt8] {
        let data = self.data(using: String.Encoding.utf8)!
        return data.arrayOfBytes()
    }
    public var bytes:UnsafeRawPointer{
        let data = self.data(using: String.Encoding.utf8)!
        return (data as NSData).bytes
    }
    
}
