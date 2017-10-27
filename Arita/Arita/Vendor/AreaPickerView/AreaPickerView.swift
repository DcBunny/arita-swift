//
//  NewAreaPickerView.swift
//  test
//
//  Created by quan on 2017/1/12.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import UIKit

let stateKey = "state"
let citiesKey = "cities"
let cityKey = "city"

let APDefaultBarTintColor = Color.hexf5f5f5!
let APDefaultTintColor = Color.hex2a2a2a!
///屏幕宽度
let APMAIN_WIDTH: CGFloat = {
    UIScreen.main.bounds.size.width
}()

enum PickerType: Int {
    case province
    case city
}

protocol AreaPickerViewDelegate: class {
    func statusChanged(areaPickerView: AreaPickerView, pickerView: UIPickerView, locate: Location)
    func sure(areaPickerView: AreaPickerView, locate: Location)
    func cancel(areaPickerView: AreaPickerView, locate: Location)
}

class AreaPickerView: UIView {
    
    var cities = [[String: AnyObject]]()
    var pickerView = UIPickerView()
    var toolbar: AreaToolbar!
    weak var delegate: AreaPickerViewDelegate?
    
    init(delegate: AreaPickerViewDelegate ){
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        backgroundColor = Color.hexffffff
        
        toolbar = AreaToolbar(self)
        
        addSubview(pickerView)
        addSubview(toolbar)
        pickerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(300 - toolbar.bounds.size.height)
            make.top.equalTo(toolbar.snp.bottom)
        }
        toolbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(pickerView.snp.top)
            make.left.top.right.equalTo(self)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        cities = self.provinces[0][citiesKey] as! [[String : AnyObject]]!
        if let province = self.provinces[0][stateKey] as? String {
            self.locate.province = province
        }
        
        if let city = self.cities[0][cityKey] as? String {
            self.locate.city = city
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldSelected(proName: String, cityName: String) {
        
        for index in 0..<provinces.count {
            let pro = provinces[index]
            if pro[stateKey] as! String == proName {
                cities = provinces[index][citiesKey] as! [[String : AnyObject]]!
                if let province = provinces[index][stateKey] as? String {
                    locate.province = province
                }
                pickerView.selectRow(index, inComponent: PickerType.province.rawValue, animated: false)
                break
            }
        }
        
        for index in 0..<cities.count {
            let city = cities[index]
            //            print("城市的名称是\(city[cityKey])")
            if city[cityKey] as! String == cityName {
                if let city = cities[index][cityKey] as? String {
                    locate.city = city
                }
                
                pickerView.selectRow(index, inComponent: PickerType.city.rawValue, animated: false)
                break
            }
        }
    }
    
    
    func setCode(provinceName: String, cityName: String){
        
        let url = Bundle.main.url(forResource: "addressCode", withExtension: nil)
        let data = try! Data(contentsOf: url!)
        let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
        let provinces = dict["p"] as! [[String: AnyObject]]
        
        for pro in provinces {
            if pro["n"] as! String == provinceName {
                if let proCode = pro["v"] as? String {
                    locate.provinceCode = proCode //找到省编号
                }
                
                
                var foundCity = false
                for city in pro["c"] as! [[String: AnyObject]] {
                    if city["n"] as! String == cityName {
                        if let cityCode = city["v"] as? String {
                            locate.cityCode = cityCode  //找到城市编码
                        }
                        foundCity = true
                    }
                }
                
                //如果第二层没有找到相应的城市.那就是直辖市了,要重新找
                if !foundCity {
                    for city in pro["c"] as! [[String: AnyObject]] {
                        let areas = city["d"] as! [[String: String]] //直接查找三级区域
                        for area in areas {
                            if area["n"] == cityName {
                                locate.areaCode = area["v"]!
                                if let cityCode = city["v"] as? String {
                                    locate.cityCode = cityCode
                                }
                                break
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: - lazy
    lazy var provinces: [[String: AnyObject]] = {
        let path = Bundle.main.path(forResource: "area", ofType: "plist")
        return NSArray(contentsOfFile: path!) as! [[String: AnyObject]]
    }()
    
    lazy var locate: Location = {
        return Location()
    }()
}

extension AreaPickerView: AreaToolbarDelegate {
    func sure(areaToolbar: AreaToolbar, item: UIBarButtonItem) {
        delegate?.sure(areaPickerView: self, locate: locate)
    }
    
    func cancel(areaToolbar: AreaToolbar, item: UIBarButtonItem) {
        delegate?.cancel(areaPickerView: self, locate: locate)
    }
}

extension AreaPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            return provinces.count
        case .city:
            return cities.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            return provinces[row][stateKey] as! String?
        case .city:
            return cities[row][cityKey] as! String?
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        print("选中了某一行")
        let pickerType = PickerType(rawValue: component)!
        switch pickerType {
        case .province:
            cities = provinces[row][citiesKey] as! [[String : AnyObject]]!
            pickerView.reloadComponent(PickerType.city.rawValue)
            pickerView.selectRow(0, inComponent: PickerType.city.rawValue, animated: true)
            reloadAreaComponent(pickerView: pickerView, row: 0)
            if let province = provinces[row][stateKey] as? String {
                locate.province = province
                locate.city = cities[0][cityKey] as! String
            }
        case .city:
            reloadAreaComponent(pickerView: pickerView, row: row)
            setCode(provinceName: locate.province, cityName: locate.city)
            delegate?.statusChanged(areaPickerView: self, pickerView: pickerView, locate: locate)
        }
    }
    
    func reloadAreaComponent(pickerView: UIPickerView, row: Int) {
        
        guard row <= cities.count - 1 else {
            return
        }
        
        if let city = cities[row][cityKey] as? String {
            locate.city = city
        }
    }
}




