//
//  CategoryCollectionCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
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
        contentView.addSubview(categoryIcon)
        contentView.addSubview(categoryName)
        contentView.addSubview(updateTime)
    }
    
    private func layoutPageViews() {
        categoryIcon.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(contentView)
            make.bottom.equalTo(categoryName.snp.top).offset(-15)
            make.size.equalTo(CGSize(width: 64, height: 64))
        }
        
        categoryName.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(categoryIcon.snp.bottom).offset(15)
            make.bottom.equalTo(updateTime.snp.top).offset(-10)
        }
        
        updateTime.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.top.equalTo(categoryName.snp.bottom).offset(10)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    // MARK: - Public Attributes
    public var categoryModel: CategoryModel = CategoryModel.initial() {
        didSet {
            categoryIcon.image = UIImage(named: categoryModel.categoryIcon!)
            categoryName.text = categoryModel.categoryName
            updateTime.text = categoryModel.updateTime
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _categoryIcon: UIImageView?
    fileprivate var _categoryName: UILabel?
    fileprivate var _updateTime: UILabel?
}

// MARK: - Getters and Setters
extension CategoryCollectionCell {
    fileprivate var categoryIcon: UIImageView {
        if _categoryIcon == nil {
            _categoryIcon = UIImageView()
            
            return _categoryIcon!
        }
        
        return _categoryIcon!
    }
    
    fileprivate var categoryName: UILabel {
        if _categoryName == nil {
            _categoryName = UILabel()
            _categoryName?.textColor = Color.hex2a2a2a
            _categoryName?.font = Font.size12
            _categoryName?.textAlignment = .center
            
            return _categoryName!
        }
        
        return _categoryName!
    }
    
    fileprivate var updateTime: UILabel {
        if _updateTime == nil {
            _updateTime = UILabel()
            _updateTime?.textColor = Color.hex919191
            _updateTime?.font = Font.size10
            _updateTime?.textAlignment = .center
            
            return _updateTime!
        }
        
        return _updateTime!
    }
}
