//
//  ArticleHomeNormalCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import Kingfisher

/**
 ArticleHomeTataCell **文章**页塔塔报和一般样式cell试图
 */
class ArticleHomeTataCell: UITableViewCell {

    // MARK: - Init Methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addCellViews()
        layoutCellViews()
        setCellViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addCellViews() {
        addSubview(titleLabel)
        addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(picView)
        bodyView.addSubview(contentLabel)
        picView.addSubview(jggView)
    }
    
    private func layoutCellViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(self).offset(15)
            ConstraintMaker.left.equalTo(self).offset(6)
            ConstraintMaker.right.equalTo(self).offset(-6)
            ConstraintMaker.height.equalTo(44)
            ConstraintMaker.bottom.equalTo(shadowView.snp.top)
        }
        
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(titleLabel)
            ConstraintMaker.top.equalTo(titleLabel.snp.bottom)
            ConstraintMaker.bottom.equalTo(self)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        picView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.top.equalTo(bodyView)
            ConstraintMaker.height.equalTo(titleLabel.snp.width)
            ConstraintMaker.bottom.equalTo(contentLabel.snp.top).offset(-15)
        }
        
        contentLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(bodyView).offset(15)
            ConstraintMaker.right.equalTo(bodyView).offset(-15)
            ConstraintMaker.top.equalTo(picView.snp.bottom).offset(15)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-35)
        }
        
        jggView.snp.makeConstraints { (make) in
            make.edges.equalTo(picView)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: Color.hexea9120!)
        }
    }
    
    public var picUrl = "" {
        didSet {
            picView.kf.setImage(with: URL(string: picUrl), placeholder: UIImage(named: Icon.placeHolderArticle11), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    public var contentText = "" {
        didSet {
            contentLabel.text = contentText
        }
    }
    
    public var channelColor = Color.hexea9120 {
        didSet {
            guard channelColor != nil else { return }
            titleLabel.textColor = channelColor!
            titleLabel.attributedText = titleText.withColorCircle(color: channelColor!)
        }
    }
    
    public var isJGG: Bool = false {
        didSet {
            jggView.isHidden = !isJGG
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _picView: UIImageView?
    fileprivate var _contentLabel: UILabel?
    fileprivate var _jggView: JGGView?
}

// MARK: - Getters and Setters
extension ArticleHomeTataCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hexea9120!
            _titleLabel?.textAlignment = .left
            _titleLabel?.font = Font.size13
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            _shadowView?.layer.shadowOpacity = 1.0
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var picView: UIImageView {
        if _picView == nil {
            _picView = UIImageView()
            _picView?.contentMode = .scaleToFill
            
            return _picView!
        }
        
        return _picView!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.textColor = Color.hex2a2a2a!
            _contentLabel?.textAlignment = .left
            _contentLabel?.font = Font.size16
            _contentLabel?.numberOfLines = 2
            _contentLabel?.lineBreakMode = .byTruncatingTail
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
    
    fileprivate var jggView: JGGView {
        if _jggView == nil {
            _jggView = JGGView()
            _jggView?.isHidden = true
            
            return _jggView!
        }
        
        return _jggView!
    }
}

/// 九宫格蒙层
class JGGView: UIView {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setLineWidth(1 / Size.screenScale)
            ctx.setStrokeColor(UIColor.white.cgColor)
            for i in 0..<2 {
                let startPoint = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + CGFloat(i + 1) * (self.frame.size.height - 2 / Size.screenScale) / 3)
                let endPoint = CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + CGFloat(i + 1) * (self.frame.size.height - 2 / Size.screenScale) / 3)
                let line = [startPoint, endPoint]
                ctx.strokeLineSegments(between: line)
            }
            
            for i in 0..<2 {
                let startPoint = CGPoint(x: self.frame.origin.x + CGFloat(i + 1) * (self.frame.size.width - 2 / Size.screenScale) / 3, y: self.frame.origin.y)
                let endPoint = CGPoint(x: self.frame.origin.x + CGFloat(i + 1) * (self.frame.size.width - 2 / Size.screenScale) / 3, y: self.frame.origin.y + self.frame.height)
                let line = [startPoint, endPoint]
                ctx.strokeLineSegments(between: line)
            }
        }
    }
}
