//
//  UIString+Extension.swift
//  Arita
//
//  Created by 潘东 on 2017/9/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 **String的扩展
 */
extension String {
    public func withColorCircle(color: UIColor) -> NSAttributedString {
        let attach = NSTextAttachment()
        attach.image = color.imageWithColorAndSize(CGSize(width: 8, height: 8), isCircle: true)
        attach.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let circleAttribute = NSAttributedString(attachment: attach)
        
        let attachClear = NSTextAttachment()
        attachClear.image = UIColor.clear.imageWithColorAndSize(CGSize(width: 8, height: 8), isCircle: false)
        attachClear.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let clearAttribute = NSAttributedString(attachment: attachClear)
        
        let attributes = NSMutableAttributedString(string: self)
        attributes.insert(circleAttribute, at: 0)
        attributes.insert(clearAttribute, at: 1)
        return attributes
    }
    
    public func convertCommentString() -> NSAttributedString? {
        let stringArr = self.characters.split(separator: "+", maxSplits: 1).map(String.init)
        var author = ""
        var comment = ""
        if stringArr.count == 1 {
            author = stringArr[0]
            comment = " "
        } else if stringArr.count == 0 {
            return nil
        } else {
            author = stringArr[0]
            comment = stringArr[1]
        }
        let authorAttribute = NSAttributedString(string: author, attributes: [NSFontAttributeName: Font.size14!,
                                                                              NSForegroundColorAttributeName: Color.hex919191!])
        let commentAttribute = NSAttributedString(string: comment, attributes: [NSFontAttributeName: Font.size14!,
                                                                              NSForegroundColorAttributeName: Color.hex4a4a4a!])
        let mutableAttStr = NSMutableAttributedString(attributedString: authorAttribute)
        mutableAttStr.insert(commentAttribute, at: author.characters.count)
        return mutableAttStr
    }
}

/**
 **NSMutableAttributedString的扩展
 */
extension NSMutableAttributedString {
    public func withColorCircle(color: UIColor, with size: CGSize) -> NSAttributedString {
        let attach = NSTextAttachment()
        attach.image = color.imageWithColorAndSize(size, isCircle: true)
        attach.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let circleAttribute = NSAttributedString(attachment: attach)
        
        let attachClear = NSTextAttachment()
        attachClear.image = UIColor.clear.imageWithColorAndSize(CGSize(width: 8, height: 8), isCircle: false)
        attachClear.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let clearAttribute = NSAttributedString(attachment: attachClear)
        
        let attributes = NSMutableAttributedString(attributedString: self)
        attributes.insert(circleAttribute, at: 0)
        attributes.insert(clearAttribute, at: 1)
        return attributes
    }
}
