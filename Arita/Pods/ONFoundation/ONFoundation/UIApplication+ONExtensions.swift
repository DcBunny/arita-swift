//
//  UIApplication+ONExtensions.swift
//  OneAPP
//
//  Created by 潘东 on 2017/5/18.
//  Copyright © 2017年 iot. All rights reserved.
//

import UIKit
/**
 *
 *  UIApplication的扩展
 *
 */

extension UIApplication {
    /**
     寻找当前页面最上层的控制器
     
     - returns: 当前页面最上层的控制器
     */
    open class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    /**
     寻找根导航控制器
     
     - returns: 根导航控制器
     */
    open class func navigationController() -> UINavigationController? {
        let base = UIApplication.shared.delegate?.window??.rootViewController
        
        if let tab = base as? UITabBarController {
            return tab.selectedViewController as? UINavigationController
        } else if let nav = base as? UINavigationController {
            return nav
        } else {
            return nil
        }
    }
}
