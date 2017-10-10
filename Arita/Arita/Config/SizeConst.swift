//
//  Size.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 *
 *  用于放置所有尺寸相关的常量
 *
 */
struct Size {
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static let screenScale = UIScreen.main.scale
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenSize = UIScreen.main.bounds.size
    static let naviBarSize = UIApplication.navigationController()?.navigationBar.frame.size
}
