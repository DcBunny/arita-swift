//
//  GoodsNormalCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsNormalCell: UITableViewCell {

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
        contentView.addSubview(bgView)
        bgView.addSubview(goodImage)
        bgView.addSubview(goodLabel)
        bgView.addSubview(goodPriceLabel)
    }
    
    private func layoutCellViews() {
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-5)
            make.right.equalTo(contentView).offset(-10)
        }
        
        goodImage.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(bgView)
            make.height.equalTo(goodImage.snp.width)
        }
        
        goodLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodImage.snp.bottom).offset(7)
            make.left.equalTo(goodImage).offset(30)
            make.right.equalTo(goodImage).offset(-30)
        }
        
        goodPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(goodLabel.snp.bottom).offset(15)
            make.left.right.equalTo(goodLabel)
            make.bottom.equalTo(bgView).offset(-20)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var cellData: JSON? = nil {
        didSet {
            goodImage.kf.setImage(with: URL(string: cellData!["thumb_path"].stringValue), placeholder: UIImage(named: "pic_placeholderLiangpin1x1"), options: [.transition(.fade(1.5))], progressBlock: nil, completionHandler: nil)
            goodLabel.text = cellData!["title"].stringValue
            goodPriceLabel.text = "¥" + cellData!["price"].stringValue
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _bgView: UIView?
    fileprivate var _goodImage: UIImageView?
    fileprivate var _goodLabel: UILabel?
    fileprivate var _goodPriceLabel: UILabel?
}

// MARK: - Getters and Setters
extension GoodsNormalCell {
    
    fileprivate var bgView: UIView {
        if _bgView == nil {
            _bgView = UIView()
            _bgView?.backgroundColor = UIColor.white
            _bgView?.layer.cornerRadius = CGFloat(5)
            _bgView?.layer.masksToBounds = true
        }
        
        return _bgView!
    }
    
    fileprivate var goodImage: UIImageView {
        if _goodImage == nil {
            _goodImage = UIImageView()
            
            return _goodImage!
        }
        
        return _goodImage!
    }
    
    fileprivate var goodLabel: UILabel {
        if _goodLabel == nil {
            _goodLabel = UILabel()
            _goodLabel?.textColor = Color.hex2a2a2a
            _goodLabel?.font = Font.size14
            _goodLabel?.textAlignment = .center
            _goodLabel?.numberOfLines = 1
            
            return _goodLabel!
        }
        
        return _goodLabel!
    }
    
    fileprivate var goodPriceLabel: UILabel {
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
