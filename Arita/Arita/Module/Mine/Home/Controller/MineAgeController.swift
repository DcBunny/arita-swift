//
//  MineAgeController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/30.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

typealias ChangedAgeCallback = () -> Void
/**
 *  选择生日主页
 */
class MineAgeController: BaseController {

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
        setNaviBar(type: .none)
    }
    
    private func addPageViews() {
        view.addSubview(maskView)
        view.addSubview(toolBar)
        view.addSubview(datePickerView)
    }
    
    private func layoutPageViews() {
        maskView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(maskView.snp.bottom)
            make.height.equalTo(44)
            make.bottom.equalTo(datePickerView.snp.top)
        }
        
        datePickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(toolBar.snp.bottom)
            make.height.equalTo(256)
        }
    }
    
    private func setPageViews() {
        updateInfoAPIManager.delegate = self
        updateInfoAPIManager.paramSource = self
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        maskView.backgroundColor = Color.hex000000Alpha50
        maskView.addGestureRecognizer(tapGestureDismiss)
        view.backgroundColor = UIColor.clear
//        if let date = UserManager.sharedInstance.getUserInfo()?.birthdayDate {
//            datePickerView.date = date
//        } else {
//            datePickerView.date = Date()
//        }
    }
    
    // MARK: - Event Responses
    @objc fileprivate func datePickerCancel() {
        viewDismiss()
    }
    
    @objc fileprivate func datePickerSure() {
        (currentAge, currentXingzuo) = convertToAgeAndConstellation(with: choosedDate)
        updateInfoAPIManager.loadData()
    }
    
    @objc fileprivate func chooseDate(_ datePicker: UIDatePicker) {
        choosedDate = datePicker.date
    }
    
    // MARK: - Private Methods
    private func convertToAgeAndConstellation(with date: Date) -> (String, String) {
        let currentXingzuo = Constellation.calculateWithDate(date: date)
        let currentAge = Constellation.ageWithDateOfBirth(date: date)
        return (currentAge, currentXingzuo)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _datePickerView: UIDatePicker?
    fileprivate var _toolBar: UIToolbar?
    fileprivate var maskView = UIView()
    fileprivate var choosedDate = UserManager.sharedInstance.getUserInfo()?.birthdayDate ?? Date()
    fileprivate var currentAge = ""
    fileprivate var currentXingzuo = ""
    var backClosure: ChangedAgeCallback?
    fileprivate var updateInfoAPIManager = UpdateUserInfoAPIManager()
}

// MARK: - ONAPIManagerParamSource
extension MineAgeController: ONAPIManagerParamSource {
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if (UserManager.sharedInstance.getUserInfo()?.userId != nil) && (UserManager.sharedInstance.getUserInfo()!.userId! > 0) {
            return ["id": UserManager.sharedInstance.getUserInfo()!.userId!,
                    "age": currentAge.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "xingzuo": currentXingzuo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": UserManager.sharedInstance.getUserInfo()?.gender ?? 0
            ]
        } else {
            return ["uid": UserManager.sharedInstance.getUserInfo()!.uid!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "age": currentAge.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "xingzuo": currentXingzuo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": UserManager.sharedInstance.getUserInfo()?.gender ?? 0,
                    "thirdType": UserManager.sharedInstance.getUserInfo()?.thirdType?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? 0,
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            ]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension MineAgeController: ONAPIManagerCallBackDelegate {
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        UserManager.sharedInstance.updateUserAgeAndConste(age: currentAge, conste: currentXingzuo, birthdayDate: choosedDate)
        viewDismiss()
        if self.backClosure != nil {
            self.backClosure!()
        }
        ONTipCenter.showToast("更新用户年龄星座成功")
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        ONTipCenter.showToast("更新用户年龄星座失败，请稍候再试")
    }
}

// MARK: - Getters and Setters
extension MineAgeController {
    fileprivate var datePickerView: UIDatePicker {
        if _datePickerView == nil {
            _datePickerView = UIDatePicker()
            _datePickerView?.datePickerMode = .date
            _datePickerView?.addTarget(self, action: #selector(chooseDate(_:)), for: .valueChanged)
            _datePickerView?.backgroundColor = UIColor.white
            _datePickerView?.date = choosedDate
            
            return _datePickerView!
        }
        
        return _datePickerView!
    }
    
    fileprivate var toolBar: UIToolbar {
        if _toolBar == nil {
            _toolBar = UIToolbar()
            let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(datePickerCancel))
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let sureItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(datePickerSure))
            _toolBar?.items = [cancelItem, flexibleItem, sureItem]
            _toolBar?.barTintColor = APDefaultBarTintColor
            _toolBar?.tintColor = APDefaultTintColor
            
            return _toolBar!
        }
        
        return _toolBar!
    }
}
