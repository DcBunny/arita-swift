//
//  MineNicknameController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 *  修改昵称主页
 */
class MineNicknameController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateHeight()
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
        setNaviBar(type: .custom)
        setNaviBar(title: "昵称", font: Font.size15)
        setNavi(leftIcon: UIImage(named: Icon.back)!, leftAction: #selector(pop), rightText: "保存", rightAction: #selector(save))
    }
    
    private func addPageViews() {
        view.addSubview(textView)
        view.addSubview(clearButton)
        view.addSubview(seperatorView)
    }
    
    private func layoutPageViews() {
        textView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.greaterThanOrEqualTo(55)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-25)
            make.centerY.equalTo(textView)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(1 / Size.screenScale)
        }
    }
    
    private func setPageViews() {
        updateInfoAPIManager.delegate = self
        updateInfoAPIManager.paramSource = self
        view.backgroundColor = Color.hexf5f5f5
        seperatorView.backgroundColor = Color.hexe4e4e4
        textView.textContainerInset = inset
        if !textView.isFirstResponder {
            textView.becomeFirstResponder()
        }
    }
    
    // MARK: - Event Responses
    @objc private func save() {
        updateInfoAPIManager.loadData()
    }
    
    @objc fileprivate func clearText() {
        textView.text = ""
    }
    
    // MARK: - Private Methods
    private func calculateHeight() {
        let size = "王晓天".sizeForFont(Font.size14!, size: CGSize(width: self.view.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail)
        inset = UIEdgeInsets(top: (55 - size.height) / 2, left: 10, bottom: (55 - size.height) / 2, right: 50)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _textView: UITextView?
    fileprivate var _clearButton: UIButton?
    fileprivate var seperatorView = UIView()
    fileprivate var inset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 50)
    fileprivate var updateInfoAPIManager = UpdateUserInfoAPIManager()
}

// MARK: - ONAPIManagerParamSource
extension MineNicknameController: ONAPIManagerParamSource {
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if (UserManager.sharedInstance.getUserInfo()?.userId != nil) && (UserManager.sharedInstance.getUserInfo()!.userId! > 0) {
            return ["id": UserManager.sharedInstance.getUserInfo()!.userId!,
                    "nickname": textView.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": UserManager.sharedInstance.getUserInfo()?.gender ?? 0,
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            ]
        } else {
            return ["uid": UserManager.sharedInstance.getUserInfo()!.uid!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "thirdType": UserManager.sharedInstance.getUserInfo()?.thirdType?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? 0,
                    "nickname": textView.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                    "headimgurl": UserManager.sharedInstance.getUserInfo()?.avatar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "age": UserManager.sharedInstance.getUserInfo()?.age.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "xingzuo": UserManager.sharedInstance.getUserInfo()?.conste.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                    "gender": UserManager.sharedInstance.getUserInfo()!.gender,
                    "area": UserManager.sharedInstance.getUserInfo()?.area.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            ]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension MineNicknameController: ONAPIManagerCallBackDelegate {
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        UserManager.sharedInstance.updateUserNickname(nickname: textView.text)
        navigationController?.popViewController(animated: true)
        ONTipCenter.showToast("更新用户昵称成功")
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        ONTipCenter.showToast("更新用户昵称失败，请稍候再试")
    }
}

// MARK: - Getters and Setters
extension MineNicknameController {
    fileprivate var textView: UITextView {
        if _textView == nil {
            _textView = UITextView()
            _textView?.font = Font.size14
            _textView?.textColor = Color.hex2a2a2a
            _textView?.textAlignment = .left
            _textView?.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 50)
            _textView?.backgroundColor = Color.hexffffff
            _textView?.autoresizingMask = .flexibleHeight
            _textView?.isScrollEnabled = false
            
            return _textView!
        }
        
        return _textView!
    }
    
    fileprivate var clearButton: UIButton {
        if _clearButton == nil {
            _clearButton = UIButton()
            _clearButton?.setImage(UIImage(named: Icon.clearIcon), for: .normal)
            _clearButton?.setImage(UIImage(named: Icon.clearIcon), for: .highlighted)
            _clearButton?.addTarget(self, action: #selector(clearText), for: .touchUpInside)
            
            return _clearButton!
        }
        
        return _clearButton!
    }
}
