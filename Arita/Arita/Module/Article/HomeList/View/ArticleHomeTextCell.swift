//
//  ArticleHomeTextCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleHomeTextCell **文章**页纯文本cell试图
 */
class ArticleHomeTextCell: UITableViewCell {

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
        bodyView.addSubview(userIcon)
        bodyView.addSubview(userName)
        bodyView.addSubview(userComment)
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
        
        userIcon.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.top.equalTo(bodyView).offset(15)
            ConstraintMaker.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        userName.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(userIcon.snp.right).offset(5)
            ConstraintMaker.centerY.equalTo(userIcon)
            ConstraintMaker.right.equalTo(userComment)
        }
        
        userComment.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(userIcon)
            ConstraintMaker.right.equalTo(bodyView).offset(-15)
            ConstraintMaker.top.equalTo(userIcon.snp.bottom).offset(8)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-30)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: Color.hex40bf2c!)
        }
    }
    
    public var username = "" {
        didSet {
            userName.text = username
        }
    }
    
    public var usercomment = "" {
        didSet {
            userComment.attributedText = usercomment.convertUserCommentString()
        }
    }
    
    public var color = Color.hex40bf2c! {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: color)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _userIcon: UIImageView?
    fileprivate var _userName: UILabel?
    fileprivate var _userComment: UILabel?
}

// MARK: - Getters and Setters
extension ArticleHomeTextCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hex40bf2c
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
    
    fileprivate var userIcon: UIImageView {
        if _userIcon == nil {
            _userIcon = UIImageView()
            _userIcon?.image = UIImage(named: Icon.userIcon)
            
            return _userIcon!
        }
        
        return _userIcon!
    }
    
    fileprivate var userName: UILabel {
        if _userName == nil {
            _userName = UILabel()
            _userName?.textColor = Color.hex919191
            _userName?.textAlignment = .left
            _userName?.font = Font.size13
            
            return _userName!
        }
        
        return _userName!
    }
    
    fileprivate var userComment: UILabel {
        if _userComment == nil {
            _userComment = UILabel()
            _userComment?.textAlignment = .left
            _userComment?.numberOfLines = 0
            
            return _userComment!
        }
        
        return _userComment!
    }
}
