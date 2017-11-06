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
let aLiYunKey = "LTAIUpgXwM5M1UIw"
let aLiYunSecret = "jGVoCI1bQymrgkY4RBpVx721bmgEz6"
var isStatusHidden = !UIDevice.current.isIphoneX()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // SetUp RootController
        ONServiceFactory.sharedInstance.dataSource = self
        chooseRootVC()
        beginMonitorPerformance()
        adaptationIOS11()
        initialShareSDK()
        
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

// MARK: - 设置API接口工厂方法相关
extension AppDelegate: ONServiceFactoryDataSource {
    internal func servicesKindsOfServiceFactory() -> [String : String] {
        return [kArita: "Arita"]
    }
}

// MARK: - 启动页
extension AppDelegate {
    fileprivate func chooseRootVC() {
        // 显示启动页3秒
//        Thread.sleep(forTimeInterval: 3.0)

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

// MARK: - 初始化第三方分享(ShareSDK)
extension AppDelegate {
    fileprivate func initialShareSDK() {
        // 解决微信客户端无法发现的问题
        WXApi.registerApp("wx4a3852a5ca53e339")
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue
            ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform {
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
            },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform {
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "148986684",
                                                appSecret: "57cc60f1a941235560bc86706abe9e76",
                                                redirectUri: "http://sns.whalecloud.com/sina2/callback",
                                                authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx4a3852a5ca53e339",
                                             appSecret: "49ff531b4dba964d4251dcfc93d2e2a7")
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "1104788697",
                                         appKey: "KEYkM7rtF7Y1wB8m36e",
                                         authType: SSDKAuthTypeBoth)
                default:
                    break
                }
            })
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
