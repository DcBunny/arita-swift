//
//  RootController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 RootController 为OneApp的根类，将OneApp分为**首页**，**良品**和**我的**三部分
 */
class RootController: UITabBarController {
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubController()
        setTabBarItem()
        setBorderColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Controller Settings
    private func setSubController() {
        let articleNav = UINavigationController(rootViewController: ArticleHomeController())
        let goodsNav = UINavigationController(rootViewController: GoodsHomeController())
        viewControllers = [articleNav, goodsNav]
    }
    
    private func setTabBarItem() {
        tabBar.barTintColor = Color.hexefefef
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Color.hexefefef
        
        let articleItem = tabBar.items![0]
        let goodsItem = tabBar.items![1]
        
        articleItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        articleItem.image = UIImage(named: Icon.articleOff)?.withRenderingMode(.alwaysOriginal)
        articleItem.selectedImage = UIImage(named: Icon.articleOn)?.withRenderingMode(.alwaysOriginal)
        
        goodsItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        goodsItem.image = UIImage(named: Icon.goodsOff)?.withRenderingMode(.alwaysOriginal)
        goodsItem.selectedImage = UIImage(named: Icon.goodsOn)?.withRenderingMode(.alwaysOriginal)
    }
    
    // MARK: - Priate Methods
    private func setBorderColor() {
        tabBar.backgroundImage = Color.hexefefef!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale), isCircle: false)
        tabBar.shadowImage = Color.hexe4e4e4!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale), isCircle: false)
    }
}

