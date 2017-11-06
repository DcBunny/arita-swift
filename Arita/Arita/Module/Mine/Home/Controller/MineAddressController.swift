//
//  MineAddressController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

typealias ChangedLocationCallback = () -> Void
/**
 *  日期选择器主页
 */
class MineAddressController: BaseController {

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
        view.addSubview(areaPickerView)
    }
    
    private func layoutPageViews() {
        maskView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(areaPickerView.snp.top)
        }
        
        areaPickerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(maskView.snp.bottom)
            make.height.equalTo(300)
        }
    }
    
    private func setPageViews() {
        updateInfoAPIManager.delegate = self
        updateInfoAPIManager.paramSource = self
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        maskView.backgroundColor = Color.hex000000Alpha50
        maskView.addGestureRecognizer(tapGestureDismiss)
        view.backgroundColor = UIColor.clear
        let areaDetails = UserManager.sharedInstance.getUserInfo()?.area.split(separator: " ")
        if areaDetails != nil && areaDetails!.count >= 2 {
            myLocate.province = String(areaDetails![0])
            myLocate.city = String(areaDetails![1])
        } else {
            myLocate.province = "北京市"
            myLocate.city = "东城区"
        }
        areaPickerView.shouldSelected(proName: myLocate.province, cityName: myLocate.city)
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _areaPickerView: AreaPickerView?
    fileprivate var maskView = UIView()
    lazy var myLocate: Location = {
        return Location()
    }()
    var backClosure: ChangedLocationCallback?
    fileprivate var updateInfoAPIManager = UpdateUserInfoAPIManager()
}

// MARK: - ONAPIManagerParamSource
extension MineAddressController: ONAPIManagerParamSource {
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if (UserManager.sharedInstance.getUserInfo()?.userId != nil) && (UserManager.sharedInstance.getUserInfo()!.userId! > 0) {
            return ["id": UserManager.sharedInstance.getUserInfo()!.userId!,
                    "area": (myLocate.province + " " + myLocate.city).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": UserManager.sharedInstance.getUserInfo()?.gender ?? 0
            ]
        } else {
            return ["uid": UserManager.sharedInstance.getUserInfo()!.uid!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "area": (myLocate.province + " " + myLocate.city).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "gender": UserManager.sharedInstance.getUserInfo()?.gender ?? 0,
                    "thirdType": UserManager.sharedInstance.getUserInfo()?.thirdType?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? 0,
                    "nickname": UserManager.sharedInstance.getUserInfo()?.nickname.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
            ]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension MineAddressController: ONAPIManagerCallBackDelegate {
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        UserManager.sharedInstance.updateUserArea(area: myLocate.province + " " + myLocate.city)
        viewDismiss()
        if self.backClosure != nil {
            self.backClosure!()
        }
        ONTipCenter.showToast("更新用户地区成功")
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        ONTipCenter.showToast("更新用户地区失败，请稍候再试")
    }
}

extension MineAddressController: AreaPickerViewDelegate {
    func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, locate: Location) {
        
    }
    
    func sure(areaPickerView: AreaPickerView, locate: Location) {
        myLocate.province = locate.province
        myLocate.city = locate.city
        updateInfoAPIManager.loadData()
    }
    
    func cancel(areaPickerView: AreaPickerView, locate: Location) {
        viewDismiss()
    }
}

// MARK: - Getters and Setters
extension MineAddressController {
    fileprivate var areaPickerView: AreaPickerView {
        if _areaPickerView == nil {
            _areaPickerView = AreaPickerView(delegate: self)
            
            return _areaPickerView!
        }
        
        return _areaPickerView!
    }
}
