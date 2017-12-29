//
//  ArticleCollectionViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/25.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleCollectionViewCell **文章列表**页主页的通用文章列表的cell
 */
class ArticleCollectionViewCell: UICollectionViewCell {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPageViews()
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(picView)
        bodyView.addSubview(titleLabel)
        bodyView.addSubview(contentLabel)
        bodyView.addSubview(authorLogoView)
        bodyView.addSubview(authorNameLabel)
        bodyView.addSubview(timeLabel)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        picView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bodyView)
            make.height.equalTo(bodyView.snp.width)
            make.bottom.equalTo(titleLabel.snp.top).offset(-35)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(picView.snp.bottom).offset(35)
            make.left.equalTo(bodyView).offset(15)
            make.right.equalTo(bodyView).offset(-15)
            make.bottom.equalTo(contentLabel.snp.top).offset(-35)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.left.right.equalTo(titleLabel)
        }
        
        authorLogoView.snp.makeConstraints { (make) in
            make.left.equalTo(bodyView).offset(15)
            make.bottom.equalTo(bodyView).offset(-10)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalTo(authorNameLabel.snp.left).offset(-5)
        }
        
        authorNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(authorLogoView.snp.right).offset(5)
            make.height.equalTo(authorLogoView)
            make.centerY.equalTo(authorLogoView)
            make.right.equalTo(timeLabel.snp.left).offset(-10)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(titleLabel)
            make.height.equalTo(authorNameLabel)
            make.centerY.equalTo(authorNameLabel)
            make.left.equalTo(authorNameLabel.snp.right).offset(10)
        }
    }
    
    // MARK: - Public Attributes
    public var articleModel: ArticleModel = ArticleModel.initial {
        didSet {
            picView.kf.setImage(with: URL(string: articleModel.articlePic), placeholder: UIImage(named: Icon.placeHolderArticle11), options: [.transition(.fade(1.5))], progressBlock: nil, completionHandler: nil)
            titleLabel.attributedText = articleModel.articleTitle.convertArticleTitleString()
            contentLabel.attributedText = articleModel.articleContent.convertArticleContentString()
            authorLogoView.kf.setImage(with: URL(string: articleModel.authorLogo), placeholder: UIImage(named: ""), options: [.transition(.fade(1.5))], progressBlock: nil, completionHandler: nil)
            authorNameLabel.text = articleModel.authorName
            timeLabel.text = articleModel.articleDate
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _picView: UIImageView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _contentLabel: UILabel?
    fileprivate var _authorLogoView: UIImageView?
    fileprivate var _authorNameLabel: UILabel?
    fileprivate var _timeLabel: UILabel?
}

// MARK: - Getters and Setters
extension ArticleCollectionViewCell {
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
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.numberOfLines = 2
            _titleLabel?.lineBreakMode = .byTruncatingTail
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.textAlignment = .left
            if UIDevice.current.isIphoneX() {
                _contentLabel?.numberOfLines = 6
            } else {
                _contentLabel?.numberOfLines = 3
            }
            _contentLabel?.lineBreakMode = .byTruncatingTail
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
    
    fileprivate var authorLogoView: UIImageView {
        if _authorLogoView == nil {
            _authorLogoView = UIImageView()
            _authorLogoView?.layer.cornerRadius = 12
            _authorLogoView?.layer.masksToBounds = true
            
            return _authorLogoView!
        }
        
        return _authorLogoView!
    }
    
    fileprivate var authorNameLabel: UILabel {
        if _authorNameLabel == nil {
            _authorNameLabel = UILabel()
            _authorNameLabel?.font = Font.size11
            _authorNameLabel?.textColor = Color.hex919191
            _authorNameLabel?.textAlignment = .left
            
            return _authorNameLabel!
        }
        
        return _authorNameLabel!
    }
    
    fileprivate var timeLabel: UILabel {
        if _timeLabel == nil {
            _timeLabel = UILabel()
            _timeLabel?.font = Font.size10
            _timeLabel?.textColor = Color.hex919191
            _timeLabel?.textAlignment = .right
            
            return _timeLabel!
        }
        
        return _timeLabel!
    }
}

