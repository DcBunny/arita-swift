//
//  UserManager.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import Foundation
import HandyJSON
import SwiftyJSON

// 用户信息类
struct UserInfo: HandyJSON {
    var userId: Int?
    var uid: String?
    var thirdType: String?
    var birthdayDate: Date?
    var username = ""
    var nickname = ""
    var avatar = ""
    var conste = ""
    var cellPhone = ""
    var gender = 0 // 0男1女
    var password = ""
    var area = ""
    var age = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.userId <-- "ID"
        mapper <<<
            self.thirdType <-- "thirdtype"
        mapper <<<
            self.avatar <-- "head_img"
        mapper <<<
            self.conste <-- "xingzuo"
        mapper <<<
            self.cellPhone <-- "cellphone"
    }
}

// 登录信息类
struct LoginInfo: HandyJSON {
    var username = ""
    var password = ""
//    var lastLoginTime = 0.0
}

// 认证信息类
struct AuthInfo: HandyJSON {
    var token: String?
//    var session: String?
//    var secret: String?
}

// 用户信息类
struct UserModel: HandyJSON {
    var loginInfo: LoginInfo?
    var authInfo: AuthInfo?
    var userInfo: UserInfo?
}

// 搜索关键字
struct SearchHistoryKeyword {
    var keywords: [String] = []
}

// 用户信息管理类
class UserManager {
    private let kCurrentUserId = "kCurrentUserId"
    private let kKeywords = "SearchKeywords"
    
    private let kUserInfo = "kUserInfo"
    
    //MARK: - life cycle
    static let sharedInstance = UserManager()
    
    public var currentUser: UserModel?
    public var historyKeyword = SearchHistoryKeyword()

    let loginAPIManager = LoginAPIManager()
    
    private init() {
        // 读取当前用户名
        if let userId = UserDefaults.standard.object(forKey: kCurrentUserId) {
            let cacheManager = UserCacheManager.sharedInstance
            cacheManager.setUserName(userId as! String)
            readInfoFromLocal()
            readKeywordsFromLocal()
        } else {
            currentUser = nil
        }
    }
    
    //MARK: - 信息相关
    // 设置当前用户
    func setCurrentUser(loginInfo: LoginInfo) {
        currentUser = UserModel()
        currentUser?.authInfo = AuthInfo()
        currentUser?.loginInfo = loginInfo
        currentUser?.userInfo = UserInfo()
        
        let cacheManager = UserCacheManager.sharedInstance
        cacheManager.setUserName(loginInfo.username)
        
        UserDefaults.standard.set(loginInfo.username, forKey: kCurrentUserId)
        UserDefaults.standard.synchronize()
        saveInfoToLocal()
    }
    
    func getUserInfo() -> UserInfo? {
        return currentUser?.userInfo
    }
    
    func getCurrentUser() -> UserModel? {
        return currentUser
    }
    
    func updateUserAvatar(avatar: String) {
        currentUser?.userInfo?.avatar = avatar
        
        saveInfoToLocal()
    }
    
    func updateUserSex(sex: Int) {
        currentUser?.userInfo?.gender = sex
        
        saveInfoToLocal()
    }
    
    func updateUserAgeAndConste(age: String, conste: String, birthdayDate: Date) {
        currentUser?.userInfo?.age = age
        currentUser?.userInfo?.conste = conste
        currentUser?.userInfo?.birthdayDate = birthdayDate
        
        saveInfoToLocal()
    }
    
    func updateUserNickname(nickname: String) {
        currentUser?.userInfo?.nickname = nickname
        
        saveInfoToLocal()
    }
    
    func updateUserArea(area: String) {
        currentUser?.userInfo?.area = area
        
        saveInfoToLocal()
    }
    
    func setAuthData(authInfo: AuthInfo) {
//        currentUser?.authInfo?.session = authInfo.session
        currentUser?.authInfo?.token = authInfo.token
        
        saveInfoToLocal()
    }
    
    func updateAuthData(session: String, token: String, secret: String) {
//        currentUser?.authInfo?.session = session
        currentUser?.authInfo?.token = token
//        currentUser?.authInfo?.secret = secret
        saveInfoToLocal()
    }
    
    func getAuthData() -> AuthInfo? {
        return currentUser?.authInfo
    }
    
    func updateUserInfo(userInfo: UserInfo) {
        currentUser?.userInfo = userInfo
        saveInfoToLocal()
    }

    //MARK: - 数据操作相关
    func isLogin() -> Bool {
        return currentUser == nil ? false : true
    }
    
    func quit() {
        deleteLocalInfo()
        currentUser = nil
    }
    
    func addKeyword(keyword: String) {
        let index = historyKeyword.keywords.index(of: keyword)
        if index != nil {
            historyKeyword.keywords.remove(at: index!)
        }
        historyKeyword.keywords.insert(keyword, at: 0)
        
        saveKeywordsToLocal()
    }
    
    func cleanKeyword() {
        historyKeyword.keywords = []
        deleteLocalKeywords()
    }
    
    //MARK: - private method
    private func readInfoFromLocal() {
        let syncCache = UserCacheManager.sharedInstance.syncCache
        if let jsonString: String = syncCache?.object(kUserInfo) {
            let aesde = jsonString.aesDecryptFromBase64("passw0rd".md5String()!)
            currentUser = UserModel.deserialize(from: aesde)
        }
    }
    
    private func saveInfoToLocal() {
        if let jsonString = currentUser?.toJSONString() {
            let aes = jsonString.aesEncrypt("passw0rd".md5String()!)?.base64EncodedString()
            UserCacheManager.sharedInstance.syncCache?.add(kUserInfo, object: aes!)
        }
    }
    
    private func deleteLocalInfo() {
        UserDefaults.standard.removeObject(forKey: kCurrentUserId)
        UserDefaults.standard.synchronize()
    }
    
    private func readKeywordsFromLocal() {
        if let keywords = UserDefaults.standard.stringArray(forKey: kKeywords) {
           historyKeyword.keywords = keywords
        }
    }
    
    private func saveKeywordsToLocal() {
        UserDefaults.standard.set(historyKeyword.keywords, forKey: kKeywords)
        UserDefaults.standard.synchronize()
    }
    
    private func deleteLocalKeywords() {
        UserDefaults.standard.removeObject(forKey: kKeywords)
        UserDefaults.standard.synchronize()
    }
}
