//
//  MineChooseAvatarController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * ChooseAvatarDelegate **我的**页面选择头像回调代理
 */
protocol ChooseAvatarDelegate {
    func chooseAvatarController(at index: Int)
}

/**
 * MineChooseAvatarController **我的**页面选择头像主页
 */
class MineChooseAvatarController: BaseController {

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
    
    init(delegate: ChooseAvatarDelegate) {
        self.delegate = delegate
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
        view.addSubview(maskView)
        view.addSubview(backView)
        backView.addSubview(buttonOne)
        backView.addSubview(buttonTwo)
        backView.addSubview(cancelButton)
        backView.addSubview(seperatorView)
    }
    
    private func layoutPageViews() {
        maskView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(view)
            make.bottom.equalTo(backView.snp.top)
        }
        
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(maskView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
            make.height.equalTo(171)
        }

        buttonOne.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(backView)
            make.height.equalTo(55)
            make.bottom.equalTo(buttonTwo.snp.top)
        })
        
        seperatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.height.equalTo(1 / Size.screenScale)
            make.bottom.equalTo(buttonOne.snp.bottom)
        }
        
        buttonTwo.snp.makeConstraints({ (make) in
            make.left.right.equalTo(backView)
            make.top.equalTo(buttonOne.snp.bottom)
            make.height.equalTo(55)
            make.bottom.equalTo(cancelButton.snp.top).offset(-6)
        })
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(backView)
            make.top.equalTo(buttonTwo.snp.bottom).offset(6)
            make.height.equalTo(55)
            make.bottom.equalTo(backView)
        }
    }
    
    private func setPageViews() {
        let tapGestureDismiss = UITapGestureRecognizer(target: self, action: #selector(viewDismiss))
        maskView.backgroundColor = Color.hex000000Alpha50
        view.backgroundColor = UIColor.clear
        maskView.addGestureRecognizer(tapGestureDismiss)
        seperatorView.backgroundColor = Color.hexe4e4e4
    }
    
    // MARK: - Event Responses
    @objc fileprivate func chooseFromAlbum(sender: UIButton) {
        delegate.chooseAvatarController(at: 1)
    }
    
    @objc fileprivate func takePhotes(sender: UIButton) {
        delegate.chooseAvatarController(at: 0)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _backView: UIView?
    fileprivate var _buttonOne: UIButton?
    fileprivate var _buttonTwo: UIButton?
    fileprivate var _cancelButton: UIButton?
    fileprivate var seperatorView = UIView()
    fileprivate var maskView = UIView()
    var delegate: ChooseAvatarDelegate!
}

// MARK: - Getters and Setters
extension MineChooseAvatarController {
    fileprivate var backView: UIView {
        if _backView == nil {
            _backView = UIView()
            _backView?.backgroundColor = Color.hexf5f5f5
            
            return _backView!
        }
        
        return _backView!
    }
    
    fileprivate var buttonOne: UIButton {
        if _buttonOne == nil {
            _buttonOne = UIButton()
            _buttonOne?.backgroundColor = Color.hexffffff
            _buttonOne?.setTitleColor(Color.hex2a2a2a, for: .normal)
            _buttonOne?.setTitleColor(Color.hex2a2a2a, for: .highlighted)
            _buttonOne?.titleLabel?.font = Font.size16
            _buttonOne?.setTitle("拍一张照片", for: .normal)
            _buttonOne?.setTitle("拍一张照片", for: .highlighted)
            _buttonOne?.tag = 0
            _buttonOne?.addTarget(self, action: #selector(takePhotes(sender:)), for: .touchUpInside)
            
            return _buttonOne!
        }
        
        return _buttonOne!
    }
    
    fileprivate var buttonTwo: UIButton {
        if _buttonTwo == nil {
            _buttonTwo = UIButton()
            _buttonTwo?.setTitle("从相册选一张", for: .normal)
            _buttonTwo?.setTitle("从相册选一张", for: .highlighted)
            _buttonTwo?.setTitleColor(Color.hex2a2a2a, for: .normal)
            _buttonTwo?.setTitleColor(Color.hex2a2a2a, for: .highlighted)
            _buttonTwo?.backgroundColor = Color.hexffffff
            _buttonTwo?.titleLabel?.font = Font.size16
            _buttonTwo?.tag = 1
            _buttonTwo?.addTarget(self, action: #selector(chooseFromAlbum(sender:)), for: .touchUpInside)
            
            return _buttonTwo!
        }
        
        return _buttonTwo!
    }
    
    fileprivate var cancelButton: UIButton {
        if _cancelButton == nil {
            _cancelButton = UIButton()
            _cancelButton?.setTitle("取消", for: .normal)
            _cancelButton?.setTitle("取消", for: .highlighted)
            _cancelButton?.setTitleColor(Color.hex2a2a2a, for: .normal)
            _cancelButton?.setTitleColor(Color.hex2a2a2a, for: .highlighted)
            _cancelButton?.backgroundColor = Color.hexffffff
            _cancelButton?.titleLabel?.font = Font.size16
            _cancelButton?.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
            
            return _cancelButton!
        }
        
        return _cancelButton!
    }
}
