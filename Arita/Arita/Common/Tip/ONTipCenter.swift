//
//  ONTipCenter.swift
//  OneAPP
//
//  Created by houwenjie on 2017/6/26.
//  Copyright © 2017年 iot. All rights reserved.
//

import Foundation
import Toaster
import MBProgressHUD

/**
 ONTipCenter **提示工具类
 */
class ONTipCenter {

    /// 显示toast
    ///
    /// - Parameter toast: toast内容
    public static func showToast(_ toast: String) {
        Toast(text: toast).show()
    }
    
    public static func showToast(_ toast: String, completion:@escaping (()-> Void)) {
        let toast = Toast(text: toast)
        toast.completion = { () in
            completion()
        }
        toast.show()
    }
}

private var kHUDAssociationKey: UInt8 = 0
/**
 ** UIViewController扩展 用于展示加载框
 */
extension UIViewController {
    var hud: MBProgressHUD? {
        get {
            return objc_getAssociatedObject(self, &kHUDAssociationKey) as? MBProgressHUD
        }
        set(newValue) {
            //使用runtime方法给分类添加属性
            objc_setAssociatedObject(self, &kHUDAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 显示HUD
    ///
    /// - Parameter tip: hud上显示的文字
    func showHUD(tip: String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.isUserInteractionEnabled = false
        hud.label.text = tip
        self.hud = hud
    }
    
    /// 显示加载HUD
    func showLoadingHUD() {
        self.showHUD(tip: "")
    }
    
    /// 移除HUD
    func dismissHUD() {
        if let hud = self.hud {
            hud.hide(animated: true)
        }
    }
    
}
