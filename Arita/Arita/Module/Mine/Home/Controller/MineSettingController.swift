//
//  MineSettingController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineSettingController **设置**页面主页
 */
class MineSettingController: BaseController {

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
        setNaviBar(title: "设置", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(userInfoTableView)
    }
    
    private func layoutPageViews() {
        userInfoTableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
    }
    
    // MARK: - Event Responses
    @objc fileprivate func switchAction(sender: UISwitch) {
        if sender.isOn {
            print("打开了")
        } else {
            print("关闭了")
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _userInfoTableView: UITableView?
    
    fileprivate var itemArray = ["清空缓存", "开启推送"]
    fileprivate var infoArray = ["已缓存 24M", "35"]
}

// MARK: - TableView Data Source
extension MineSettingController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineUserInfoNormalTableViewCell.self), for: indexPath) as! MineUserInfoNormalTableViewCell
            cell.itemName = itemArray[0]
            cell.infoName = infoArray[0]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineNotificationTableViewCell.self), for: indexPath) as! MineNotificationTableViewCell
            cell.itemName = itemArray[1]
            cell.switchButton.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension MineSettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("清理缓存")
        }
    }
}

// MARK: - Getters and Setters
extension MineSettingController {
    fileprivate var userInfoTableView: UITableView {
        if _userInfoTableView == nil {
            _userInfoTableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _userInfoTableView?.backgroundColor = Color.hexffffff!
            _userInfoTableView?.showsVerticalScrollIndicator = false
            _userInfoTableView?.separatorStyle = .none
            _userInfoTableView?.register(MineNotificationTableViewCell.self, forCellReuseIdentifier: String(describing: MineNotificationTableViewCell.self))
            _userInfoTableView?.register(MineUserInfoNormalTableViewCell.self, forCellReuseIdentifier: String(describing: MineUserInfoNormalTableViewCell.self))
            
            return _userInfoTableView!
        }
        
        return _userInfoTableView!
    }
}

