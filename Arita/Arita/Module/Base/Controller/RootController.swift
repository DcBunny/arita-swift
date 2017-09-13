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
        let mineNav = UINavigationController(rootViewController: MineHomeController())
        viewControllers = [articleNav, goodsNav, mineNav]
    }
    
    private func setTabBarItem() {
        tabBar.barTintColor = Color.hexffffff
        tabBar.isTranslucent = false
        
        let articleItem = tabBar.items![0]
        let goodsItem = tabBar.items![1]
        let mineItem = tabBar.items![2]
        
        articleItem.image = UIImage(named: Icon.articleOff)?.withRenderingMode(.alwaysOriginal)
        articleItem.selectedImage = UIImage(named: Icon.articleOn)?.withRenderingMode(.alwaysOriginal)
        
        goodsItem.image = UIImage(named: Icon.goodsOff)?.withRenderingMode(.alwaysOriginal)
        goodsItem.selectedImage = UIImage(named: Icon.goodsOn)?.withRenderingMode(.alwaysOriginal)
        
        mineItem.image = UIImage(named: Icon.mineOff)?.withRenderingMode(.alwaysOriginal)
        mineItem.selectedImage = UIImage(named: Icon.mineOn)?.withRenderingMode(.alwaysOriginal)
    }
    
    // MARK: - Priate Methods
    private func setBorderColor() {
        tabBar.backgroundImage = Color.hexffffff!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale))
        tabBar.shadowImage = Color.hexe4e4e4!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale))
    }
}

