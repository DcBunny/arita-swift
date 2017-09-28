//
//  ShareController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ShareController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .none)
    }
    
    private func addPageViews() {
        view.addSubview(shareView)
    }
    
    private func layoutPageViews() {
        shareView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = UIColor.clear
        
        shareView.wxFreindsButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.wxMomentsButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.qqFriendsButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.qqZoneButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.weiBoButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.copyLinkButton.addTarget(self, action: #selector(share(sender:)), for: .touchUpInside)
        shareView.closeButton.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
    }
    
    // MARK: - Event Responses
    @objc private func share(sender: UIButton) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享内容",
                                          images : UIImage(named: "shareImg.png"),
                                          url : NSURL(string:"http://mob.com") as URL!,
                                          title : "分享标题",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
            
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _shareView: ShareView?
}

// MARK: - Getters and Setters
extension ShareController {
    fileprivate var shareView: ShareView {
        if _shareView == nil {
            _shareView = ShareView()
            
            return _shareView!
        }
        
        return _shareView!
    }
}
