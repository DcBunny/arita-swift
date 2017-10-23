//
//  GoodsHomeController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

fileprivate let kAlbumImage = "AlbumImage"
fileprivate let kAlbumId = "AlbumId"

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
        setAPIManager()
        initPageData()
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
        view.addSubview(likeButton)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.bottom.equalTo(view).offset(-15)
        }
    }
    
    private func setPageViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header.setRefreshingTarget(self, refreshingAction: #selector(loadPageData))
        tableView.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(loadMorePageData))
    }
    
    private func setAPIManager() {
        latestGoodsAlbumManager.paramSource = self
        latestGoodsAlbumManager.delegate = self
    }
    
    private func initPageData() {
        tableView.mj_header.beginRefreshing()
    }
    
    @objc private func loadPageData() {
        latestGoodsAlbumManager.loadData()
    }
    
    @objc private func loadMorePageData() {
        
    }
    
    // MARK: - Event Response
    @objc private func searchGoods() {
        let search = GoodsSearchController()
        search.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(search, animated: true)
    }
    
    @objc private func gotoMine() {
        
    }
    
    @objc fileprivate func gotoLike() {
        
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _likeButton: UIButton?
    
    fileprivate var _latestGoodsAlbumManager: LatestGoodsAlbumManager?
    fileprivate var latestGoodsAlbum: [String: String] = [
        kAlbumImage: "",
        kAlbumId: ""
    ]
}

extension GoodsHomeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Goods4GridCell.self), for: indexPath) as! Goods4GridCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GoodsNormalCell.self), for: indexPath) as! GoodsNormalCell
            cell.goodImage.backgroundColor = UIColor.blue
            cell.goodLabel.text = "1233211233211231231231231231aaa"
            cell.goodPriceLabel.text = "¥" + "89"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (10 + (UIScreen.main.bounds.width - 20) * 2 / 3 + 20 + 20 + 20 + ((Size.screenWidth - 60) / 3) * 3 + 20 + 20)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = GoodsHomeHeaderView(reuseIdentifier: String(describing: GoodsHomeHeaderView.self))
        headerView.albumButton.addTarget(self, action: #selector(gotoGoodsAlbum), for: .touchUpInside)
        headerView.imageUrl = latestGoodsAlbum[kAlbumImage]
        headerView.delegate = self
        
        return headerView
    }
    
    @objc private func gotoGoodsAlbum() {
        let goodsAlbumCollection = GoodsAlbumCollectionController(with: "专题")
        goodsAlbumCollection.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(goodsAlbumCollection, animated: true)
    }
}

extension GoodsHomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let good = GoodsController()
        good.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(good, animated: true)
    }
}

// MARK: - GoodsHomeHeaderDelegate
extension GoodsHomeController: GoodsHomeHeaderDelegate {
    func category(disSelectAt indexPath: IndexPath) {
        let category = CategoryController(with: "分类名")
        category.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(category, animated: true)
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsHomeController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["timestamp": 0, "albumNum": 1]
    }
}

extension GoodsHomeController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if tableView.mj_header.isRefreshing() {
            tableView.mj_header.endRefreshing()
        }
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        latestGoodsAlbum[kAlbumImage] = json["albumFreshList"][0]["album_index_thumb_path"].stringValue
        latestGoodsAlbum[kAlbumId] = json["albumFreshList"][0]["ID"].stringValue
        
        tableView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
//        tableView.mj_footer.endRefreshing()
//        tableView.mj_header.endRefreshing()
//        self.dismissONLoadingView()
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension GoodsHomeController {
    
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _tableView?.backgroundColor = Color.hexf5f5f5
            _tableView?.showsVerticalScrollIndicator = false
            _tableView?.register(Goods4GridCell.self, forCellReuseIdentifier: String(describing: Goods4GridCell.self))
            _tableView?.register(GoodsNormalCell.self, forCellReuseIdentifier: String(describing: GoodsNormalCell.self))
            _tableView?.register(GoodsHomeHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: GoodsHomeHeaderView.self))
            _tableView?.estimatedRowHeight = Size.screenWidth + 156
            _tableView?.rowHeight = UITableViewAutomaticDimension
            _tableView?.separatorStyle = .none
            _tableView?.mj_header = MJRefreshNormalHeader()
            _tableView?.mj_footer = MJRefreshAutoNormalFooter()
            
            return _tableView!
        }
        
        return _tableView!
    }
    
    fileprivate var likeButton: UIButton {
        if _likeButton == nil {
            _likeButton = UIButton()
            _likeButton?.setImage(UIImage(named: Icon.likeListIcon), for: .normal)
            _likeButton?.setImage(UIImage(named: Icon.likeListIcon), for: .highlighted)
            _likeButton?.addTarget(self, action: #selector(gotoLike), for: .touchUpInside)
        }
        
        return _likeButton!
    }
    
    fileprivate var latestGoodsAlbumManager: LatestGoodsAlbumManager {
        if _latestGoodsAlbumManager == nil {
            _latestGoodsAlbumManager = LatestGoodsAlbumManager()
        }
        
        return _latestGoodsAlbumManager!
    }
}
