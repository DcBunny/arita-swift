//
//  CategoryCollectionController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class CategoryCollectionController: BaseController {

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
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "分类", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(categoryCollectionView)
    }
    
    private func layoutPageViews() {
        categoryCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.bottom.equalTo(view)
        }
    }
    
    private func setPageViews() {
        categoryCollectionView.backgroundColor = Color.hexf5f5f5!
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _categoryCollectionView: UICollectionView?
}

private let categoryModel = CategoryModel.demoModel()
// MARK: - UICollecitonView Data Source
extension CategoryCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionCell.self), for: indexPath) as! CategoryCollectionCell
        cell.categoryModel = categoryModel[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension CategoryCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let shareController = ShareController()
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            self.present(shareController, animated: true, completion: nil)
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
