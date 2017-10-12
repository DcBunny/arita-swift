//
//  MineNotificationTableViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineNotificationTableViewCell **设置**页面开启推送cell
 */
class MineNotificationTableViewCell: UITableViewCell {

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
        contentView.addSubview(switchButton)
        contentView.addSubview(seperatorView)
    }
    
    private func layoutCellViews() {
        itemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.right.equalTo(switchButton.snp.left).offset(-15)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 51, height: 34))
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
    public var itemName = "" {
        didSet {
            itemLabel.text = itemName
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _itemLabel: UILabel?
    fileprivate var _switchButton: UISwitch?
    fileprivate var _seperatorView: UIView?
}

// MARK: - Getters and Setters
extension MineNotificationTableViewCell {
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
    
    var switchButton: UISwitch {
        if _switchButton == nil {
            _switchButton = UISwitch()
            _switchButton?.isOn = false
            
            return _switchButton!
        }
        
        return _switchButton!
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


