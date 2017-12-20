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
    /// 画颜色圆圈
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
    
    /// 首页跟帖用户评论样式
    public func convertCommentString() -> NSAttributedString? {
        let stringArr = self.split(separator: "+", maxSplits: 1).map(String.init)
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
        mutableAttStr.insert(commentAttribute, at: author.count)
        return mutableAttStr
    }
    
    /// 首页日期样式
    public func convertDateString() -> NSAttributedString? {
        let attributeString = NSAttributedString(string: self, attributes: [NSFontAttributeName: Font.size26D!,
                                                                            NSForegroundColorAttributeName: Color.hexea9120!,
                                                                            NSKernAttributeName: CGFloat(4.1),
                                                                            NSBaselineOffsetAttributeName: CGFloat(-2)])
        return attributeString
    }
    
    /// 首页主用户评论样式
    public func convertUserCommentString() -> NSAttributedString? {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 7
        let attributeString = NSAttributedString(string: self, attributes: [NSFontAttributeName: Font.size15!,
                                                                            NSForegroundColorAttributeName: Color.hex2a2a2a!,
                                                                            NSParagraphStyleAttributeName: paraStyle])
        return attributeString
    }
    
    /// 文章每日列表文章标题样式
    public func convertArticleTitleString() -> NSAttributedString? {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 8
        paraStyle.alignment = .center
        let attributeString = NSAttributedString(string: self, attributes: [NSFontAttributeName: Font.size20D!,
                                                                            NSForegroundColorAttributeName: Color.hexea9120!,
                                                                            NSParagraphStyleAttributeName: paraStyle])
        return attributeString
    }
    
    /// 文章每日列表文章内容样式
    public func convertArticleContentString() -> NSAttributedString? {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 5
        paraStyle.alignment = .left
        let attributeString = NSAttributedString(string: self, attributes: [NSFontAttributeName: Font.size13!,
                                                                            NSForegroundColorAttributeName: Color.hex4a4a4a!,
                                                                            NSParagraphStyleAttributeName: paraStyle])
        return attributeString
    }
    
    /// 文章每日列表日期转换
    public func convertStringToDateString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EEEE, MMM.dd"
        guard newDate != nil else { return nil }
        return dateFormatter.string(from: newDate!)
    }
    
    /// 文章每日列表日期转换
    public func convertStringToDayString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let newDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd"
        guard newDate != nil else { return nil }
        return dateFormatter.string(from: newDate!)
    }
    
    /// 我的模块关于我们/投稿合作内容样式
    public func convertMineContentString() -> NSAttributedString? {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 9
        paraStyle.alignment = .center
        
        let attributeString = NSAttributedString(string: self, attributes: [NSFontAttributeName: Font.size14!,
                                                                            NSForegroundColorAttributeName: Color.hex4a4a4a!,
                                                                            NSParagraphStyleAttributeName: paraStyle])
        return attributeString
    }
    
    /// 计算文本size
    ///
    /// - Parameters:
    ///   - attribute: 字体的attribute
    ///   - size: size
    ///   - lineBreakMode: lineBreakMode
    /// - Returns: 计算出的size
    public func sizeForString(attribute: [String: Any], in size: CGSize, lineBreakMode: NSLineBreakMode?) -> CGSize {
        var attr = attribute
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attr.updateValue(paragraphStyle, forKey: NSParagraphStyleAttributeName)
        }
        return ((self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attr, context: nil)).size
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
