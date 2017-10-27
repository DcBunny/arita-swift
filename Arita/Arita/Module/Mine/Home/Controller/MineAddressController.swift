//
//  MineAddressController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

typealias ChoosedLocation = (Location) -> Void
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
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        maskView.backgroundColor = Color.hex000000Alpha50
        maskView.addGestureRecognizer(tapGestureDismiss)
        view.backgroundColor = UIColor.clear
        myLocate.province = "北京市"
        myLocate.city = "东城区"
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
    var backClosure: ChoosedLocation?
}

extension MineAddressController: AreaPickerViewDelegate {
    func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, locate: Location) {
        
    }
    
    func sure(areaPickerView: AreaPickerView, locate: Location) {
        viewDismiss()
        if self.backClosure != nil {
            self.backClosure!(locate)
        }
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
