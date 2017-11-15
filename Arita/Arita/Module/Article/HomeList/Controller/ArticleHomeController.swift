//
//  ArticleHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

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
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .custom)
        setNavi(leftCalendar: #selector(gotoCalendar), rightIcon: UIImage(named: Icon.topMine)!, rightAction: #selector(gotoMine))
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
        tableView.delegate = self
        tableView.dataSource = self
        
        mjHeader.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        mjFooter.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        
        articleHomeAPIManager.delegate = self
        articleHomeAPIManager.paramSource = self
    }
    
    private func loadData() {
        articleHomeAPIManager.loadData()
    }
    
    // MARK: - Event Response
    @objc private func gotoCalendar() {
        let dailyCheckController = DailyCheckController()
        dailyCheckController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dailyCheckController, animated: true)
    }
    
    @objc private func gotoMine() {
        let mineHomeController = MineHomeController()
        let mineHomeNav = UINavigationController(rootViewController: mineHomeController)
        present(mineHomeNav, animated: true, completion: nil)
    }
    
    @objc fileprivate func gotoCategory() {
        let categoryVC = CategoryCollectionController()
        categoryVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @objc private func headerRefresh() {
        if tableView.mj_header.isRefreshing() {
            articleHomeAPIManager.timeStamp = "0"
            articleModel.removeAll()
            articleHomeAPIManager.loadData()
        }
    }
    
    @objc private func footerRefresh() {
        if tableView.mj_footer.isRefreshing() {
            articleHomeAPIManager.timeStamp = articleModel.last?.last?.timeStamp ?? "0"
            articleHomeAPIManager.totalNum = totalCount
            let array = articleModel.flatMap { $0 }
            articleHomeAPIManager.currentNum = array.count
            articleHomeAPIManager.loadNextPage()
        }
    }
    
    // MARK: - Private Methods
    fileprivate func updateNaviLeftItem(with day: String) {
        guard self.navigationItem.leftBarButtonItems != nil && self.navigationItem.leftBarButtonItems!.count > 0 else { return }
        for item in self.navigationItem.leftBarButtonItems! {
            if item.customView is CalendarButton {
                let calendarButton = item.customView as! CalendarButton
                guard let drawDay = day.convertStringToDayString() else { return }
                calendarButton.dayString = drawDay
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _categoryButton: UIButton?
    fileprivate var articleHomeAPIManager = ArticleHomeAPIManager()
    fileprivate var mjHeader = MJRefreshNormalHeader()
    fileprivate var mjFooter = MJRefreshAutoNormalFooter()
    fileprivate var articleModel: [[ArticleHomeModel]] = [[ArticleHomeModel.initial], [ArticleHomeModel.initial]]
    fileprivate var currentCount = 0
    fileprivate var totalCount = 0
    fileprivate var isFirst = true
}

// MARK: - ONAPIManagerParamSource
extension ArticleHomeController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["timestamp": "0", "articlesNum": 20]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension ArticleHomeController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if isFirst {
            articleModel.removeAll()
            isFirst = false
        } 
        let data = manager.fetchDataWithReformer(nil)
        let viewModel = ArticleHomeViewModel(data: data, with: articleModel)
        articleModel = viewModel.articles
        totalCount = viewModel.totalCount
        updateNaviLeftItem(with: articleModel[0][0].sectionDate)
        if tableView.mj_header.isRefreshing() {
            tableView.mj_header.endRefreshing()
        }
        if tableView.mj_footer.isRefreshing() {
            tableView.mj_footer.endRefreshing()
        }
        tableView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if tableView.mj_header.isRefreshing() {
            tableView.mj_header.endRefreshing()
        }
        if tableView.mj_footer.isRefreshing() && manager.errorType == .noMoreData {
            tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            tableView.mj_footer.endRefreshing()
        }
        
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - TableView Data Source
extension ArticleHomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return articleModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleModel[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        } else {
            return 66
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch articleModel[indexPath.section][indexPath.row].cellType {
        case .tata:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTataCell.self), for: indexPath) as! ArticleHomeTataCell
            cell.titleText = articleModel[indexPath.section][indexPath.row].titleText
            cell.picUrl = articleModel[indexPath.section][indexPath.row].picUrl
            cell.contentText = articleModel[indexPath.section][indexPath.row].contentText
            cell.isJGG = false
            return cell
            
        case .normal:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeNormalCell.self), for: indexPath) as! ArticleHomeNormalCell
            cell.titleText = articleModel[indexPath.section][indexPath.row].titleText
            cell.picUrl = articleModel[indexPath.section][indexPath.row].picUrl
            cell.contentText = articleModel[indexPath.section][indexPath.row].contentText
            return cell
            
        case .allText:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTextCell.self), for: indexPath) as! ArticleHomeTextCell
            cell.titleText = articleModel[indexPath.section][indexPath.row].titleText
            cell.username = articleModel[indexPath.section][indexPath.row].userName
            cell.usercomment = articleModel[indexPath.section][indexPath.row].contentText
            return cell
            
        case .jgg:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleHomeTataCell.self), for: indexPath) as! ArticleHomeTataCell
            cell.titleText = articleModel[indexPath.section][indexPath.row].titleText
            cell.picUrl = articleModel[indexPath.section][indexPath.row].picUrl
            cell.contentText = articleModel[indexPath.section][indexPath.row].contentText
            cell.isJGG = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let headerView = ArticleSectionHeaderView(reuseIdentifier: String(describing: ArticleSectionHeaderView.self))
            headerView.date = articleModel[section][0].sectionDate.convertStringToDateString()
            return headerView
        }
    }
}

// MARK: - TableView Delegate
extension ArticleHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard articleModel.count > 0 else { return }
        if indexPath.section == 0 {
            let tataDailyController = ArticleCollectionController(with: articleModel[indexPath.section][indexPath.row], isFromHome: true, isTata: true)
            tataDailyController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(tataDailyController, animated: true)
        } else {
            if articleModel[indexPath.section][indexPath.row].categoryId >= 1 && articleModel[indexPath.section][indexPath.row].categoryId <= 6 {
                let articleListController = ArticleCollectionController(with: articleModel[indexPath.section][indexPath.row], isFromHome: true, isTata: false)
                articleListController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(articleListController, animated: true)
            }
        }
    }
}

extension ArticleHomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleIndexPaths = tableView.indexPathsForVisibleRows
        guard visibleIndexPaths != nil && visibleIndexPaths!.count > 0 else { return }
        let currentSection = visibleIndexPaths!.first!.section
        updateNaviLeftItem(with: articleModel[currentSection][0].sectionDate)
    }
}

// MARK: - Getters and Setters
extension ArticleHomeController {
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
            _tableView?.mj_header = mjHeader
            _tableView?.mj_footer = mjFooter
            
            return _tableView!
        }
        
        return _tableView!
    }
    
    fileprivate var categoryButton: UIButton {
        if _categoryButton == nil {
            _categoryButton = UIButton()
            _categoryButton?.setImage(UIImage(named: Icon.categoryIcon), for: .normal)
            _categoryButton?.setImage(UIImage(named: Icon.categoryIcon), for: .highlighted)
            _categoryButton?.addTarget(self, action: #selector(gotoCategory), for: .touchUpInside)
            
            return _categoryButton!
        }
        
        return _categoryButton!
    }
}
