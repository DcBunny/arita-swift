//
//  ArticleCollectionController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/9.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleCollectionController **文章列表**页主页(包括塔塔报按日期分类列表以及其他分类，更换不同的cell)
 */
class ArticleCollectionController: BaseController {

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
        view.addSubview(articleCollectionView)
    }
    
    private func layoutPageViews() {
        articleCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        articleCollectionView.backgroundColor = Color.hexf5f5f5
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _articleCollectionView: UICollectionView?
    fileprivate var conTitle: String?
}

//TODO: 需要后期删除
private let tataArticleModel = TataArticleModel.demoModel()
// MARK: - UICollecitonView Data Source
extension ArticleCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tataArticleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TataCollectionViewCell.self), for: indexPath) as! TataCollectionViewCell
        cell.tataArticleModel = tataArticleModel[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension ArticleCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let articleDetailController = ArticleDetailController(with: "塔塔报")
        navigationController?.pushViewController(articleDetailController, animated: true)
    }
}

// MARK: - Getters and Setters
extension ArticleCollectionController {
    fileprivate var articleCollectionView: UICollectionView {
        if _articleCollectionView == nil {
            let articleCollectionFlowLayout = ArticleCollectionFlowLayout()
            _articleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: articleCollectionFlowLayout)
            _articleCollectionView?.register(TataCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TataCollectionViewCell.self))
            _articleCollectionView?.showsVerticalScrollIndicator = false
            _articleCollectionView?.showsHorizontalScrollIndicator = false
            _articleCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _articleCollectionView!
        }
        
        return _articleCollectionView!
    }
}
