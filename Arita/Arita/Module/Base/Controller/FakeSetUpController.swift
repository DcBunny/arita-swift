//
//  FakeSetUpController.swift
//  Arita
//
//  Created by 潘东 on 2017/11/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/// 日签启动页
class FakeSetUpController: BaseController {

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
    init(with imgUrl: String) {
        self.imgUrl = imgUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .none)
    }
    
    private func addPageViews() {
        view.addSubview(setUpImageView)
    }
    
    private func layoutPageViews() {
        setUpImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        setUpImageView.kf.setImage(with: URL(string: imgUrl))
    }
    
    // MARK: - Controller Attributes
    fileprivate var _setUpImageView: UIImageView?
    fileprivate var imgUrl: String!
}

// MARK: - Getters and Setters
extension FakeSetUpController {
    fileprivate var setUpImageView: UIImageView {
        if _setUpImageView == nil {
            _setUpImageView = UIImageView()
            
            return _setUpImageView!
        }
        
        return _setUpImageView!
    }
}
