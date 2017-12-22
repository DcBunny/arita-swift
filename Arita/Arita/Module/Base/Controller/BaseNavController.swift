//
//  BaseNavController.swift
//  devicescloud
//
//  Created by 潘东 on 2017/12/11.
//

import UIKit

/// 导航控制器基控制器
class BaseNavController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //手势Delegate
        self.interactivePopGestureRecognizer!.delegate = self
        
        //UINavigationControllerDelegate
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //push时关闭手势
        self.interactivePopGestureRecognizer?.isEnabled = false
        
        super.pushViewController(viewController, animated: animated)
    }
    
    //MARK:- UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if navigationController.viewControllers.count == 1 {
            //如果是 rootViewController 关闭手势响应
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        else{
            //如果不是 rootViewController 开启手势响应
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
    }

}
