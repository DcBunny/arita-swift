//
//  ShareModel.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
/* 分享类型 */
enum ShareType: Int {
    case wechatFriends = 0
    case wechatMoments
    case weibo
    case qq
    case qZone
    case link
}

struct ShareModel {
    public var shareIcon: String?
    public var shareName: String?
    public var shareType: ShareType?
    
    public static func initial() -> ShareModel {
        return ShareModel(shareIcon: nil, shareName: nil, shareType: nil)
    }
    
    public static func shareWechatFriends() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareWechatFriends, shareName: "微信好友", shareType: .wechatFriends)
    }
    
    public static func shareWechatMoments() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareWechatMoments, shareName: "微信朋友圈", shareType: .wechatMoments)
    }
    
    public static func shareWeibo() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareWeibo, shareName: "新浪微博", shareType: .weibo)
    }
    
    public static func shareQQ() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareQQ, shareName: "QQ好友", shareType: .qq)
    }
    
    public static func shareQzone() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareQzone, shareName: "QQ空间", shareType: .qZone)
    }
    
    public static func shareLink() -> ShareModel {
        return ShareModel(shareIcon: Icon.shareLink, shareName: "复制链接", shareType: .link)
    }
}
