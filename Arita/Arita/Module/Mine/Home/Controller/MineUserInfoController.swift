//
//  MineUserInfoController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineUserInfoController **用户信息**页面主页
 */
class MineUserInfoController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
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
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _userInfoTableView: UITableView?
    
    fileprivate var itemArray = ["头像", "昵称", "年龄", "星座", "性别", "地区"]
    fileprivate var infoArray = ["胡歌", "35", "巨蟹座", "男", "重庆 渝中区"]
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
            cell.userAvatar = "https://gss3.bdstatic.com/7Po3dSag_xI4khGkpoWK1HF6hhy/baike/c0%3Dbaike220%2C5%2C5%2C220%2C73/sign=1cdd55c9dd62853586edda73f1861da3/b2de9c82d158ccbfeb0c9a0111d8bc3eb135415c.jpg"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineUserInfoNormalTableViewCell.self), for: indexPath) as! MineUserInfoNormalTableViewCell
            cell.itemName = itemArray[indexPath.row]
            cell.infoName = infoArray[indexPath.row - 1]
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension MineUserInfoController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
