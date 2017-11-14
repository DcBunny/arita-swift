//
//  MyGoodsController.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 GoodsHomeController **良品**页主页
 */
class MyGoodsController: BaseController
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
        setNaviBar(title: "我的收藏", font: Font.size15)
        setNaviBar(type: .normal)
    }
    
    private func addPageViews() {
        view.addSubview(likeCollection)
    }
    
    private func layoutPageViews() {
        likeCollection.snp.makeConstraints { (make) in
            make.top.left.equalTo(view).offset(10)
            make.bottom.right.equalTo(view).offset(-10)
        }
    }
    
    private func setPageViews() {
        likeCollection.delegate = self
        likeCollection.dataSource = self
    }
    
    private func setAPIManager() {
        goodsListManager.paramSource = self
        goodsListManager.delegate = self
    }
    
    private func initPageData() {
        goodsListManager.loadData()
    }
    
    // MARK: - Controller Attributes
    fileprivate var _likeCollection: UICollectionView?
    
    fileprivate var _goodsListManager: MyGoodsManager?
    fileprivate var goodsArray: [JSON] = []
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension MyGoodsController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["id": (UserManager.sharedInstance.currentUser?.authInfo?.token)!]
    }
}

extension MyGoodsController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        goodsArray = json.arrayValue
        
        likeCollection.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - UICollecitonView Data Source
extension MyGoodsController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsGridCell.self), for: indexPath) as! GoodsGridCell
        cell.goodImage.kf.setImage(with: URL(string: goodsArray[indexPath.row]["thumb_path"].stringValue))
        cell.goodLabel.text = goodsArray[indexPath.row]["title"].stringValue
        cell.goodPriceLabel.text = "¥" + goodsArray[indexPath.row]["price"].stringValue
        
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension MyGoodsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let good = GoodsController(id: goodsArray[indexPath.row]["goods_ID"].stringValue)
        navigationController?.pushViewController(good, animated: true)
    }
}

// MARK: - Getters and Setters
extension MyGoodsController {
    
    fileprivate var likeCollection: UICollectionView {
        if _likeCollection == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.itemSize = CGSize(width: ((Size.screenWidth - 25) / 2), height: 275)
            _likeCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _likeCollection?.register(GoodsGridCell.self, forCellWithReuseIdentifier: String(describing: GoodsGridCell.self))
            _likeCollection?.showsVerticalScrollIndicator = false
            _likeCollection?.translatesAutoresizingMaskIntoConstraints = false
            _likeCollection?.isScrollEnabled = false
            _likeCollection?.backgroundColor = UIColor.clear
        }
        
        return _likeCollection!
    }
    
    fileprivate var goodsListManager: MyGoodsManager {
        if _goodsListManager == nil {
            _goodsListManager = MyGoodsManager()
        }
        
        return _goodsListManager!
    }
}
