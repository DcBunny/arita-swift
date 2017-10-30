//
//  MineShareController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/26.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineShareController **我的**页面推荐给好友主页
 */
class MineShareController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBar(type: .none)
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        view.addSubview(maskView)
        view.addSubview(backView)
        backView.addSubview(shareWechatFriend)
        backView.addSubview(shareWechatMoment)
        backView.addSubview(shareWechatFriendButton)
        backView.addSubview(shareWechatMomentButton)
        backView.addSubview(cancelButton)
        backView.addSubview(seperatorView)
    }
    
    private func layoutPageViews() {
        maskView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(backView.snp.top)
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(maskView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(171)
        }
        
        shareWechatFriend.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.height.equalTo(55)
            make.width.equalTo(shareWechatMoment)
            make.top.equalTo(backView)
            make.bottom.equalTo(shareWechatMoment.snp.top)
        }
        
        shareWechatFriendButton.snp.makeConstraints { (make) in
            make.edges.equalTo(shareWechatFriend)
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.height.equalTo(1 / Size.screenScale)
            make.bottom.equalTo(shareWechatFriend.snp.bottom)
        }
        
        shareWechatMoment.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.top.equalTo(shareWechatFriend.snp.bottom)
            make.height.equalTo(55)
            make.bottom.equalTo(cancelButton.snp.top).offset(-6)
        }
        
        shareWechatMomentButton.snp.makeConstraints { (make) in
            make.edges.equalTo(shareWechatMoment)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.top.equalTo(shareWechatMoment.snp.bottom).offset(6)
            make.height.equalTo(55)
            make.bottom.equalTo(backView)
        }
    }
    
    private func setPageViews() {
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        maskView.backgroundColor = Color.hex000000Alpha50
        maskView.addGestureRecognizer(tapGestureDismiss)
        view.backgroundColor = UIColor.clear
        seperatorView.backgroundColor = Color.hexe4e4e4
        shareWechatFriendButton.tag = 0
        shareWechatMomentButton.tag = 1
        shareWechatFriendButton.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
        shareWechatMomentButton.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
        
        ShareTool.sharedInstance.delegate = self
    }
    
    // MARK: - Event Response
    @objc func shareAction(sender: UIButton) {
        var shareType: ShareType!
        if sender.tag == 0 {
            shareType = ShareType.wechatFriends
        } else {
            shareType = ShareType.wechatMoments
        }
        let shareUrl = API.shareUrl
        let content = [ShareKey.shareUrlKey: shareUrl,
                       ShareKey.shareTitleKey: "阿里塔 - 创意生活新媒体",
                       ShareKey.shareDescribtionKey: "阿里塔 · 不止有趣\n每天精彩尽在塔塔报",
                       ShareKey.shareImageUrlKey: ""
        ]
        ShareTool.sharedInstance.shareWith(content: content, to: shareType)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _backView: UIView?
    fileprivate var _shareWechatFriend: ButtonView?
    fileprivate var _shareWechatMoment: ButtonView?
    fileprivate var _cancelButton: UIButton?
    fileprivate var shareWechatFriendButton = UIButton()
    fileprivate var shareWechatMomentButton = UIButton()
    fileprivate var seperatorView = UIView()
    fileprivate var maskView = UIView()
}

// MARK: - Share Delegate
extension MineShareController: ShareDelegate {
    func didSucessed(shareTo platform: ShareType) {
        viewDismiss()
        ONTipCenter.showToast("分享成功")
    }
    
    func didFailed(shareTo platform: ShareType, with error: Error?) {
        ONTipCenter.showToast("分享失败，请稍候重新分享")
    }
    
    func didCanceled(shareTo platform: ShareType) {
        viewDismiss()
        ONTipCenter.showToast("分享取消")
    }
}

// MARK: - Getters and Setters
extension MineShareController {
    fileprivate var backView: UIView {
        if _backView == nil {
            _backView = UIView()
            _backView?.backgroundColor = Color.hexf5f5f5
            
            return _backView!
        }
        
        return _backView!
    }
    
    fileprivate var shareWechatFriend: ButtonView {
        if _shareWechatFriend == nil {
            _shareWechatFriend = ButtonView()
            _shareWechatFriend?.tag = 0
            _shareWechatFriend?.set(image: UIImage(named: Icon.buttonWechatFriends)!, and: "分享给好友")
            
            return _shareWechatFriend!
        }
        
        return _shareWechatFriend!
    }
    
    fileprivate var shareWechatMoment: ButtonView {
        if _shareWechatMoment == nil {
            _shareWechatMoment = ButtonView()
            _shareWechatMoment?.tag = 1
            _shareWechatMoment?.set(image: UIImage(named: Icon.buttonWechatMoments)!, and: "分享到朋友圈")
            
            return _shareWechatMoment!
        }
        
        return _shareWechatMoment!
    }
    
    fileprivate var cancelButton: UIButton {
        if _cancelButton == nil {
            _cancelButton = UIButton()
            _cancelButton?.setTitle("取消", for: .normal)
            _cancelButton?.setTitle("取消", for: .highlighted)
            _cancelButton?.setTitleColor(Color.hex2a2a2a, for: .normal)
            _cancelButton?.setTitleColor(Color.hex2a2a2a, for: .highlighted)
            _cancelButton?.backgroundColor = Color.hexffffff
            _cancelButton?.titleLabel?.font = Font.size16
            _cancelButton?.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
            
            return _cancelButton!
        }
        
        return _cancelButton!
    }
}

