//
//  GoodsCollectionController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsAlbumCollectionController: BaseController {

    // MARK: - Life Cycle
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
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with title: String) {
        self.conTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(title: conTitle, font: Font.size15)
        setNaviBar(type: .normal)
    }
    
    private func addPageViews() {
        view.addSubview(goodsAlbumCollectionView)
    }
    
    private func layoutPageViews() {
        if #available(iOS 11.0, *) {
            goodsAlbumCollectionView.snp.makeConstraints({ (make) in
                make.edges.equalTo(view.safeAreaInsets)
            })
        } else {
            goodsAlbumCollectionView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }
    }
    
    private func setPageViews() {
        goodsAlbumCollectionView.backgroundColor = Color.hexf5f5f5
        goodsAlbumCollectionView.delegate = self
        goodsAlbumCollectionView.dataSource = self
    }
    
    private func setAPIManager() {
        goodsAblumListManager.paramSource = self
        goodsAblumListManager.delegate = self
    }
    
    private func loadPageData() {
        goodsAblumListManager.loadData()
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    fileprivate func pageWith() -> Float {
        return Float((self.goodsAlbumCollectionView.collectionViewLayout as! GoodsAlbumCollectionFlowLayout).itemSize.width + (self.goodsAlbumCollectionView.collectionViewLayout as! GoodsAlbumCollectionFlowLayout).minimumLineSpacing)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _goodsAlbumCollectionView: BaseCollectionView?
    fileprivate var conTitle: String?
    
    fileprivate var _goodsAlbumListManager: GoodsAblumListManager?
    fileprivate var albumArray: [JSON] = []
    
    fileprivate var currentPage = 0
    fileprivate var isScrolling = false
    fileprivate var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
}

// MARK: - UICollecitonView Data Source
extension GoodsAlbumCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsAlbumCollectionViewCell.self), for: indexPath) as! GoodsAlbumCollectionViewCell
        cell.album = albumArray[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension GoodsAlbumCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsAlbumController = GoodsAlbumController(id: albumArray[indexPath.row]["ID"].stringValue)
        navigationController?.pushViewController(goodsAlbumController, animated: true)
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsAlbumCollectionController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["timestamp": 0, "albumNum": 100]
    }
}

// MARK: - UIScrollView Delegate
extension GoodsAlbumCollectionController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.view.convert(self.goodsAlbumCollectionView.center, to: self.goodsAlbumCollectionView)
        let indexNow = self.goodsAlbumCollectionView.indexPathForItem(at: pInView)
        currentIndex = indexNow
        isScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        currentPage = Int(floor((Float(self.goodsAlbumCollectionView.contentOffset.x) - pageWith() / 2) / pageWith())) + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.goodsAlbumCollectionView.contentSize.width)
        var newPage = Float(currentPage)
        let pageWidth = pageWith()
        
        if velocity.x == 0 {
            newPage = (floor((targetXContentOffset - pageWidth / 2) / pageWidth) + 1)
        } else {
            newPage = Float(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            
            if newPage < 0 {
                newPage = 0
            }
            
            if (newPage > ( contentWidth / pageWidth)) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.currentPage = Int(newPage)
        let point = CGPoint(x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}

extension GoodsAlbumCollectionController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        albumArray = json["albumArr"].arrayValue
        goodsAlbumCollectionView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension GoodsAlbumCollectionController {
    fileprivate var goodsAlbumCollectionView: BaseCollectionView {
        if _goodsAlbumCollectionView == nil {
            let goodsAlbumCollectionFlowLayout = GoodsAlbumCollectionFlowLayout()
            _goodsAlbumCollectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: goodsAlbumCollectionFlowLayout)
            _goodsAlbumCollectionView?.register(GoodsAlbumCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GoodsAlbumCollectionViewCell.self))
            _goodsAlbumCollectionView?.showsVerticalScrollIndicator = false
            _goodsAlbumCollectionView?.showsHorizontalScrollIndicator = false
            _goodsAlbumCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _goodsAlbumCollectionView!
        }
        
        return _goodsAlbumCollectionView!
    }
    
    fileprivate var goodsAblumListManager: GoodsAblumListManager {
        if _goodsAlbumListManager == nil {
            _goodsAlbumListManager = GoodsAblumListManager()
        }
        
        return _goodsAlbumListManager!
    }
}
