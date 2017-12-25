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
import SwiftyJSON
import IQKeyboardManagerSwift
import Kingfisher


// 全局的日志变量
let log = XCGLogger.default
let kArita = "kArita"
let kBuglyAppId = "900037900"
let kUserHasOnboard = "kUserHasOnboard"
let aLiYunKey = "LTAIUpgXwM5M1UIw"
let aLiYunSecret = "jGVoCI1bQymrgkY4RBpVx721bmgEz6"
let kJPushKey = ""
var isStatusHidden = !UIDevice.current.isIphoneX()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications(application, with: launchOptions)
        ONServiceFactory.sharedInstance.dataSource = self
        configLog()
        adaptationIOS11()
        initialShareSDK()
        chooseRootVC()
        
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
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
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

// MARK: - 设置log
extension AppDelegate {
    fileprivate func configLog() {
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
    }
}

// MARK: - 启动页
extension AppDelegate {
    fileprivate func chooseRootVC() {
        let userHasOnboarded = UserDefaults.standard.bool(forKey: kUserHasOnboard)
        
        if userHasOnboarded {
            setupNormalRootViewController()
        } else {
            self.window?.rootViewController = showGuideVC()
        }
        
        self.window?.makeKeyAndVisible()
        setUpDailyCheck()
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
    
    /**
     *  设置启动页日签
     */
    fileprivate func setUpDailyCheck() {
        // 1.判断沙盒中是否存在日签图片，如果存在，直接显示
        let filePath = getFilePathWithImageName(imageName: kUserDefaults.value(forKey: dailyCheckImageName) as? String)
        let isExist = isFileExistWithFilePath(filePath: filePath)
        
        if isExist {  // 图片存在说明filepath不为空
            let dailyCheckView = DailyCheckSetupView(frame: self.window!.bounds)
            dailyCheckView.filePath = filePath!
            dailyCheckView.show()
        } else {
            print("启动日签图片为空")
        }
        
        // 2.无论沙盒中是否存在日签图片，都需要重新调用日签接口，判断日签是否更新
        // 将更新日签的逻辑放入ArticleHomeController
    }
}

/// 日签图片操作
extension AppDelegate {
    /**
     *  判断文件是否存在
     */
    fileprivate func isFileExistWithFilePath(filePath: String?) -> Bool {
        let fileManager = FileManager.default
        if filePath == nil {
            return false
        } else {
            return fileManager.fileExists(atPath: filePath!)
        }
    }
    /**
     *  根据图片名拼接文件路径
     */
    fileprivate func getFilePathWithImageName(imageName: String?) -> String? {
        if imageName != nil {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let filePath = path?.appendingFormat("/\(imageName!)")
            return filePath
        }
        
        return nil
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

// MARK: - Push远程通知注册
extension AppDelegate: JPUSHRegisterDelegate {
    func registerForPushNotifications(_ application: UIApplication, with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // 通知注册实体类
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        // 注册极光推送
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushKey, channel:"Publish channel" , apsForProduction: false)
        
        JPUSHService.registrationIDCompletionHandler { (resCode, registrationID) in
            if resCode == 0{
                log.info("registrationID获取成功：\(String(describing: registrationID))")
            }else {
                log.info("registrationID获取失败：\(String(describing: registrationID))")
            }
        }
        
        //TODO: 生产环境关闭
//        JPUSHService.setLogOFF()
        
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>
        //
        // 这个判断是在程序没有运行的情况下收到通知，如果remote不为空，就代表应用在未打开的时候收到了推送消息，点击通知跳转页面
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.info("did Fail To Register For Remote Notifications With Error:\(error)")
    }
    
    /**
     收到静默推送的回调
     
     @param application  UIApplication 实例
     @param userInfo 推送时指定的参数
     @param completionHandler 完成回调
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        log.info("iOS7及以上系统，收到通知:\(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // iOS 10.x 需要
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            log.info("iOS10 前台收到远程通知:\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo)
        } else {
            log.info("iOS10 前台收到本地通知:\(userInfo)")
        }
        // 需要执行这个方法，选择是否提醒用户，通过alert方法提醒
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            log.info("iOS10 收到远程通知:\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    // 接收到推送实现的方法
    func receivePush(_ userInfo : Dictionary<String,Any>) {
        goToDailyCheckViewController()
    }
    
    // 跳转至日签页面
    func goToDailyCheckViewController() {
        //将字段存入本地，因为要在你要跳转的页面用它来判断
        let pushJudge = UserDefaults.standard
        pushJudge.set("push", forKey: "push")
        pushJudge.synchronize()
        
        let dailyCheckController = DailyCheckController(with: nil, channelID: 44)
        let dailyNav = BaseNavController(rootViewController: dailyCheckController)
        dailyNav.hidesBottomBarWhenPushed = true
        self.window?.rootViewController?.present(dailyNav, animated: true, completion: nil)
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
