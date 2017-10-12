//
//  ArticleDetailController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleDetailController **文章详情列表**页主页(包括塔塔报详情列表以及其他分类，更换不同的cell)
 */
class ArticleDetailController: BaseController {

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
        setNaviBar(type: .normal)
        setNaviBar(title: conTitle, font: Font.size15)
        setNaviRightIconBtn(UIImage(named: Icon.share)!, action: #selector(gotoShare))
    }
    
    private func addPageViews() {
        view.addSubview(articleDetailCollectionView)
        
    }
    
    private func layoutPageViews() {
        articleDetailCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        articleDetailCollectionView.backgroundColor = Color.hexf5f5f5
        articleDetailCollectionView.delegate = self
        articleDetailCollectionView.dataSource = self
    }
    
    // MARK: - Event Responses
    @objc private func gotoShare() {
        DispatchQueue.main.async {
            let shareController = ShareController()
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            self.present(shareController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _articleDetailCollectionView: UICollectionView?
    fileprivate var conTitle: String?
}

// MARK: - UICollecitonView Data Source
extension ArticleDetailController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleDetailCell.self), for: indexPath) as! ArticleDetailCell
        cell.webUrl = "https://www.baidu.com"
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension ArticleDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - Getters and Setters
extension ArticleDetailController {
    fileprivate var articleDetailCollectionView: UICollectionView {
        if _articleDetailCollectionView == nil {
            let articleDetailFlowLayout = ArticleDetailFlowLayout()
            _articleDetailCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: articleDetailFlowLayout)
            _articleDetailCollectionView?.register(ArticleDetailCell.self, forCellWithReuseIdentifier: String(describing: ArticleDetailCell.self))
            _articleDetailCollectionView?.showsVerticalScrollIndicator = false
            _articleDetailCollectionView?.showsHorizontalScrollIndicator = false
            _articleDetailCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _articleDetailCollectionView!
        }
        
        return _articleDetailCollectionView!
    }
}
