//
//  ArticleHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh

/**
 ArticleHomeController **文章**页主页
 */
class ArticleHomeController: BaseController {

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
        setNaviBar(type: .custom)
        setNavi(leftIcon: UIImage(named: Icon.mineOn)!, leftAction: #selector(gotoMine), rightIcon: UIImage(named: Icon.dayCheck)!, rightAction: #selector(gotoCategory))
        let titleView = ArticleTitleView("THURSDAY, MAR.19")
        setTitleView(titleView)
    }
    
    private func addPageViews() {
        view.addSubview(tableView)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Event Response
    @objc private func gotoMine() {
        
    }
    
    @objc private func gotoCategory() {
    
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
}


// MARK: - TableView Data Source
extension ArticleHomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTataCell.self), for: indexPath) as! ArticleHomeTataCell
        cell.titleText = "塔塔报 | 0520"
        cell.picUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505393598169&di=5b7bc88e0dc4e74721e868bd0fd8b03b&imgtype=0&src=http%3A%2F%2Fimg.weixinyidu.com%2F150921%2Ff9718e53.jpg"
        cell.contentText = "英国有一个最佳设计效率奖，今年颁给了一款“胶水”"
        return cell
    }
}

// MARK: - TableView Delegate
extension ArticleHomeController: UITableViewDelegate {

}

// MARK: - Getters and Setters
extension ArticleHomeController {
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView()
            _tableView?.backgroundColor = Color.hexf5f5f5
            _tableView?.showsVerticalScrollIndicator = false
            _tableView?.register(ArticleHomeTataCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTataCell.self))
            _tableView?.register(ArticleHomeTextCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTextCell.self))
            _tableView?.register(ArticleHomePicCell.self, forCellReuseIdentifier: String(describing: ArticleHomePicCell.self))
            _tableView?.estimatedRowHeight = Size.screenWidth + 156
            _tableView?.rowHeight = UITableViewAutomaticDimension
            _tableView?.separatorStyle = .none
            _tableView?.mj_header = MJRefreshNormalHeader()
            _tableView?.mj_footer = MJRefreshAutoNormalFooter()
            
            return _tableView!
        }
        
        return _tableView!
    }
}
