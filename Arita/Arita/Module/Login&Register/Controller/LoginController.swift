//
//  LoginController.swift
//  Arita
//
//  Created by DcBunny on 2017/10/30.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        setAPIManager()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: ("登录"), font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(backGroundView)
        view.addSubview(loginView)
        
        loginView.addSubview(userNameView)
        userNameView.addSubview(userNameIcon)
        userNameView.addSubview(userNameText)
        
        loginView.addSubview(pwdView)
        pwdView.addSubview(pwdIcon)
        pwdView.addSubview(pwdText)
        
        loginView.addSubview(loginButton)
        loginView.addSubview(tipsLabel)
        loginView.addSubview(tipsButton)
        loginView.addSubview(logo)
    }
    
    private func layoutPageViews() {
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        loginView.snp.makeConstraints { (make) in
            make.center.equalTo(backGroundView)
            make.size.equalTo(CGSize(width: 320, height: 450))
        }
        
        userNameView.snp.makeConstraints { (make) in
            make.top.equalTo(loginView).offset(40)
            make.centerX.equalTo(loginView)
            make.size.equalTo(CGSize(width: 225, height: 44))
        }
        
        userNameIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(userNameView)
            make.left.equalTo(userNameView).offset(13)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        userNameText.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(userNameView)
            make.left.equalTo(userNameIcon.snp.right).offset(15)
            make.right.equalTo(userNameView).offset(-13)
        }
        
        pwdView.snp.makeConstraints { (make) in
            make.top.equalTo(userNameView.snp.bottom).offset(15)
            make.centerX.equalTo(loginView)
            make.size.equalTo(CGSize(width: 225, height: 44))
        }
        
        pwdIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(pwdView)
            make.left.equalTo(pwdView).offset(13)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        pwdText.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(pwdView)
            make.left.equalTo(pwdIcon.snp.right).offset(15)
            make.right.equalTo(pwdView).offset(-13)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom).offset(30)
            make.centerX.equalTo(loginView)
            make.size.equalTo(CGSize(width: 100, height: 44))
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.right.equalTo(loginButton.snp.centerX).offset(5)
        }
        
        tipsButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(tipsLabel)
            make.left.equalTo(tipsLabel.snp.right)
            make.width.equalTo(50)
        }
        
        logo.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 49, height: 49))
            make.top.equalTo(tipsLabel.snp.bottom).offset(30)
            make.centerX.equalTo(loginView)
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = Color.hexf5f5f5
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        tipsButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }
    
    private func setAPIManager() {
        loginManager.paramSource = self
        loginManager.delegate = self
    }
    
    @objc private func login() {
        loginManager.loadData()
    }
    
    @objc private func register() {
        print("register")
    }
    
    // MARK: - Controller Attributes
    fileprivate var _backGroundView: UIImageView?
    fileprivate var _loginView: UIView?
    
    fileprivate var _userNameView: UIView?
    fileprivate var _userNameIcon: UIImageView?
    fileprivate var _userNameText: UITextField?
    
    fileprivate var _pwdView: UIView?
    fileprivate var _pwdIcon: UIImageView?
    fileprivate var _pwdText: UITextField?
    
    fileprivate var _loginButton: UIButton?
    
    fileprivate var _tipsLabel: UILabel?
    fileprivate var _tipsButton: UIButton?
    
    fileprivate var _logo: UIImageView?
    
    fileprivate var _loginManager: LoginAPIManager?
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension LoginController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return [
            "cellphone": userNameText.text!,
            "password": pwdText.text!
        ]
    }
}

