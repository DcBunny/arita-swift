//
//  TataCollectionViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/9.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 TataCollectionViewCell **文章列表**页主页的塔塔报的cell
 */
class TataCollectionViewCell: UICollectionViewCell {
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
        bodyView.addSubview(dateLabel)
        bodyView.addSubview(picView)
        bodyView.addSubview(titleLabel)
        bodyView.addSubview(contentLabel)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bodyView).offset(15)
            make.top.equalTo(bodyView).offset(30)
            make.right.equalTo(bodyView).offset(-15)
            make.bottom.equalTo(picView.snp.top).offset(-30)
        }
        
        picView.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(30)
            make.left.right.equalTo(bodyView)
            make.height.equalTo(bodyView.snp.width).multipliedBy(2.0 / 3)
            make.bottom.equalTo(titleLabel.snp.top).offset(-35)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(picView.snp.bottom).offset(35)
            make.left.right.equalTo(dateLabel)
            make.bottom.equalTo(contentLabel.snp.top).offset(-35)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    // MARK: - Public Attributes
    public var tataArticleModel: ArticleModel = ArticleModel.initial {
        didSet {
            dateLabel.attributedText = tataArticleModel.articleDate.convertStringToDateString()?.convertDateString()
            picView.kf.setImage(with: URL(string: tataArticleModel.articlePic), placeholder: UIImage(named: Icon.placeHolderArticle32), options: nil, progressBlock: nil, completionHandler: nil)
            titleLabel.attributedText = tataArticleModel.articleTitle.convertArticleTitleString()
            contentLabel.attributedText = tataArticleModel.articleContent.convertArticleContentString()
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _dateLabel: UILabel?
    fileprivate var _picView: UIImageView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _contentLabel: UILabel?
}

// MARK: - Getters and Setters
extension TataCollectionViewCell {
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
    
    fileprivate var dateLabel: UILabel {
        if _dateLabel == nil {
            _dateLabel = UILabel()
            _dateLabel?.textAlignment = .center
            
            return _dateLabel!
        }
        
        return _dateLabel!
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
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.textAlignment = .left
            _contentLabel?.numberOfLines = 5
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
}
