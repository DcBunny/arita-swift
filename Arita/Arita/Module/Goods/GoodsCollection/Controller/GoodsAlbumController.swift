//
//  GoodsAlbumController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON

class GoodsAlbumController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        setAPIManager()
        loadPageData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(title: "专题", font: Font.size15)
        setNaviBar(type: .normal)
    }
    
    private func addPageViews() {
        view.addSubview(collectionView)
    }
    
    private func layoutPageViews() {
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
        }
    }
    
    private func setPageViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setAPIManager() {
        goodsAlbumManager.paramSource = self
        goodsAlbumManager.delegate = self
    }
    
    private func loadPageData() {
        goodsAlbumManager.loadData()
    }
    
    // MARK: - Controller Attributes
    fileprivate var _collectionView: BaseCollectionView?
    
    fileprivate var id: String?
    fileprivate var _goodsAlbumManager: GoodsAlbumManager?
    fileprivate var albumDetail = [
        "imgUrl": "",
        "desc": ""
    ]
    fileprivate var relateGoods: [JSON] = []
}

// MARK: - UICollecitonView Data Source
extension GoodsAlbumController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return relateGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsGridCell.self), for: indexPath) as! GoodsGridCell
        cell.goodImage.kf.setImage(with: URL(string: relateGoods[indexPath.row]["thumb_path"].stringValue))
        cell.goodLabel.text = relateGoods[indexPath.row]["title"].stringValue
        cell.goodPriceLabel.text = "¥" + relateGoods[indexPath.row]["price"].stringValue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GoodsAlbumCollectionReusableView.self), for: indexPath) as! GoodsAlbumCollectionReusableView
        header.imageUrl = albumDetail["imgUrl"]
        header.contentString = albumDetail["desc"]
        
        return header
//        }
    }
}

// MARK: - UICollecitonView Delegate
extension GoodsAlbumController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let good = GoodsController(id: relateGoods[indexPath.row]["ID"].stringValue)
        good.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(good, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GoodsAlbumController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerString = albumDetail["desc"]!
        let contentSize = headerString.sizeForFont(Font.size13!, size: CGSize(width: Size.screenWidth - 50, height: CGFloat(MAXFLOAT)), lineBreakMode: .byWordWrapping)
        let headerHeight = 5 + (Size.screenWidth - 20) * 2 / 3 + 15 + 20 + 10 + contentSize.height
        
        return CGSize(width: Size.screenWidth, height: headerHeight)
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsAlbumController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["id": id!]
    }
}

extension GoodsAlbumController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        albumDetail["imgUrl"] = json["album_thumb_path"].stringValue
        albumDetail["desc"] = json["album_desc"].stringValue
        relateGoods = json["relativeGoodsArr"].arrayValue
        collectionView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension GoodsAlbumController {
    
    fileprivate var collectionView: BaseCollectionView {
        if _collectionView == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.itemSize = CGSize(width: ((Size.screenWidth - 25) / 2), height: 275)
            _collectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _collectionView?.register(GoodsGridCell.self, forCellWithReuseIdentifier: String(describing: GoodsGridCell.self))
            _collectionView?.showsVerticalScrollIndicator = false
            _collectionView?.translatesAutoresizingMaskIntoConstraints = false
            _collectionView?.backgroundColor = UIColor.clear
            _collectionView?.register(GoodsAlbumCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GoodsAlbumCollectionReusableView.self))
        }
        
        return _collectionView!
    }
    
    fileprivate var goodsAlbumManager: GoodsAlbumManager {
        if _goodsAlbumManager == nil {
            _goodsAlbumManager = GoodsAlbumManager()
        }
        
        return _goodsAlbumManager!
    }
}