extension LoginController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        
        let loginInfo = LoginInfo(username: userNameText.text!, password: pwdText.text!)
        UserManager.sharedInstance.setCurrentUser(loginInfo: loginInfo)
        let authInfo = AuthInfo(token: json.stringValue)
        UserManager.sharedInstance.setAuthData(authInfo: authInfo)
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension LoginController {
    fileprivate var backGroundView: UIImageView {
        if _backGroundView == nil {
            _backGroundView = UIImageView()
            _backGroundView?.backgroundColor = UIColor.init(patternImage: UIImage(named: Icon.background)!)
            
            return _backGroundView!
        }
        
        return _backGroundView!
    }
    
    fileprivate var loginView: UIView {
        if _loginView == nil {
            _loginView = UIView()
            _loginView?.backgroundColor = UIColor.white
            _loginView?.layer.cornerRadius = 5
            _loginView?.layer.masksToBounds = true
        }
        
        return _loginView!
    }
    
    fileprivate var userNameView: UIView {
        if _userNameView == nil {
            _userNameView = UIView()
            _userNameView?.backgroundColor = UIColor.white
            _userNameView?.layer.cornerRadius = 20
            _userNameView?.layer.masksToBounds = true
            _userNameView?.layer.borderWidth = 1
            _userNameView?.layer.borderColor = Color.hexe4e4e4?.cgColor
        }
        
        return _userNameView!
    }
    
    fileprivate var userNameIcon: UIImageView {
        if _userNameIcon == nil {
            _userNameIcon = UIImageView()
            _userNameIcon?.image = UIImage(named: Icon.userNameIcon)
        }
        
        return _userNameIcon!
    }
    
    fileprivate var userNameText: UITextField {
        if _userNameText == nil {
            _userNameText = UITextField()
            _userNameText?.font = Font.size14
            _userNameText?.textColor = Color.hex2a2a2a
            _userNameText?.placeholder = "输入你的手机号"
            _userNameText?.clearButtonMode = .whileEditing
        }
        
        return _userNameText!
    }
    
    fileprivate var pwdView: UIView {
        if _pwdView == nil {
            _pwdView = UIView()
            _pwdView?.backgroundColor = UIColor.white
            _pwdView?.layer.cornerRadius = 20
            _pwdView?.layer.masksToBounds = true
            _pwdView?.layer.borderWidth = 1
            _pwdView?.layer.borderColor = Color.hexe4e4e4?.cgColor
        }
        
        return _pwdView!
    }
    
    fileprivate var pwdIcon: UIImageView {
        if _pwdIcon == nil {
            _pwdIcon = UIImageView()
            _pwdIcon?.image = UIImage(named: Icon.pwdIcon)
        }
        
        return _pwdIcon!
    }
    
    fileprivate var pwdText: UITextField {
        if _pwdText == nil {
            _pwdText = UITextField()
            _pwdText?.font = Font.size14
            _pwdText?.textColor = Color.hex2a2a2a
            _pwdText?.placeholder = "输入你的密码"
            _pwdText?.clearButtonMode = .whileEditing
        }
        
        return _pwdText!
    }
    
    fileprivate var loginButton: UIButton {
        if _loginButton == nil {
            _loginButton = UIButton()
            _loginButton?.layer.cornerRadius = 20
            _loginButton?.backgroundColor = Color.hexea9120
            _loginButton?.setTitle("登录", for: .normal)
            _loginButton?.titleLabel?.font = Font.size16
        }
        
        return _loginButton!
    }
    
    fileprivate var tipsLabel: UILabel {
        if _tipsLabel == nil {
            _tipsLabel = UILabel()
            _tipsLabel?.font = Font.size12
            _tipsLabel?.textColor = Color.hex919191
            _tipsLabel?.text = "还没有账号？"
        }
        
        return _tipsLabel!
    }
    
    fileprivate var tipsButton: UIButton {
        if _tipsButton == nil {
            _tipsButton = UIButton()
            _tipsButton?.setTitle("点击注册", for: .normal)
            _tipsButton?.setTitleColor(Color.hexea9120, for: .normal)
            _tipsButton?.titleLabel?.font = Font.size12
        }
        
        return _tipsButton!
    }
    
    fileprivate var logo: UIImageView {
        if _logo == nil {
            _logo = UIImageView()
            _logo?.image = UIImage(named: Icon.loginLogo)
        }
        
        return _logo!
    }
    
    fileprivate var loginManager: LoginAPIManager {
        if _loginManager == nil {
            _loginManager = LoginAPIManager()
        }
        
        return _loginManager!
    }
}
