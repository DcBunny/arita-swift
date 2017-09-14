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
 ArticleHomeNormalCell **文章**页塔塔报cell试图
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
    }
    
    private func layoutCellViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(self).offset(20)
            ConstraintMaker.left.equalTo(self).offset(6)
            ConstraintMaker.right.equalTo(self).offset(-6)
            ConstraintMaker.height.equalTo(44)
            ConstraintMaker.bottom.equalTo(bodyView.snp.top)
        }
        
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(titleLabel)
            ConstraintMaker.top.equalTo(titleLabel.snp.bottom)
            ConstraintMaker.bottom.equalTo(self).offset(-16)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        picView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.top.equalTo(bodyView)
            ConstraintMaker.height.equalTo(picView.snp.width)
            ConstraintMaker.bottom.equalTo(contentLabel.snp.top).offset(-16)
        }
        
        contentLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(bodyView).offset(16)
            ConstraintMaker.right.equalTo(bodyView).offset(-16)
            ConstraintMaker.top.equalTo(picView.snp.bottom).offset(16)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-48)
        }
    }
    
    private func setCellViews() {
        backgroundColor = Color.hexf5f5f5
        selectionStyle = .none
    }
    
    // MARK: - Private Methods
    private func generateAttributeText(by text: String) -> NSAttributedString {
        let attach = NSTextAttachment()
        attach.image = Color.hexe57e33?.imageWithColorAndSize(CGSize(width: 8, height: 8), isCircle: true)
        attach.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let circleAttribute = NSAttributedString(attachment: attach)
        
        let attachClear = NSTextAttachment()
        attachClear.image = UIColor.clear.imageWithColorAndSize(CGSize(width: 8, height: 8), isCircle: false)
        attachClear.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
        let clearAttribute = NSAttributedString(attachment: attachClear)
        
        let attributes = NSMutableAttributedString(string: text)
        attributes.insert(circleAttribute, at: 0)
        attributes.insert(clearAttribute, at: 1)
        return attributes
    }
    
    
    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.attributedText = generateAttributeText(by: titleText)
        }
    }
    
    public var picUrl = "" {
        didSet {
            picView.kf.setImage(with: URL(string: picUrl))
        }
    }
    
    public var contentText = "" {
        didSet {
            contentLabel.text = contentText
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _bodyView: UIView?
    fileprivate var _shadowView: UIView?
    fileprivate var _picView: UIImageView?
    fileprivate var _contentLabel: UILabel?
}

// MARK: - Getters and Setters
extension ArticleHomeTataCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hexe57e33
            _titleLabel?.textAlignment = .left
            _titleLabel?.font = Font.size14
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(4)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowOpacity = 0.5
            
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
            _contentLabel?.textColor = Color.hex2f2f2f
            _contentLabel?.textAlignment = .left
            _contentLabel?.font = Font.size18
            _contentLabel?.numberOfLines = 0
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
}
