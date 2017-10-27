//
//  MineUserInfoNormalTableViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineUserInfoNormalTableViewCell **用户信息**页面一般格式cell
 */
class MineUserInfoNormalTableViewCell: UITableViewCell {

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
        contentView.addSubview(itemLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(nextIcon)
        contentView.addSubview(seperatorView)
    }
    
    private func layoutCellViews() {
        itemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(50)
            make.right.equalTo(infoLabel.snp.left).offset(-15)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(itemLabel.snp.right).offset(15)
            make.centerY.equalTo(itemLabel)
            make.height.equalTo(itemLabel)
            make.right.equalTo(nextIcon.snp.left).offset(-10)
        }
        
        nextIcon.snp.makeConstraints { (make) in
            make.left.equalTo(infoLabel.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 16, height: 16))
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
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var infoName = "" {
        didSet {
            infoLabel.text = infoName
        }
    }
    
    public var itemName = "" {
        didSet {
            itemLabel.text = itemName
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _itemLabel: UILabel?
    fileprivate var _infoLabel: UILabel?
    fileprivate var _nextIcon: UIImageView?
    fileprivate var _seperatorView: UIView?
}

// MARK: - Getters and Setters
extension MineUserInfoNormalTableViewCell {
    fileprivate var itemLabel: UILabel {
        if _itemLabel == nil {
            _itemLabel = UILabel()
            _itemLabel?.textColor = Color.hex2a2a2a
            _itemLabel?.textAlignment = .left
            _itemLabel?.font = Font.size14
            
            return _itemLabel!
        }
        
        return _itemLabel!
    }
    
    fileprivate var infoLabel: UILabel {
        if _infoLabel == nil {
            _infoLabel = UILabel()
            _infoLabel?.textAlignment = .right
            _infoLabel?.textColor = Color.hex919191
            _infoLabel?.font = Font.size14
            
            return _infoLabel!
        }
        
        return _infoLabel!
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

