//
//  RegisterProtocolController.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/6.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import WebKit

class RegisterProtocolController: BaseController {

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
        setNaviBar(type: .normal)
        setNaviBar(title: ("用户协议"), font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(protocolView)
    }
    
    private func layoutPageViews() {
        protocolView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        let url = URL(string: "http://test.arita.cc/ios/protocol")
        let request = URLRequest(url: url!)
        protocolView.load(request)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _protocolView: WKWebView?
}

// MARK: - Getters and Setters
extension RegisterProtocolController {
    fileprivate var protocolView: WKWebView {
        if _protocolView == nil {
            _protocolView = WKWebView(frame: .zero)
            _protocolView?.backgroundColor = UIColor.clear
            _protocolView?.scrollView.showsVerticalScrollIndicator = false
            _protocolView?.scrollView.showsHorizontalScrollIndicator = false
        }
        
        return _protocolView!
    }
}
