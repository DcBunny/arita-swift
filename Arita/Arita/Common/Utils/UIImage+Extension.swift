//
//  UIImage+Extension.swift
//  OneAPP
//
//  Created by 潘东 on 2017/7/12.
//  Copyright © 2017年 iot. All rights reserved.
//

import UIKit

/**
 UIImage的扩展
 */
public extension UIImage {
    ///传入base64的字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
    public static func getImage(from base64String: String) -> UIImage? {
        var str = base64String
        
        // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
        if str.hasPrefix("data:image") {
            guard let newBase64String = str.characters.split(separator: ",").map(String.init).last else {
                return nil
            }
            str = newBase64String
        }
        // 2、将处理好的base64String代码转换成Data
        guard let imgNSData = Data(base64Encoded: str, options: Data.Base64DecodingOptions()) else {
            return nil
        }
        // 3、将Data的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData as Data) else {
            return nil
        }
        return codeImage
    }
}
