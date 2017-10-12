//
//  MineHomeTableViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineHomeTableViewCell **我的**页面主页cell
 */
class MineHomeTableViewCell: UITableViewCell {

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
        contentView.addSubview(itemIcon)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(nextIcon)
        contentView.addSubview(seperatorView)
    }
    
    private func layoutCellViews() {
        itemIcon.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(contentView)
            make.right.equalTo(itemNameLabel.snp.left).offset(15)
        }
        
        itemNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(itemIcon.snp.right).offset(15)
            make.centerY.equalTo(itemIcon)
            make.right.equalTo(nextIcon.snp.left).offset(-15)
        }
        
        nextIcon.snp.makeConstraints { (make) in
            make.left.equalTo(itemNameLabel.snp.right).offset(15)
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(itemIcon)
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.height.equalTo(1 / Size.screenScale)
            make.bottom.equalTo(contentView)
        }
    }
    
    private func setCellViews() {
        contentView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Public Methods
    public var leftIcon: String? = nil {
        didSet {
            if leftIcon != nil {
                itemIcon.image = UIImage(named: leftIcon!)
            }
        }
    }
    
    public var itemName: String? = nil {
        didSet {
            itemNameLabel.text = itemName
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _itemIcon: UIImageView?
    fileprivate var _itemNameLabel: UILabel?
    fileprivate var _nextIcon: UIImageView?
    fileprivate var _seperatorView: UIView?
}

// MARK: - Getters and Setters
extension MineHomeTableViewCell {
    fileprivate var itemIcon: UIImageView {
        if _itemIcon == nil {
            _itemIcon = UIImageView()
            
            return _itemIcon!
        }
        
        return _itemIcon!
    }
    
    fileprivate var itemNameLabel: UILabel {
        if _itemNameLabel == nil {
            _itemNameLabel = UILabel()
            _itemNameLabel?.textColor = Color.hex2a2a2a
            _itemNameLabel?.textAlignment = .left
            _itemNameLabel?.font = Font.size16
            
            return _itemNameLabel!
        }
        
        return _itemNameLabel!
    }
    
    fileprivate var nextIcon: UIImageView {
        if _nextIcon == nil {
            _nextIcon = UIImageView()
            _nextIcon?.image = UIImage(named: Icon.next)
            
            return _nextIcon!
        }
        
        return _nextIcon!
    }
    
    fileprivate var seperatorView: UIView {
        if _seperatorView == nil {
            _seperatorView = UIView()
            _seperatorView?.backgroundColor = Color.hexe4e4e4
            
            return _seperatorView!
        }
        
        return _seperatorView!
    }
}
