//
//  Color+ON.swift
//  SwiftDemo
//
//  Created by houwenjie on 2017/5/16.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import UIKit

// MARK: - common
extension UIColor {
    /// 根据颜色生成图片
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 图片
    public func imageWithColorAndSize(_ size: CGSize, isCircle: Bool) -> UIImage {
        var rect: CGRect!
        
        if (size.width == 0 || size.height == 0) {
            rect = CGRect(x: 0, y: 0, width: 200, height: 50)
        } else {
            rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        if isCircle {
            context!.addArc(center: CGPoint(x: size.width / 2, y: size.width / 2), radius: size.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
            context?.fillPath()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        } else {
            context!.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        }
    }
}

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

// MARK: - hex color
extension UIColor {
    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
     - parameter hexString: The hex string, with or without the hash character.
     - returns: A color with the given hex string.
     */
    public convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    fileprivate convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }
    
    fileprivate convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }
    
    /**
     Create non-autoreleased color with in the given hex string and alpha.
     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        
        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }
        
        switch hex.characters.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    public convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}
