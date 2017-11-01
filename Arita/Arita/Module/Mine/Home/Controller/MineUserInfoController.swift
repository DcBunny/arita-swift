//
//  MineUserInfoController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import AliyunOSSiOS
import ALCameraViewController

/**
 * MineUserInfoController **用户信息**页面主页
 */
let AritaKeyWindow = UIApplication.shared.keyWindow ?? (UIApplication.shared.delegate as! AppDelegate).window
class MineUserInfoController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
        userInfoTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "我的", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(userInfoTableView)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(view).offset(6)
            ConstraintMaker.right.equalTo(view).offset(-6)
            ConstraintMaker.top.equalTo(view).offset(5)
            ConstraintMaker.bottom.equalTo(view).offset(-12)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        userInfoTableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(bodyView)
        }
    }
    
    private func setPageViews() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
    }
    
    fileprivate func prepareData() {
        infoArray = [UserManager.sharedInstance.getUserInfo()?.avatar,
                     UserManager.sharedInstance.getUserInfo()?.nickname,
                     UserManager.sharedInstance.getUserInfo()?.age,
                     UserManager.sharedInstance.getUserInfo()?.conste,
                     (UserManager.sharedInstance.getUserInfo()?.gender == 0 ? "男" : "女"),
                     UserManager.sharedInstance.getUserInfo()?.area]
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _userInfoTableView: UITableView?
    
    fileprivate var itemArray = ["头像", "昵称", "年龄", "星座", "性别", "地区"]
    fileprivate var infoArray: [String?] = []
}

// MARK: - TableView Data Source
extension MineUserInfoController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineUserInfoAvatarTableViewCell.self), for: indexPath) as! MineUserInfoAvatarTableViewCell
            cell.userAvatar = infoArray[indexPath.row]!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineUserInfoNormalTableViewCell.self), for: indexPath) as! MineUserInfoNormalTableViewCell
            cell.itemName = itemArray[indexPath.row]
            cell.infoName = infoArray[indexPath.row]!
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension MineUserInfoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DispatchQueue.main.async {
                let avatarController = MineChooseAvatarController(delegate: self)
                avatarController.delegate = self
                avatarController.modalTransitionStyle = .crossDissolve
                avatarController.providesPresentationContextTransitionStyle = true
                avatarController.definesPresentationContext = true
                avatarController.modalPresentationStyle = .overFullScreen
                self.present(avatarController, animated: true, completion: nil)
            }
            
        case 1:
            let modifiedNicknameController = MineNicknameController()
            navigationController?.pushViewController(modifiedNicknameController, animated: true)
            
        case 2, 3:
            DispatchQueue.main.async {
                let ageController = MineAgeController()
                ageController.backClosure = { [weak self] () -> Void in
                    guard let strongSelf = self else { return }
                    strongSelf.prepareData()
                    strongSelf.userInfoTableView.reloadData()
                }
                ageController.modalTransitionStyle = .crossDissolve
                ageController.providesPresentationContextTransitionStyle = true
                ageController.definesPresentationContext = true
                ageController.modalPresentationStyle = .overFullScreen
                self.present(ageController, animated: true, completion: nil)
            }
            
        case 4:
            let chooseSexController = MineSexChooseController()
            navigationController?.pushViewController(chooseSexController, animated: true)
            
        case 5:
            DispatchQueue.main.async {
                let addressController = MineAddressController()
                addressController.backClosure = { [weak self] () -> Void in
                    guard let strongSelf = self else { return }
                    strongSelf.prepareData()
                    strongSelf.userInfoTableView.reloadData()
                }
                addressController.modalTransitionStyle = .crossDissolve
                addressController.providesPresentationContextTransitionStyle = true
                addressController.definesPresentationContext = true
                addressController.modalPresentationStyle = .overFullScreen
                self.present(addressController, animated: true, completion: nil)
            }
            
        default:
            print("Impossible!")
        }
    }
}

extension MineUserInfoController: ChooseAvatarDelegate {
    func chooseAvatarController(at index: Int) {
        if index == 0 {
            print("照相")
        } else {
            print("选择相片")
        }
    }
}

// MARK: - Getters and Setters
extension MineUserInfoController {
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
    
    fileprivate var userInfoTableView: UITableView {
        if _userInfoTableView == nil {
            _userInfoTableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _userInfoTableView?.backgroundColor = Color.hexffffff!
            _userInfoTableView?.showsVerticalScrollIndicator = false
            _userInfoTableView?.separatorStyle = .none
            _userInfoTableView?.register(MineUserInfoAvatarTableViewCell.self, forCellReuseIdentifier: String(describing: MineUserInfoAvatarTableViewCell.self))
            _userInfoTableView?.register(MineUserInfoNormalTableViewCell.self, forCellReuseIdentifier: String(describing: MineUserInfoNormalTableViewCell.self))
            
            return _userInfoTableView!
        }
        
        return _userInfoTableView!
    }
}
