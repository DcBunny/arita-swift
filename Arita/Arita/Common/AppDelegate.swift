//
//  AppDelegate.swift
//  Arita
//
//  Created by 李宏博 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import XCGLogger
import Bugly
import IQKeyboardManagerSwift
import GDPerformanceView_Swift

// 全局的日志变量
let log = XCGLogger.default
let kArita = "kArita"
let kBuglyAppId = "900037900"
let kUserHasOnboard = "kUserHasOnboard"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // SetUp RootController
        chooseRootVC()
        beginMonitorPerformance()
        adaptationIOS11()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - 启动页
extension AppDelegate {
    fileprivate func chooseRootVC() {
        // 显示启动页3秒
        Thread.sleep(forTimeInterval: 3.0)
        
        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        
        let userHasOnboarded = UserDefaults.standard.bool(forKey: kUserHasOnboard)
        
        if userHasOnboarded {
            setupNormalRootViewController()
        } else {
            self.window?.rootViewController = showGuideVC()
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func showGuideVC() -> GuideController {
        let pics = [Icon.guideOne, Icon.guideTwo, Icon.guideThree]
        let guideController = GuideController(pics: pics)
        guideController.comfirmButton.addTarget(self, action: #selector(self.setupNormalRootViewController), for: .touchUpInside)
        UserDefaults.standard.set(true, forKey: kUserHasOnboard)
        UserDefaults.standard.synchronize()
        
        return guideController
    }
    
    @objc fileprivate func setupNormalRootViewController() {
        let rootVC = RootController()
        self.window?.rootViewController = rootVC
    }
}

// MARK: - 显示FPS
extension AppDelegate {
    fileprivate func beginMonitorPerformance() {
        GDPerformanceMonitor.sharedInstance.startMonitoring()
    }
}

// MARK: - 适配 iOS11
extension AppDelegate {
    fileprivate func adaptationIOS11() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        }
    }
}
