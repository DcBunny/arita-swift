//
//  ShareTool.swift
//  Arita
//
//  Created by 潘东 on 2017/9/29.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation

/**
 ShareDelegate 分享工具代理方法
 */
protocol ShareDelegate: class {
    // MARK: Optional
    /**
     告诉代理在分享已经被取消了
     
     **@Optional**
     
     - Parameter platform: 分享的平台
     */
    func didSucessed(shareTo platform: ShareType)
    
    /**
     告诉代理在分享已经成功了
     
     **@Optional**
     
     - Parameter platform: 分享的平台
     - Parameter error: 失败的错误
     */
    func didFailed(shareTo platform: ShareType, with error: Error?)
    
    /**
     告诉代理在分享已经失败了
     
     **@Optional**
     
     - Parameter platform: 分享的平台
     */
    func didCanceled(shareTo platform: ShareType)
}

extension ShareDelegate {
    func didSucessed(shareTo platform: ShareType) {
        if platform == .link {
            ONTipCenter.showToast("链接已拷贝!")
        } else {
            ONTipCenter.showToast("分享成功了")
        }
    }
    
    func didFailed(shareTo platform: ShareType, with error: Error?) {
        print("授权失败,错误描述:\(String(describing: error))")
    }
    
    func didCanceled(shareTo platform: ShareType) {
        ONTipCenter.showToast("取消分享")
    }
}

/* 第三方分享工具 */
class ShareTool {
    // MARK: - Init Method
    private init() { }
    static let sharedInstance = ShareTool()
    
    public var delegate: ShareDelegate?
    
    public func shareWith(content: String?, to shareType: ShareType) {
        let shareParames = NSMutableDictionary()
        shareParames.ssdkEnableUseClientShare()
        var platformType: SSDKPlatformType!
        var shareText = "分享内容"
        let shareTitle = "分享标题"
        let shareUrl = NSURL(string: content!) as URL!
        var shareContentType = SSDKContentType.webPage
        
        let url = URL(string: "image url")
        var thumbImage = UIImage(named: Icon.appIcon)!
        if url != nil {
            let data = NSData(contentsOf: url!)! as Data
            thumbImage = UIImage(data: data, scale: 1.0)!
        }
        let imageData = UIImagePNGRepresentation(thumbImage)
        if (imageData?.count)! > 1024 * 32 {
            let scaleRactor = sqrt(CGFloat((imageData!.count) / (1024 * 32) + 1))
            thumbImage = thumbImage.scaledToMaxSize(size: CGSize(width: thumbImage.size.width / scaleRactor, height: thumbImage.size.height / scaleRactor))
        }
        
        switch shareType {
        case .wechatFriends:
            platformType = SSDKPlatformType.subTypeWechatSession
            print("微信分享")
            
        case .wechatMoments:
            platformType = SSDKPlatformType.subTypeWechatTimeline
            print("微信朋友圈")
            
        case .weibo:
            platformType = SSDKPlatformType.typeSinaWeibo
            shareContentType = .image
            shareText += " "
            shareText += (shareUrl?.absoluteString)!
            print("微博")
            
        case .qq:
            platformType = SSDKPlatformType.subTypeQQFriend
            print("QQ好友")
            
        case .qZone:
            platformType = SSDKPlatformType.subTypeQZone
            print("QQ空间")
            
        case .link:
            platformType = SSDKPlatformType.typeCopy
            print("拷贝链接")
        }
        
        shareParames.ssdkSetupShareParams(byText: shareText,
                                          images : thumbImage,
                                          url : shareUrl,
                                          title : shareTitle,
                                          type : shareContentType)
        
        ShareSDK.share(platformType, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: self.delegate?.didSucessed(shareTo: shareType)
            case SSDKResponseState.fail:    self.delegate?.didFailed(shareTo: shareType, with: error)
            case SSDKResponseState.cancel:  self.delegate?.didCanceled(shareTo: shareType)
                
            default:
                break
            }
        }
    }
}
