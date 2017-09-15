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
        bodyView.addSubview(seperator)
        bodyView.addSubview(commentIcon)
        bodyView.addSubview(commentDotOne)
        bodyView.addSubview(commentDotTwo)
        bodyView.addSubview(commentListOne)
        bodyView.addSubview(commentListTwo)
    }
    
    private func layoutCellViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(self)
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
        
        userIcon.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.top.equalTo(bodyView).offset(16)
            ConstraintMaker.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        userName.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(userIcon.snp.right).offset(4)
            ConstraintMaker.centerY.equalTo(userIcon)
            ConstraintMaker.right.equalTo(userComment)
        }
        
        userComment.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(userIcon)
            ConstraintMaker.right.equalTo(bodyView).offset(-16)
            ConstraintMaker.top.equalTo(userIcon.snp.bottom).offset(8)
        }
        
        seperator.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(userComment)
            ConstraintMaker.top.equalTo(userComment.snp.bottom).offset(16)
            ConstraintMaker.height.equalTo(1 / Size.screenScale)
        }
        
        commentIcon.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.size.equalTo(userIcon)
            ConstraintMaker.top.equalTo(seperator.snp.bottom).offset(24)
        }
        
        commentDotOne.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(commentIcon.snp.right).offset(8)
            ConstraintMaker.centerY.equalTo(commentIcon)
            ConstraintMaker.size.equalTo(CGSize(width: 4, height: 4))
            ConstraintMaker.right.equalTo(commentListOne.snp.left).offset(-8)
        }
        
        commentListOne.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(commentDotOne.snp.right).offset(8)
            ConstraintMaker.centerY.equalTo(commentIcon)
            ConstraintMaker.right.equalTo(userComment)
        }
        
        commentDotTwo.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(commentDotOne.snp.bottom).offset(32)
            ConstraintMaker.left.right.size.equalTo(commentDotOne)
        }
        
        commentListTwo.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(commentListOne)
            ConstraintMaker.top.equalTo(commentListOne.snp.bottom).offset(16)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-32)
        }
    }
    
    private func setCellViews() {
        backgroundColor = Color.hexf5f5f5
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
            userComment.text = usercomment
        }
    }
    
    public var color = Color.hex40bf2c! {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: color)
        }
    }
    
    public var commentOne = "" {
        didSet {
            commentListOne.attributedText = commentOne.convertCommentString()
        }
    }
    
    public var commentTwo = "" {
        didSet {
            commentListTwo.attributedText = commentTwo.convertCommentString()
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _userIcon: UIImageView?
    fileprivate var _userName: UILabel?
    fileprivate var _userComment: UILabel?
    fileprivate var _seperator: UIView?
    fileprivate var _commentIcon: UIImageView?
    fileprivate var _commentDotOne: UIView?
    fileprivate var _commentDotTwo: UIView?
    fileprivate var _commentListOne: UILabel?
    fileprivate var _commentListTwo: UILabel?
}

// MARK: - Getters and Setters
extension ArticleHomeTextCell {
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
    
    fileprivate var userIcon: UIImageView {
        if _userIcon == nil {
            _userIcon = UIImageView()
            _userIcon?.image = UIImage(named: Icon.comment)
            
            return _userIcon!
        }
        
        return _userIcon!
    }
    
    fileprivate var userName: UILabel {
        if _userName == nil {
            _userName = UILabel()
            _userName?.textColor = Color.hex919191
            _userName?.textAlignment = .left
            _userName?.font = Font.size14
            
            return _userName!
        }
        
        return _userName!
    }
    
    fileprivate var userComment: UILabel {
        if _userComment == nil {
            _userComment = UILabel()
            _userComment?.textColor = Color.hex2a2a2a
            _userComment?.textAlignment = .left
            _userComment?.font = Font.size16
            _userComment?.numberOfLines = 0
            
            return _userComment!
        }
        
        return _userComment!
    }
    
    fileprivate var seperator: UIView {
        if _seperator == nil {
            _seperator = UIView()
            _seperator?.backgroundColor = Color.hexe4e4e4
            
            return _seperator!
        }
        
        return _seperator!
    }
    
    fileprivate var commentIcon: UIImageView {
        if _commentIcon == nil {
            _commentIcon = UIImageView()
            _commentIcon?.image = UIImage(named: Icon.comment)
            
            return _commentIcon!
        }
        
        return _commentIcon!
    }
    
    fileprivate var commentDotOne: UIView {
        if _commentDotOne == nil {
            _commentDotOne = UIView()
            _commentDotOne?.backgroundColor = Color.hex919191!
            _commentDotOne?.layer.masksToBounds = true
            _commentDotOne?.layer.cornerRadius = CGFloat(2)
            
            return _commentDotOne!
        }
        
        return _commentDotOne!
    }
    
    fileprivate var commentDotTwo: UIView {
        if _commentDotTwo == nil {
            _commentDotTwo = UIView()
            _commentDotTwo?.backgroundColor = Color.hex919191!
            _commentDotTwo?.layer.masksToBounds = true
            _commentDotTwo?.layer.cornerRadius = CGFloat(2)
            
            return _commentDotTwo!
        }
        
        return _commentDotTwo!
    }
    
    fileprivate var commentListOne: UILabel {
        if _commentListOne == nil {
            _commentListOne = UILabel()
            _commentListOne?.textAlignment = .left
            _commentListOne?.numberOfLines = 0
            _commentListOne?.font = Font.size14
            
            return _commentListOne!
        }
        
        return _commentListOne!
    }
    
    fileprivate var commentListTwo: UILabel {
        if _commentListTwo == nil {
            _commentListTwo = UILabel()
            _commentListTwo?.textAlignment = .left
            _commentListTwo?.numberOfLines = 0
            _commentListTwo?.font = Font.size14
            
            return _commentListTwo!
        }
        
        return _commentListTwo!
    }

}
