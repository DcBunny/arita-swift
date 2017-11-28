//
//  MineHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 * MineHomeController **我的**页面主页
 */
class MineHomeController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        prepareData()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "我的", font: Font.size15)
        setBackBtn(.dismiss)
    }
    
    private func addPageViews() {
        view.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(mineTableView)
    }
    
    private func layoutPageViews() {
        if #available(iOS 11.0, *) {
            shadowView.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.equalTo(view).offset(6)
                ConstraintMaker.right.equalTo(view).offset(-6)
                ConstraintMaker.top.equalTo(view.safeAreaLayoutGuide).offset(5)
                ConstraintMaker.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            }
        } else {
            shadowView.snp.makeConstraints { (ConstraintMaker) in
                ConstraintMaker.left.equalTo(view).offset(6)
                ConstraintMaker.right.equalTo(view).offset(-6)
                ConstraintMaker.top.equalTo(view).offset(5)
                ConstraintMaker.bottom.equalTo(view).offset(-12)
            }
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        mineTableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(bodyView)
        }
    }
    
    private func setPageViews() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
        
        userInfoAPIManager.delegate = self
        userInfoAPIManager.paramSource = self
    }
    
    fileprivate func prepareData() {
        if UserManager.sharedInstance.isLogin() {
            iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting, Icon.logout]
            nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置", "退出登录"]
            userInfo = [UserManager.sharedInstance.currentUser!.userInfo!.avatar, UserManager.sharedInstance.currentUser!.userInfo!.nickname]
        } else {
            iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting]
            nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置"]
            userInfo = ["", "请登录"]
        }
    }
    
    // MARK: - Event Responses
    @objc fileprivate func userAvatarAction() {
        if UserManager.sharedInstance.isLogin() {
            let userInfoController = MineUserInfoController()
            navigationController?.pushViewController(userInfoController, animated: true)
        } else {
            let login = LoginController()
            navigationController?.pushViewController(login, animated: true)
        }
    }
    
    @objc fileprivate func userNameAction() {
        if UserManager.sharedInstance.isLogin() {
            let userInfoController = MineUserInfoController()
            navigationController?.pushViewController(userInfoController, animated: true)
        } else {
            let login = LoginController()
            navigationController?.pushViewController(login, animated: true)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func calculateHeight() -> CGFloat {
        return "请登录".sizeForFont(Font.size20!, size: CGSize(width: self.view.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail).height
    }
    
    fileprivate func loadData() {
        if UserManager.sharedInstance.isLogin() {
            userInfoAPIManager.loadData()
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _mineTableView: UITableView?
    
    fileprivate var iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting]
    fileprivate var nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置"]
    fileprivate var userInfo = ["", "请登录"]

    fileprivate var userInfoAPIManager = UserInfoAPIManager()
}

// MARK: - ONAPIManagerParamSource
extension MineHomeController: ONAPIManagerParamSource {
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["id": UserManager.sharedInstance.getUserInfo()?.userId as Any]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension MineHomeController: ONAPIManagerCallBackDelegate {
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let jsonString = JSON(data).rawString()
        let userInfo = UserInfo.deserialize(from: jsonString)
        UserManager.sharedInstance.updateUserInfo(userInfo: userInfo!)
        prepareData()
        mineTableView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - TableView Data Source
extension MineHomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 162 + calculateHeight() / 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineHomeTableViewCell.self), for: indexPath) as! MineHomeTableViewCell
        cell.leftIcon = iconArray[indexPath.row]
        cell.itemName = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MineHomeHeaderView.self)) as! MineHomeHeaderView
        header.userAvatar = userInfo[0]
        header.userName = userInfo[1]
        header.userButton.addTarget(self, action: #selector(userNameAction), for: .touchUpInside)
        header.userAvatarButton.addTarget(self, action: #selector(userAvatarAction), for: .touchUpInside)
        return header
    }
}

// MARK: - TableView Delegate
extension MineHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let aboutUsController = MineNormalController(isAboutUs: true)
            navigationController?.pushViewController(aboutUsController, animated: true)
            
        case 1:
            let mailUsController = MineNormalController(isAboutUs: false)
            navigationController?.pushViewController(mailUsController, animated: true)
            
        case 2:
            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id1125888897")!)
            
        case 3:
            DispatchQueue.main.async {
                let shareController = MineShareController()
                shareController.modalTransitionStyle = .crossDissolve
                shareController.providesPresentationContextTransitionStyle = true
                shareController.definesPresentationContext = true
                shareController.modalPresentationStyle = .overFullScreen
                self.present(shareController, animated: true, completion: nil)
            }
            
        case 4:
            let settingController = MineSettingController()
            navigationController?.pushViewController(settingController, animated: true)
            
        case 5:
            let alert = UIAlertController(title: "退出当前账号", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确认退出", style: .default, handler: { [weak self] _ in
                guard let strongSelf = self else { return }
                UserManager.sharedInstance.quit()
                strongSelf.prepareData()
                strongSelf.mineTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        default:
            print("Impossible!")
        }
    }
}

// MARK: - Getters and Setters
extension MineHomeController {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            _shadowView?.layer.shadowOpacity = 1.0
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var mineTableView: UITableView {
        if _mineTableView == nil {
            _mineTableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _mineTableView?.backgroundColor = Color.hexffffff!
            _mineTableView?.showsVerticalScrollIndicator = false
            _mineTableView?.separatorStyle = .none
            _mineTableView?.register(MineHomeTableViewCell.self, forCellReuseIdentifier: String(describing: MineHomeTableViewCell.self))
            _mineTableView?.register(MineHomeHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: MineHomeHeaderView.self))
            
            return _mineTableView!
        }
        
        return _mineTableView!
    }
}
