//
//  GoodsCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/18.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsCell: UITableViewCell {

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
        addSubview(goodImage)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(priceLabel)
        addSubview(splitLine)
    }
    
    private func layoutCellViews() {
        goodImage.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(15)
            make.size.equalTo(CGSize(width: 87, height: 87))
            make.bottom.equalTo(splitLine.snp.top).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodImage).offset(5)
            make.left.equalTo(goodImage.snp.right).offset(15)
            make.right.equalTo(self).offset(-15)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(goodImage.snp.right).offset(15)
            make.right.equalTo(self).offset(-15)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(goodImage)
        }
        
        splitLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var picUrl = "" {
        didSet {
            goodImage.backgroundColor = UIColor.blue
            titleLabel.text = "这是一个创意的乱七八糟东西"
            contentLabel.text = "不管一款产品在设计、研发阶段经历了怎样的反复测试、精心打磨、耗费了多少人力物力，它总要一点或者简单或者隆重的仪式感，以合适的姿态亮相。它总要一点或者简单或者隆重的仪式感，它总要一点或者简单或者隆重的仪式感"
            priceLabel.text = "¥" + "259"
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _goodImage: UIImageView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _contentLabel: UILabel?
    fileprivate var _priceLable: UILabel?
    fileprivate var _splitLine: UIImageView?
}

// MARK: - Getters and Setters
extension GoodsCell {
    fileprivate var goodImage: UIImageView {
        if _goodImage == nil {
            _goodImage = UIImageView()
            _goodImage?.layer.cornerRadius = 5
            _goodImage?.layer.masksToBounds = true
        }
        
        return _goodImage!
    }
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hex4a4a4a
            _titleLabel?.font = Font.size14
        }
        
        return _titleLabel!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.textColor = Color.hex919191
            _contentLabel?.font = Font.size11
            _contentLabel?.numberOfLines = 2
        }
        
        return _contentLabel!
    }
    
    fileprivate var priceLabel: UILabel {
        if _priceLable == nil {
            _priceLable = UILabel()
            _priceLable?.textColor = Color.hexea9120
            _priceLable?.font = Font.size14
            _priceLable?.textAlignment = .right
        }
        
        return _priceLable!
    }
    
    fileprivate var splitLine: UIImageView {
        if _splitLine == nil {
            _splitLine = UIImageView()
            _splitLine?.image = UIImage(named: Icon.dottedLine)
        }
        
        return _splitLine!
    }
}
