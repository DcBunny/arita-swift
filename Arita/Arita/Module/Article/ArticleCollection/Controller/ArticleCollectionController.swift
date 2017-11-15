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
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with articleInfo: Any, isFromHome: Bool, isTata: Bool) {
        self.isFromHome = isFromHome
        self.isTata = isTata
        if isFromHome {
            let info = articleInfo as! ArticleHomeModel
            self.conTitle = info.channelName
            self.channelID = info.channelId
            self.timeStamp = info.timeStamp
            super.init(nibName: nil, bundle: nil)
        } else {
            let info = articleInfo as! CategoryModel
            self.conTitle = info.channelName
            self.channelID = info.channelID
            self.timeStamp = info.publicTime
            super.init(nibName: nil, bundle: nil)
        }
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
        if #available(iOS 11.0, *) {
            articleCollectionView.snp.makeConstraints({ (make) in
                make.edges.equalTo(view.safeAreaInsets)
            })
        } else {
            articleCollectionView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
        }
    }
    
    private func setPageViews() {
        articleCollectionView.backgroundColor = Color.hexf5f5f5
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        
        tatabaoAPIManager.delegate = self
        tatabaoAPIManager.paramSource = self
        articleAPIManager.delegate = self
        articleAPIManager.paramSource = self
    }
    
    private func loadData() {
        if isTata {
            tatabaoAPIManager.loadData()
        } else {
            articleAPIManager.loadData()
        }
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    fileprivate func pageWith() -> Float {
        return Float((self.articleCollectionView.collectionViewLayout as! ArticleCollectionFlowLayout).itemSize.width + (self.articleCollectionView.collectionViewLayout as! ArticleCollectionFlowLayout).minimumLineSpacing)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _articleCollectionView: UICollectionView?
    fileprivate var conTitle: String?
    fileprivate var isTata: Bool
    fileprivate var isFromHome: Bool
    fileprivate var channelID: Int
    fileprivate var timeStamp: String
    fileprivate var tatabaoAPIManager = TataBaoAPIManager()
    fileprivate var articleAPIManager = ArticleAPIManager()
    fileprivate var articleModel: [ArticleModel] = [ArticleModel.initial]
    fileprivate var totalCount = 0
    fileprivate var isFirst = true
    fileprivate var currentPage = 0
}

extension ArticleCollectionController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentPage = Int(floor((Float(self.articleCollectionView.contentOffset.x) - pageWith() / 2) / pageWith())) + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.articleCollectionView.contentSize.width)
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

// MARK: - ONAPIManagerParamSource
extension ArticleCollectionController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if manager is TataBaoAPIManager {
            return ["timestamp": 0, "articlesNum": 500]
        } else if manager is ArticleAPIManager {
            return ["timestamp": 0, "articlesNum": 500, "channel_ID": channelID]
        } else {
            return [:]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension ArticleCollectionController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if isFirst {
            articleModel.removeAll()
            isFirst = false
        }
        if manager is TataBaoAPIManager {
            let data = manager.fetchDataWithReformer(nil)
            let viewModel = ArticleViewModel(data: data)
            articleModel = viewModel.articles
            totalCount = viewModel.totalCount
            articleCollectionView.reloadData()
        } else if manager is ArticleAPIManager {
            let data = manager.fetchDataWithReformer(nil)
            let viewModel = NormalArticleViewModel(data: data)
            articleModel = viewModel.articles
            totalCount = viewModel.totalCount
            articleCollectionView.reloadData()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
       
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - UICollecitonView Data Source
extension ArticleCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isTata {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TataCollectionViewCell.self), for: indexPath) as! TataCollectionViewCell
            cell.tataArticleModel = articleModel[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCollectionViewCell.self), for: indexPath) as! ArticleCollectionViewCell
            cell.articleModel = articleModel[indexPath.row]
            return cell
        }
    }
}

// MARK: - UICollecitonView Delegate
extension ArticleCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard articleModel.count > 0 else { return }
        if isTata {
            let articleDetailController = ArticleDetailController(with: conTitle, and: articleModel[indexPath.row].articleDate)
            navigationController?.pushViewController(articleDetailController, animated: true)
        } else {
            if self.channelID == 34 { return }
            let shareUrl = API.articleDetailUrl + "\(articleModel[indexPath.row].articleID)"
            let content = [ShareKey.shareUrlKey: shareUrl,
                           ShareKey.shareTitleKey: articleModel[indexPath.row].articleTitle,
                           ShareKey.shareDescribtionKey: articleModel[indexPath.row].articleContent,
                           ShareKey.shareImageUrlKey: articleModel[indexPath.row].articlePic
            ]
            let normalArticleDetailController = NormalArticleDetailController(conTitle: conTitle, content: content)
            navigationController?.pushViewController(normalArticleDetailController, animated: true)
        }
    }
}

// MARK: - Getters and Setters
extension ArticleCollectionController {
    fileprivate var articleCollectionView: UICollectionView {
        if _articleCollectionView == nil {
            let articleCollectionFlowLayout = ArticleCollectionFlowLayout()
            _articleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: articleCollectionFlowLayout)
            _articleCollectionView?.register(TataCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TataCollectionViewCell.self))
            _articleCollectionView?.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ArticleCollectionViewCell.self))
            _articleCollectionView?.showsVerticalScrollIndicator = false
            _articleCollectionView?.showsHorizontalScrollIndicator = false
            _articleCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _articleCollectionView!
        }
        
        return _articleCollectionView!
    }
}
