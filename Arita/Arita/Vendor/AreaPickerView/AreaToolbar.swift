//
//  AreaToolbar.swift
//  test
//
//  Created by quan on 2017/1/12.
//  Copyright © 2017年 langxi.Co.Ltd. All rights reserved.
//

import UIKit

protocol AreaToolbarDelegate: class {
    func sure(areaToolbar: AreaToolbar, item: UIBarButtonItem)
    func cancel(areaToolbar: AreaToolbar, item: UIBarButtonItem)
}


class AreaToolbar: UIToolbar {
    
   weak var barDelegate: AreaToolbarDelegate?
    
    init(_ delegate: AreaToolbarDelegate){
        self.barDelegate = delegate
        super.init(frame: CGRect(x: 0, y: 0, width: APMAIN_WIDTH, height: 44))
        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(areaPickerCancel(_:)))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let sureItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(areaPickerSure(_:)))
        self.items = [cancelItem, flexibleItem, sureItem]
        
        self.barTintColor = APDefaultBarTintColor
        self.tintColor = APDefaultTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func areaPickerCancel(_ item: UIBarButtonItem) {
        barDelegate?.cancel(areaToolbar: self, item: item)
    }
    
    func areaPickerSure(_ item: UIBarButtonItem) {
        barDelegate?.sure(areaToolbar: self, item: item)
    }
}
