//
//  MineUserInfoAvatarTableViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineUserInfoAvatarTableViewCell **用户信息**页面头像栏cell
 */
class MineUserInfoAvatarTableViewCell: UITableViewCell {

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
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nextIcon)
        contentView.addSubview(seperatorView)
    }
    
    private func layoutCellViews() {
        itemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView)
            make.width.equalTo(50)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(itemLabel)
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.right.equalTo(nextIcon.snp.left).offset(-10)
        }
        
        nextIcon.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
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
    public var userAvatar = "" {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: userAvatar), placeholder: UIImage(named: Icon.userAvatar), options: [.transition(.fade(1.5))], progressBlock: nil, completionHandler: nil)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _itemLabel: UILabel?
    fileprivate var _avatarImageView: UIImageView?
    fileprivate var _nextIcon: UIImageView?
    fileprivate var _seperatorView: UIView?
}

// MARK: - Getters and Setters
extension MineUserInfoAvatarTableViewCell {
    fileprivate var itemLabel: UILabel {
        if _itemLabel == nil {
            _itemLabel = UILabel()
            _itemLabel?.textColor = Color.hex2a2a2a
            _itemLabel?.textAlignment = .left
            _itemLabel?.font = Font.size14
            _itemLabel?.text = "头像"
            
            return _itemLabel!
        }
        
        return _itemLabel!
    }
    
    fileprivate var avatarImageView: UIImageView {
        if _avatarImageView == nil {
            _avatarImageView = UIImageView()
            _avatarImageView?.layer.cornerRadius = 30
            _avatarImageView?.layer.masksToBounds = true
            
            return _avatarImageView!
        }
        
        return _avatarImageView!
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
