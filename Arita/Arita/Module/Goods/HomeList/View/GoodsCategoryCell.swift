//
//  GoodsCategoryCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsCategoryCell: UICollectionViewCell {
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
        contentView.addSubview(categoryImage)
        contentView.addSubview(categoryLabel)
    }
    
    private func layoutPageViews() {
        categoryImage.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(categoryImage.snp.bottom).offset(13)
            make.centerX.equalTo(categoryImage)
        }
    }
    
    private func setPageViews() {
        backgroundColor = UIColor.clear
    }
    
    // MARK: - Controller Attributes
    fileprivate var _categoryImage: UIImageView?
    fileprivate var _categoryLabel: UILabel?
}

// MARK: - Getters and Setters
extension GoodsCategoryCell {
    var categoryImage: UIImageView {
        if _categoryImage == nil {
            _categoryImage = UIImageView()
        }
        
        return _categoryImage!
    }
    
    var categoryLabel: UILabel {
        if _categoryLabel == nil {
            _categoryLabel = UILabel()
            _categoryLabel?.textColor = Color.hex2a2a2a
            _categoryLabel?.font = Font.size13
            _categoryLabel?.textAlignment = .center
        }
        
        return _categoryLabel!
    }
}
