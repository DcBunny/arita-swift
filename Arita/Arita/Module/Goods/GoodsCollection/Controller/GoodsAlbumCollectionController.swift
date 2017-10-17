//
//  GoodsCollectionController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsAlbumCollectionController: BaseController {

    // MARK: - Life Cycle
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
        goodsAlbumCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        goodsAlbumCollectionView.backgroundColor = Color.hexf5f5f5
        goodsAlbumCollectionView.delegate = self
        goodsAlbumCollectionView.dataSource = self
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _goodsAlbumCollectionView: UICollectionView?
    fileprivate var conTitle: String?
}

//TODO: 需要后期删除
private let tataArticleModel = TataArticleModel.demoModel()
// MARK: - UICollecitonView Data Source
extension GoodsAlbumCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tataArticleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsAlbumCollectionViewCell.self), for: indexPath) as! GoodsAlbumCollectionViewCell
        cell.tataArticleModel = tataArticleModel[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension GoodsAlbumCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let goodsAlbumController = GoodsAlbumController()
        navigationController?.pushViewController(goodsAlbumController, animated: true)
    }
}

// MARK: - Getters and Setters
extension GoodsAlbumCollectionController {
    fileprivate var goodsAlbumCollectionView: UICollectionView {
        if _goodsAlbumCollectionView == nil {
            let goodsAlbumCollectionFlowLayout = GoodsAlbumCollectionFlowLayout()
            _goodsAlbumCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: goodsAlbumCollectionFlowLayout)
            _goodsAlbumCollectionView?.register(GoodsAlbumCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GoodsAlbumCollectionViewCell.self))
            _goodsAlbumCollectionView?.showsVerticalScrollIndicator = false
            _goodsAlbumCollectionView?.showsHorizontalScrollIndicator = false
            _goodsAlbumCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _goodsAlbumCollectionView!
        }
        
        return _goodsAlbumCollectionView!
    }
}
