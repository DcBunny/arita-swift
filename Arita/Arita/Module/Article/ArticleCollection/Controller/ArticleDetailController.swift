//
//  ArticleDetailController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebViewJavascriptBridge

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
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with title: String?, and time: String) {
        self.conTitle = title
        self.time = time
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
        tatabaoDetailAPIManager.delegate = self
        tatabaoDetailAPIManager.paramSource = self
    }
    
    private func loadData() {
        tatabaoDetailAPIManager.loadData()
    }
    
    // MARK: - Event Responses
    @objc private func gotoShare() {
        if currentIndex == nil { currentIndex = IndexPath(item: 0, section: 0) }
        let cell = articleDetailCollectionView.cellForItem(at: currentIndex!) as! ArticleDetailCell
        cell.setJSBridge()
        let shareUrl = API.articleDetailUrl + idArray[currentIndex!.row]
        guard !isScrolling else { return }
        DispatchQueue.main.async {
            let shareController = ShareController(url: shareUrl)
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
    fileprivate var time: String
    fileprivate var isScrolling = false
    fileprivate var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
    fileprivate var tatabaoDetailAPIManager = TataBaoDetailAPIManager()
    fileprivate var idArray: [String] = [String]()
}

// MARK: - ONAPIManagerParamSource
extension ArticleDetailController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if manager is TataBaoDetailAPIManager {
            return ["time": self.time]
        } else {
            return ["time": "0"]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension ArticleDetailController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if manager is TataBaoDetailAPIManager {
            let data = manager.fetchDataWithReformer(nil)
            let json = JSON(data: data as! Data).arrayValue
            for item in json {
                idArray.append(item["article_ID"].stringValue)
            }
            articleDetailCollectionView.reloadData()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - UICollecitonView Data Source
extension ArticleDetailController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleDetailCell.self), for: indexPath) as! ArticleDetailCell
        cell.webUrl = API.articleDetailUrl + idArray[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension ArticleDetailController: UICollectionViewDelegate {
    
}

// MARK: - UIScrollView Delegate
extension ArticleDetailController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.view.convert(self.articleDetailCollectionView.center, to: self.articleDetailCollectionView)
        let indexNow = self.articleDetailCollectionView.indexPathForItem(at: pInView)
        currentIndex = indexNow
        isScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
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
            _articleDetailCollectionView?.backgroundColor = UIColor.white
            
            return _articleDetailCollectionView!
        }
        
        return _articleDetailCollectionView!
    }
}
