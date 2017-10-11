//
//  GoodsHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh

/**
 GoodsHomeController **良品**页主页
 */
class GoodsHomeController: BaseController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .custom)
        setNavi(leftIcon: UIImage(named: Icon.topSearch)!, leftAction: #selector(searchGoods), rightIcon: UIImage(named: Icon.topMine)!, rightAction: #selector(gotoMine))
        let titleView = UIImageView(image: UIImage(named: Icon.topTitleLogo))
        setTitleView(titleView)
    }
    
    private func addPageViews() {
        view.addSubview(tableView)
        view.addSubview(categoryButton)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        categoryButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.bottom.equalTo(view).offset(-15)
        }
    }
    
    private func setPageViews() {
        //        tableView.delegate = self
        //        tableView.dataSource = self
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _categoryButton: UIButton?
    
    // MARK: - Event Response
    @objc private func searchGoods() {
        
    }
    
    @objc private func gotoMine() {
        
    }
    
    @objc fileprivate func gotoCategory() {
        
    }
}

// MARK: - Getters and Setters
extension GoodsHomeController {
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _tableView?.backgroundColor = Color.hexf5f5f5
            _tableView?.showsVerticalScrollIndicator = false
            _tableView?.register(ArticleHomeTataCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTataCell.self))
            _tableView?.register(ArticleHomeNormalCell.self, forCellReuseIdentifier: String(describing: ArticleHomeNormalCell.self))
            _tableView?.register(ArticleHomeTextCell.self, forCellReuseIdentifier: String(describing: ArticleHomeTextCell.self))
            _tableView?.register(ArticleHomePicCell.self, forCellReuseIdentifier: String(describing: ArticleHomePicCell.self))
            _tableView?.register(ArticleSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: ArticleSectionHeaderView.self))
            _tableView?.estimatedRowHeight = Size.screenWidth + 156
            _tableView?.rowHeight = UITableViewAutomaticDimension
            _tableView?.separatorStyle = .none
            _tableView?.mj_header = MJRefreshNormalHeader()
            _tableView?.mj_footer = MJRefreshAutoNormalFooter()
            
            return _tableView!
        }
        
        return _tableView!
    }
    
    fileprivate var categoryButton: UIButton {
        if _categoryButton == nil {
            _categoryButton = UIButton()
            _categoryButton?.setImage(UIImage(named: Icon.likeListIcon), for: .normal)
            _categoryButton?.setImage(UIImage(named: Icon.likeListIcon), for: .highlighted)
            _categoryButton?.addTarget(self, action: #selector(gotoCategory), for: .touchUpInside)
            
            return _categoryButton!
        }
        
        return _categoryButton!
    }
}
