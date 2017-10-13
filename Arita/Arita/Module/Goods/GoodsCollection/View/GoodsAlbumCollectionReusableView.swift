//
//  GoodsAlbumCollectionReusableView.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsAlbumCollectionReusableView: UICollectionReusableView {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addHeaderViews()
        layoutHeaderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addHeaderViews() {
        addSubview(bgView)
        bgView.addSubview(albumImage)
        bgView.addSubview(contentLabel)
    }
    
    private func layoutHeaderViews() {
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-10)
            make.right.equalTo(self).offset(-10)
        }
        
        albumImage.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(albumImage.snp.width).multipliedBy(2.0/3)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumImage).offset(15)
            make.left.equalTo(albumImage).offset(15)
            make.right.equalTo(albumImage).offset(-15)
            make.bottom.equalTo(bgView).offset(-20)
        }
    }
    
    // MARK: - Public Attributes
    public var imageUrl: String? = "" {
        didSet {
            albumImage.backgroundColor = UIColor.green
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _bgView: UIView?
    fileprivate var _albumImage: UIImageView?
    fileprivate var _contentLabel: UILabel?
}

// MARK: - Getters and Setters
extension GoodsAlbumCollectionReusableView {
    
    fileprivate var bgView: UIView {
        if _bgView == nil {
            _bgView = UIView()
            _bgView?.backgroundColor = UIColor.white
            _bgView?.layer.cornerRadius = CGFloat(5)
            _bgView?.layer.masksToBounds = true
        }
        
        return _bgView!
    }
    
    fileprivate var albumImage: UIImageView {
        if _albumImage == nil {
            _albumImage = UIImageView()
        }
        
        return _albumImage!
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

