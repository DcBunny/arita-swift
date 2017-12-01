//
//  CategoryCollectionController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 CategoryCollectionController **分类**页主页
 */
class CategoryCollectionController: BaseController {

    // MARK: - Life Cycle
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
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "分类", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(categoryCollectionView)
    }
    
    private func layoutPageViews() {
        if #available(iOS 11.0, *) {
            categoryCollectionView.snp.makeConstraints({ (make) in
                make.top.bottom.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).offset(-15)
            })
        } else {
            categoryCollectionView.snp.makeConstraints { (make) in
                make.top.equalTo(view)
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).offset(-15)
                make.bottom.equalTo(view)
            }
        }
    }
    
    private func setPageViews() {
        categoryCollectionView.backgroundColor = Color.hexf5f5f5!
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionAPIManager.delegate = self
        categoryCollectionAPIManager.paramSource = self
    }
    
    private func loadData() {
        categoryCollectionAPIManager.loadData()
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _categoryCollectionView: UICollectionView?
    fileprivate var isFirst = true
    fileprivate var categoryCollectionAPIManager = CategoryCollectionAPIManager()
    fileprivate var channelModel: [CategoryModel] = CategoryModel.initial()
}

// MARK: - ONAPIManagerParamSource
extension CategoryCollectionController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return [:]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension CategoryCollectionController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if isFirst {
            channelModel.removeAll()
            isFirst = false
        }
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data).arrayValue
        for data in json {
            channelModel.append(CategoryModel(data: data))
        }
        categoryCollectionView.reloadData()
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - UICollecitonView Data Source
extension CategoryCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionCell.self), for: indexPath) as! CategoryCollectionCell
        cell.categoryModel = channelModel[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension CategoryCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard channelModel.count > 0 else { return }
        if channelModel[indexPath.row].channelName == "塔塔报" {
            let tataDailyController = ArticleCollectionController(with: channelModel[indexPath.row], isFromHome: false, isTata: true)
            tataDailyController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(tataDailyController, animated: true)
        } else if channelModel[indexPath.row].channelID == 44 {
            let dailyCheckController = DailyCheckController(with: nil)
            dailyCheckController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(dailyCheckController, animated: true)
        } else {
            let articleListController = ArticleCollectionController(with: channelModel[indexPath.row], isFromHome: false, isTata: false)
            articleListController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(articleListController, animated: true)
        }
    }
}

// MARK: - Getters and Setters
extension CategoryCollectionController {
    fileprivate var categoryCollectionView: UICollectionView {
        if _categoryCollectionView == nil {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 35, left: 0, bottom: 40, right: 0)
            layout.estimatedItemSize = CGSize(width: (Size.screenWidth - 30) / 3, height: 140)
            _categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            _categoryCollectionView?.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: String(describing: CategoryCollectionCell.self))
            _categoryCollectionView?.showsVerticalScrollIndicator = false
            _categoryCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _categoryCollectionView!
        }
        
        return _categoryCollectionView!
    }
}
