//
//  MineHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineHomeController **我的**页面主页
 */
class MineHomeController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        prepareData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "我的", font: Font.size15)
        setBackBtn(.dismiss)
    }
    
    private func addPageViews() {
        view.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(mineTableView)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(view).offset(6)
            ConstraintMaker.right.equalTo(view).offset(-6)
            ConstraintMaker.top.equalTo(view).offset(5)
            ConstraintMaker.bottom.equalTo(view).offset(-12)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        mineTableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(bodyView)
        }
    }
    
    private func setPageViews() {
        mineTableView.delegate = self
        mineTableView.dataSource = self
    }
    
    private func prepareData() {
        if isLogin {
            iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting, Icon.logout]
            nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置", "退出登录"]
            userInfo = ["", "王晓天"]
        } else {
            iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting]
            nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置"]
            userInfo = [nil, nil]
        }
    }
    
    // MARK: - Event Responses
    @objc fileprivate func userAvatarAction() {
        if isLogin {
            // 进入用户个人信息页
        } else {
            // 进入登录页面
            
        }
    }
    
    @objc fileprivate func userNameAction() {
        if isLogin {
            // 已登录什么也不做
        } else {
            // 未登录则去登录
        }
    }
    
    // MARK: - Private Methods
    fileprivate func calculateHeight() -> CGFloat {
        return "请登录".sizeForFont(Font.size20!, size: CGSize(width: self.view.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail).height
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _mineTableView: UITableView?
    
    fileprivate var iconArray = [Icon.aboutUs, Icon.mailUs, Icon.scoreUs, Icon.recommendUs, Icon.setting]
    fileprivate var nameArray = ["关于我们", "投稿合作", "评分", "推荐给朋友", "设置"]
    fileprivate var userInfo: [String?] = [nil, nil]
    //TODO:- 登录未确定
    fileprivate var isLogin = false
}

// MARK: - TableView Data Source
extension MineHomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 162 + calculateHeight() / 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineHomeTableViewCell.self), for: indexPath) as! MineHomeTableViewCell
        cell.leftIcon = iconArray[indexPath.row]
        cell.itemName = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MineHomeHeaderView.self)) as! MineHomeHeaderView
        header.userAvatar = userInfo[0]
        header.userName = userInfo[1]
        header.userButton.addTarget(self, action: #selector(userNameAction), for: .touchUpInside)
        header.userAvatarButton.addTarget(self, action: #selector(userAvatarAction), for: .touchUpInside)
        return header
    }
}

// MARK: - TableView Delegate
extension MineHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


// MARK: - Getters and Setters
extension MineHomeController {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var mineTableView: UITableView {
        if _mineTableView == nil {
            _mineTableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _mineTableView?.backgroundColor = Color.hexffffff!
            _mineTableView?.showsVerticalScrollIndicator = false
            _mineTableView?.separatorStyle = .none
            _mineTableView?.register(MineHomeTableViewCell.self, forCellReuseIdentifier: String(describing: MineHomeTableViewCell.self))
            
            return _mineTableView!
        }
        
        return _mineTableView!
    }
}
