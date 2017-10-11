//
//  GoodsGridCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/11.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsGridCell: UICollectionViewCell {
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
        contentView.addSubview(goodImage)
        contentView.addSubview(goodLabel)
        contentView.addSubview(goodPriceLabel)
    }
    
    private func layoutPageViews() {
        goodImage.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.size.equalTo(CGSize(width: 175, height: 175))
        }
        
        goodLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodImage.snp.bottom).offset(7)
            make.left.equalTo(goodImage).offset(15)
            make.right.equalTo(goodImage).offset(-15)
            make.height.equalTo(40)
        }
        
        goodPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodLabel.snp.bottom).offset(15)
            make.left.right.equalTo(goodLabel)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }
    
    private func setPageViews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = CGFloat(5)
        layer.masksToBounds = true
    }
    
    // MARK: - Controller Attributes
    fileprivate var _goodImage: UIImageView?
    fileprivate var _goodLabel: UILabel?
    fileprivate var _goodPriceLabel: UILabel?
}

// MARK: - Getters and Setters
extension GoodsGridCell {
    var goodImage: UIImageView {
        if _goodImage == nil {
            _goodImage = UIImageView()
            
            return _goodImage!
        }
        
        return _goodImage!
    }
    
    var goodLabel: UILabel {
        if _goodLabel == nil {
            _goodLabel = UILabel()
            _goodLabel?.textColor = Color.hex2a2a2a
            _goodLabel?.font = Font.size14
            _goodLabel?.textAlignment = .center
            _goodLabel?.numberOfLines = 2
            _goodLabel?.lineBreakMode = .byWordWrapping
            
            return _goodLabel!
        }
        
        return _goodLabel!
    }
    
    var goodPriceLabel: UILabel {
        if _goodPriceLabel == nil {
            _goodPriceLabel = UILabel()
            _goodPriceLabel?.textColor = Color.hexea9120
            _goodPriceLabel?.font = Font.size18
            _goodPriceLabel?.textAlignment = .center
            
            return _goodPriceLabel!
        }
        
        return _goodPriceLabel!
    }
}
