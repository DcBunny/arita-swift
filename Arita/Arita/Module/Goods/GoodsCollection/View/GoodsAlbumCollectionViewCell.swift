//
//  GoodsAlbumCollectionViewCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsAlbumCollectionViewCell: UICollectionViewCell {
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
        bodyView.addSubview(titleLabel)
        bodyView.addSubview(picView)
        bodyView.addSubview(contentLabel)
        bodyView.addSubview(numLabel)
        bodyView.addSubview(dateLabel)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bodyView).offset(15)
            make.top.equalTo(bodyView).offset(25)
            make.right.equalTo(bodyView).offset(-15)
            make.bottom.equalTo(picView.snp.top).offset(-25)
        }
        
        picView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.right.equalTo(bodyView)
            make.height.equalTo(bodyView.snp.width).multipliedBy(2.0 / 3)
            make.bottom.equalTo(contentLabel.snp.top).offset(-50)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(picView.snp.bottom).offset(50)
            make.left.equalTo(picView).offset(15)
            make.right.equalTo(picView).offset(-15)
        }
        
        numLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bodyView).offset(15)
            make.bottom.equalTo(bodyView).offset(-15)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalTo(bodyView).offset(-15)
            make.bottom.equalTo(numLabel)
        }
    }
    
    // MARK: - Public Attributes
    public var tataArticleModel: ArticleModel = ArticleModel.initial {
        didSet {
            titleLabel.attributedText = tataArticleModel.articleDate.convertArticleTitleString()
            picView.kf.setImage(with: URL(string: tataArticleModel.articlePic), placeholder: UIImage(named: Icon.placeHolderArticle32), options: nil, progressBlock: nil, completionHandler: nil)
            contentLabel.attributedText = tataArticleModel.articleContent.convertArticleContentString()
            numLabel.text = "12" + "件良品"
            dateLabel.text = "2017-10-12"
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _picView: UIImageView?
    fileprivate var _contentLabel: UILabel?
    fileprivate var _numLabel: UILabel?
    fileprivate var _dateLabel: UILabel?
}

// MARK: - Getters and Setters
extension GoodsAlbumCollectionViewCell {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            
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
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textAlignment = .center
        }
        
        return _titleLabel!
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
            _contentLabel?.textAlignment = .left
            _contentLabel?.numberOfLines = 5
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
    
    fileprivate var numLabel: UILabel {
        if _numLabel == nil {
            _numLabel = UILabel()
            _numLabel?.font = Font.size11
            _numLabel?.textColor = Color.hexea9120
            _numLabel?.textAlignment = .left
        }
        
        return _numLabel!
    }
    
    fileprivate var dateLabel: UILabel {
        if _dateLabel == nil {
            _dateLabel = UILabel()
            _dateLabel?.font = Font.size10
            _dateLabel?.textColor = Color.hex919191
            _dateLabel?.textAlignment = .right
        }
        
        return _dateLabel!
    }
}

