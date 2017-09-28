//
//  ShareView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ShareView: UIView {

    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        findSharePlatform()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        addSubview(backView)
        backView.addSubview(titleLabel)
        backView.addSubview(wxFreindsButton)
        backView.addSubview(wxMomentsButton)
        backView.addSubview(weiBoButton)
        backView.addSubview(qqFriendsButton)
        backView.addSubview(qqZoneButton)
        backView.addSubview(copyLinkButton)
        backView.addSubview(closeButton)
    }
    
    private func layoutPageViews() {
        let titleLabelHeight = wxFreindsButton.titleLabel?.frame.size.height ?? 21
        let buttonHeight = titleLabelHeight + 75
        
        backView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(backView)
            make.bottom.equalTo(wxFreindsButton.snp.top).offset(-55)
        }
        
        wxFreindsButton.snp.makeConstraints { (make) in
            make.left.equalTo(backView)
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.right.equalTo(wxMomentsButton.snp.left)
            make.bottom.equalTo(qqFriendsButton.snp.top).offset(-30)
            make.width.equalTo(backView.snp.width).dividedBy(3)
            make.height.equalTo(buttonHeight)
        }
        
        wxMomentsButton.snp.makeConstraints { (make) in
            make.left.equalTo(wxFreindsButton.snp.right)
            make.top.bottom.equalTo(wxFreindsButton)
            make.right.equalTo(weiBoButton.snp.left)
            make.width.equalTo(wxFreindsButton)
            make.height.equalTo(buttonHeight)
        }
        
        weiBoButton.snp.makeConstraints { (make) in
            make.left.equalTo(wxMomentsButton.snp.right)
            make.top.bottom.equalTo(wxFreindsButton)
            make.right.equalTo(backView)
            make.width.equalTo(wxFreindsButton)
            make.height.equalTo(buttonHeight)
        }
        
        qqFriendsButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(wxFreindsButton)
            make.top.equalTo(wxFreindsButton.snp.bottom).offset(30)
            make.bottom.equalTo(closeButton.snp.top).offset(-50)
            make.width.equalTo(wxFreindsButton)
            make.height.equalTo(buttonHeight)
        }
        
        qqZoneButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(wxMomentsButton)
            make.top.bottom.equalTo(qqFriendsButton)
            make.width.equalTo(wxFreindsButton)
            make.height.equalTo(buttonHeight)
        }
        
        copyLinkButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(weiBoButton)
            make.top.bottom.equalTo(qqFriendsButton)
            make.width.equalTo(wxFreindsButton)
            make.height.equalTo(buttonHeight)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(qqFriendsButton.snp.bottom).offset(50)
            make.centerX.bottom.equalTo(backView)
        }
    }
    
    private func setPageViews() {
        backgroundColor = Color.hex000000Alpha50
    }
    
    // MARK: - Private Methods
    private func findSharePlatform() {
        sharePlatform.append(copyLinkButton)
        
        if QQApiInterface.isQQInstalled() {
            sharePlatform.insert(qqZoneButton, at: 0)
            sharePlatform.insert(qqFriendsButton, at: 0)
        }
        
        if WeiboSDK.isWeiboAppInstalled() {
            sharePlatform.insert(weiBoButton, at: 0)
        }
        
        if WXApi.isWXAppInstalled() {
            sharePlatform.insert(wxMomentsButton, at: 0)
            sharePlatform.insert(wxFreindsButton, at: 0)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _backView: UIView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _wxFreindsButton: ShareButton?
    fileprivate var _wxMomentsButton: ShareButton?
    fileprivate var _weiBoButton: ShareButton?
    fileprivate var _qqFriendsButton: ShareButton?
    fileprivate var _qqZoneButton: ShareButton?
    fileprivate var _copyLinkButton: ShareButton?
    fileprivate var _closeButton: UIButton?
    
    fileprivate var sharePlatform: [ShareButton] = []
}

// MARK: - Getters and Setters
extension ShareView {
    fileprivate var backView: UIView {
        if _backView == nil {
            _backView = UIView()
            _backView?.backgroundColor = UIColor.clear
            
            return _backView!
        }
        
        return _backView!
    }
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textAlignment = .center
            _titleLabel?.font = Font.size22
            _titleLabel?.textColor = Color.hexffffff
            _titleLabel?.text = "分享你的视野"
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    var wxFreindsButton: ShareButton {
        if _wxFreindsButton == nil {
            _wxFreindsButton = ShareButton()
            _wxFreindsButton?.setImage(UIImage(named: Icon.shareWechatFriends), for: .normal)
            _wxFreindsButton?.setImage(UIImage(named: Icon.shareWechatFriends), for: .highlighted)
            _wxFreindsButton?.setTitle("微信好友", for: .normal)
            _wxFreindsButton?.setTitle("微信好友", for: .highlighted)
            _wxFreindsButton?.titleLabel?.sizeToFit()
            _wxFreindsButton?.tag = 10000
            
            return _wxFreindsButton!
        }
        
        return _wxFreindsButton!
    }
    
    var wxMomentsButton: ShareButton {
        if _wxMomentsButton == nil {
            _wxMomentsButton = ShareButton()
            _wxMomentsButton?.setImage(UIImage(named: Icon.shareWechatMoments), for: .normal)
            _wxMomentsButton?.setImage(UIImage(named: Icon.shareWechatMoments), for: .highlighted)
            _wxMomentsButton?.setTitle("微信朋友圈", for: .normal)
            _wxMomentsButton?.setTitle("微信朋友圈", for: .highlighted)
            _wxMomentsButton?.tag = 10001
            
            return _wxMomentsButton!
        }
        
        return _wxMomentsButton!
    }
    
    var weiBoButton: ShareButton {
        if _weiBoButton == nil {
            _weiBoButton = ShareButton()
            _weiBoButton?.setImage(UIImage(named: Icon.shareWeibo), for: .normal)
            _weiBoButton?.setImage(UIImage(named: Icon.shareWeibo), for: .highlighted)
            _weiBoButton?.setTitle("新浪微博", for: .normal)
            _weiBoButton?.setTitle("新浪微博", for: .highlighted)
            _weiBoButton?.tag = 10002
            
            return _weiBoButton!
        }
        
        return _weiBoButton!
    }
    
    var qqFriendsButton: ShareButton {
        if _qqFriendsButton == nil {
            _qqFriendsButton = ShareButton()
            _qqFriendsButton?.setImage(UIImage(named: Icon.shareQQ), for: .normal)
            _qqFriendsButton?.setImage(UIImage(named: Icon.shareQQ), for: .highlighted)
            _qqFriendsButton?.setTitle("QQ好友", for: .normal)
            _qqFriendsButton?.setTitle("QQ好友", for: .highlighted)
            _qqFriendsButton?.tag = 10003
            
            return _qqFriendsButton!
        }
        
        return _qqFriendsButton!
    }
    
    var qqZoneButton: ShareButton {
        if _qqZoneButton == nil {
            _qqZoneButton = ShareButton()
            _qqZoneButton?.setImage(UIImage(named: Icon.shareQzone), for: .normal)
            _qqZoneButton?.setImage(UIImage(named: Icon.shareQzone), for: .highlighted)
            _qqZoneButton?.setTitle("QQ空间", for: .normal)
            _qqZoneButton?.setTitle("QQ空间", for: .highlighted)
            _qqZoneButton?.tag = 10004
            
            return _qqZoneButton!
        }
        
        return _qqZoneButton!
    }
    
    var copyLinkButton: ShareButton {
        if _copyLinkButton == nil {
            _copyLinkButton = ShareButton()
            _copyLinkButton?.setImage(UIImage(named: Icon.shareLink), for: .normal)
            _copyLinkButton?.setImage(UIImage(named: Icon.shareLink), for: .highlighted)
            _copyLinkButton?.setTitle("拷贝链接", for: .normal)
            _copyLinkButton?.setTitle("拷贝链接", for: .highlighted)
            _copyLinkButton?.tag = 10005
            
            return _copyLinkButton!
        }
        
        return _copyLinkButton!
    }
    
    var closeButton: UIButton {
        if _closeButton == nil {
            _closeButton = UIButton()
            _closeButton?.setImage(UIImage(named: Icon.shareClose), for: .normal)
            _closeButton?.setImage(UIImage(named: Icon.shareClose), for: .highlighted)
            _closeButton?.tag = 10006
            
            return _closeButton!
        }
        
        return _closeButton!
    }
}
