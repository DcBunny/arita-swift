//
//  ArticleHomeNormalCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleHomeNormalCell **文章**页一般样式cell试图
 */
class ArticleHomeNormalCell: UITableViewCell {

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
            ConstraintMaker.height.equalTo(titleLabel.snp.width).multipliedBy(2.0/3)
            ConstraintMaker.bottom.equalTo(contentLabel.snp.top).offset(-15)
        }
        
        contentLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(bodyView).offset(15)
            ConstraintMaker.right.equalTo(bodyView).offset(-15)
            ConstraintMaker.top.equalTo(picView.snp.bottom).offset(15)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-35)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: Color.hex55bde2!)
        }
    }
    
    public var picUrl = "" {
        didSet {
            picView.kf.setImage(with: URL(string: picUrl), placeholder: UIImage(named: Icon.placeHolderArticle32), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    public var contentText = "" {
        didSet {
            contentLabel.text = contentText
        }
    }
    
    public var color = Color.hex55bde2! {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: color)
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
extension ArticleHomeNormalCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hex55bde2!
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
}
