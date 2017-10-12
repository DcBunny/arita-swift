//
//  ShareCollectionCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * ShareCollectionCell 分享页面CollectionView的cell
 */
class ShareCollectionCell: UICollectionViewCell {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        contentView.addSubview(shareIcon)
        contentView.addSubview(shareName)
    }
    
    private func layoutPageViews() {
        shareIcon.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.bottom.equalTo(shareName.snp.top).offset(-15)
        }
        
        shareName.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(shareIcon.snp.bottom).offset(15)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    private func setPageViews() {
        backgroundColor = UIColor.clear
    }
    
    // MARK: - Public Attributes
    public var shareModel: ShareModel = ShareModel.initial() {
        didSet {
            shareIcon.image = UIImage(named: shareModel.shareIcon!)
            shareName.text = shareModel.shareName
            shareType = shareModel.shareType
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shareIcon: UIImageView?
    fileprivate var _shareName: UILabel?
    var shareType: ShareType?
}

// MARK: - Getters and Setters
extension ShareCollectionCell {
    fileprivate var shareIcon: UIImageView {
        if _shareIcon == nil {
            _shareIcon = UIImageView()
            
            return _shareIcon!
        }
        
        return _shareIcon!
    }
    
    fileprivate var shareName: UILabel {
        if _shareName == nil {
            _shareName = UILabel()
            _shareName?.textColor = Color.hexffffff
            _shareName?.font = Font.size15
            _shareName?.textAlignment = .center
            
            return _shareName!
        }
        
        return _shareName!
    }
}
