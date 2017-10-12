//
//  MineHomeHeaderView.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineHomeHeaderView **我的**页面主页头部视图
 */
class MineHomeHeaderView: UITableViewHeaderFooterView {

    // MARK: - Init Methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addHeaderViews()
        layoutHeaderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addHeaderViews() {
        contentView.addSubview(userAvatarButton)
        contentView.addSubview(userButton)
    }
    
    private func layoutHeaderViews() {
        userAvatarButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(35)
            make.centerX.equalTo(contentView)
            make.size.equalTo(CGSize(width: 77, height: 77))
            make.bottom.equalTo(userButton.snp.top).offset(-20)
        }
        
        userButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(userAvatarButton)
            make.top.equalTo(userAvatarButton.snp.bottom).offset(20)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-30)
        }
    }
    
    // MARK: - Public Attributes
    /// 用户头像
    public var userAvatar: String? = nil {
        didSet {
            if userAvatar != nil {
                userAvatarButton.kf.setImage(with: URL(string: userAvatar!), for: .normal)
                userAvatarButton.kf.setImage(with: URL(string: userAvatar!), for: .highlighted)
            } else {
                userAvatarButton.setImage(UIImage(named: Icon.userAvatar), for: .normal)
                userAvatarButton.setImage(UIImage(named: Icon.userAvatar), for: .highlighted)
            }
        }
    }
    
    /// 用户昵称
    public var userName: String? = nil {
        didSet {
            if userName != nil {
                userButton.setTitle(userName, for: .normal)
                userButton.setTitle(userName, for: .highlighted)
            } else {
                userButton.setTitle("请登录", for: .normal)
                userButton.setTitle("请登录", for: .highlighted)
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _userAvatarButton: UIButton?
    fileprivate var _userButton: UIButton?
}

// MARK: - Getters and Setters
extension MineHomeHeaderView {
    var userAvatarButton: UIButton {
        if _userAvatarButton == nil {
            _userAvatarButton = UIButton()
            _userAvatarButton?.layer.cornerRadius = 38.5
            _userAvatarButton?.layer.masksToBounds = true
            
            return _userAvatarButton!
        }
        
        return _userAvatarButton!
    }
    
    var userButton: UIButton {
        if _userButton == nil {
            _userButton = UIButton()
            
            return _userButton!
        }
        
        return _userButton!
    }
}

