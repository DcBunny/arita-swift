//
//  UIButton+Extension.swift
//  OneAPP
//
//  Created by 潘东 on 2017/6/16.
//  Copyright © 2017年 iot. All rights reserved.
//

import UIKit

/**
 BottomButtonStatus 设备管理**分享权限**页底部按钮状态
 */
public enum BottomButtonStatus {
    /// 分享状态，此时显示共享
    case share
    /// 删除但未选择，此时显示删除白色
    case deleteNoSelection
    /// 删除已选择，此时显示删除红色
    case deleteSelection
}

extension UIButton {
    // MARK: - Open Instance
    /**
     *  设置Button状态
     *
     */
    public var bottomButtonStatus: BottomButtonStatus? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.BottomButtonStatus) as? BottomButtonStatus
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.BottomButtonStatus, newValue , .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Accociate Instance Key
    private struct AssociaKey{
        static var BottomButtonStatus: String = "bottomButtonStatus"
    }
}
