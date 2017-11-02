//
//  MineSexChooseController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 *  MineSexChooseController 选择性别的主页
 */
class MineSexChooseController: BaseController {

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
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .custom)
        setNaviBar(title: "性别", font: Font.size15)
        setNavi(leftIcon: UIImage(named: Icon.back)!, leftAction: #selector(pop), rightText: "保存", rightAction: #selector(save))
    }
    
    private func addPageViews() {
       view.addSubview(tableView)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = Color.hexf5f5f5
        tableView.delegate = self
        tableView.dataSource = self
        updateInfoAPIManager.delegate = self
        updateInfoAPIManager.paramSource = self
        
        if UserManager.sharedInstance.getUserInfo()?.gender == 0 {
            selectedState = [true, false]
        } else if UserManager.sharedInstance.getUserInfo()?.gender == 1 {
            selectedState = [false, true]
        }
    }
    
    // MARK: - Event Responses
    @objc private func save() {
        updateInfoAPIManager.loadData()
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var selectedState = [false, false]
    fileprivate var updateInfoAPIManager = UpdateUserInfoAPIManager()
}

// MARK: - ONAPIManagerParamSource
extension MineSexChooseController: ONAPIManagerParamSource {
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if (UserManager.sharedInstance.getUserInfo()?.userId != nil) && (UserManager.sharedInstance.getUserInfo()!.userId! > 0) {
            return ["id": UserManager.sharedInstance.getUserInfo()!.userId!,
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": (selectedState[0] == true) ? 0 : 1,
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            ]
        } else {
            return ["uid": UserManager.sharedInstance.getUserInfo()!.uid!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "gender": (selectedState[0] == true) ? 0 : 1,
                    "thirdType": UserManager.sharedInstance.getUserInfo()?.thirdType?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? 0,
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            ]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension MineSexChooseController: ONAPIManagerCallBackDelegate {
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        UserManager.sharedInstance.updateUserSex(sex: (selectedState[0] == true) ? 0 : 1)
        navigationController?.popViewController(animated: true)
        ONTipCenter.showToast("更新用户性别成功")
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        ONTipCenter.showToast("更新用户性别失败，请稍候再试")
    }
}

// MARK: - TableView Data Source
extension MineSexChooseController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineSexChooseTableViewCell.self), for: indexPath) as! MineSexChooseTableViewCell
        if indexPath.row == 1 {
            cell.isLast = true
        } else {
            cell.isLast = false
        }
        cell.lableText = ["男", "女"][indexPath.row]
        cell.isIconHidden = !selectedState[indexPath.row]
        return cell
    }
}

// MARK: - TableView Delegate
extension MineSexChooseController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectedState = [true, false]
        } else {
            selectedState = [false, true]
        }
        tableView.reloadData()
    }
}

// MARK: - Getters and Setters
extension MineSexChooseController {
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView()
            _tableView?.showsHorizontalScrollIndicator = false
            _tableView?.register(MineSexChooseTableViewCell.self, forCellReuseIdentifier: String(describing: MineSexChooseTableViewCell.self))
            _tableView?.backgroundColor = Color.hexf5f5f5!
            _tableView?.separatorStyle = .none
            _tableView?.isScrollEnabled = false
            
            return _tableView!
        }
        
        return _tableView!
    }
}
