//
//  GoodsAlbumController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import MJRefresh

class GoodsAlbumController: BaseController {

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
    
    // MARK: - Controller Attributes
    fileprivate var _collectionView: UICollectionView?
}

// MARK: - UICollecitonView Data Source
extension GoodsAlbumController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsGridCell.self), for: indexPath) as! GoodsGridCell
        cell.goodImage.backgroundColor = UIColor.blue
        cell.goodLabel.text = "1233211233211231231231231231aaa"
        cell.goodPriceLabel.text = "¥" + "89"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GoodsAlbumCollectionReusableView.self), for: indexPath)
            
            return header
//        }
    }
}

// MARK: - UICollecitonView Delegate
extension GoodsAlbumController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShareCollectionCell.self), for: indexPath) as! ShareCollectionCell
        //        guard let shareType = cell.shareType else { return }
        //        ShareTool.sharedInstance.shareWith(content: nil, to: shareType)
    }
}

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return (10 + (UIScreen.main.bounds.width - 20) * 2 / 3 + 20 + 20 + 20 + ((Size.screenWidth - 60) / 3) * 3 + 20 + 20)
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = GoodsHomeHeaderView(reuseIdentifier: String(describing: GoodsHomeHeaderView.self))
//        headerView.albumButton.addTarget(self, action: #selector(gotoGoodsAlbum), for: .touchUpInside)
//        headerView.imageUrl = "123"
//
//        return headerView
//    }

// MARK: - Getters and Setters
extension GoodsAlbumController {
    
    fileprivate var collectionView: UICollectionView {
        if _collectionView == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.itemSize = CGSize(width: ((Size.screenWidth - 25) / 2), height: 275)
            let headerHeight = 5 + (Size.screenWidth - 20) * 2 / 3 + 15 + 20 + 10 + 50
            flowLayout.headerReferenceSize = CGSize(width: Size.screenWidth, height: 275)
            _collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _collectionView?.register(GoodsGridCell.self, forCellWithReuseIdentifier: String(describing: GoodsGridCell.self))
            _collectionView?.showsVerticalScrollIndicator = false
            _collectionView?.translatesAutoresizingMaskIntoConstraints = false
            _collectionView?.backgroundColor = UIColor.clear
            _collectionView?.register(GoodsAlbumCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GoodsAlbumCollectionReusableView.self))
            _collectionView?.mj_header = MJRefreshNormalHeader()
            _collectionView?.mj_footer = MJRefreshAutoNormalFooter()
        }
        
        return _collectionView!
    }
}
