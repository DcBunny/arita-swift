//
//  ArticleDetailController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 ArticleDetailController **塔塔报文章详情列表**页主页
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
        if #available(iOS 11.0, *) {
            articleDetailCollectionView.snp.makeConstraints({ (make) in
                make.edges.equalTo(view.safeAreaInsets)
            })
        } else {
            articleDetailCollectionView.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
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
        let shareUrl = API.articleDetailUrl + idArray[currentIndex!.row]
        let content = [ShareKey.shareUrlKey: shareUrl,
                       ShareKey.shareTitleKey: titleArray[currentIndex!.row],
                       ShareKey.shareDescribtionKey: descriptionArray[currentIndex!.row],
                       ShareKey.shareImageUrlKey: imageUrlArray[currentIndex!.row]
        ]
        guard !isScrolling else { return }
        DispatchQueue.main.async {
            let shareController = ShareController(content: content, isImage: false)
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            self.present(shareController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func pageWith() -> Float {
        return Float((self.articleDetailCollectionView.collectionViewLayout as! ArticleDetailFlowLayout).itemSize.width + (self.articleDetailCollectionView.collectionViewLayout as! ArticleDetailFlowLayout).minimumLineSpacing)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _articleDetailCollectionView: BaseCollectionView?
    fileprivate var conTitle: String?
    fileprivate var time: String
    fileprivate var isScrolling = false
    fileprivate var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
    fileprivate var tatabaoDetailAPIManager = TataBaoDetailAPIManager()
    fileprivate var idArray: [String] = [String]()
    fileprivate var titleArray = [String]()
    fileprivate var descriptionArray = [String]()
    fileprivate var imageUrlArray = [String]()
    fileprivate var currentPage = 0
}

// MARK: - ONAPIManagerParamSource
extension ArticleDetailController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["time": self.time]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension ArticleDetailController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data).arrayValue
        for item in json {
            idArray.append(item["ID"].stringValue)
            titleArray.append(item["title"].stringValue)
            descriptionArray.append(item["description"].stringValue)
            imageUrlArray.append(item["thumb_path"].stringValue)
        }
        articleDetailCollectionView.reloadData()
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
        currentPage = Int(floor((Float(self.articleDetailCollectionView.contentOffset.x) - pageWith() / 2) / pageWith())) + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.articleDetailCollectionView.contentSize.width)
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

// MARK: - Getters and Setters
extension ArticleDetailController {
    fileprivate var articleDetailCollectionView: BaseCollectionView {
        if _articleDetailCollectionView == nil {
            let articleDetailFlowLayout = ArticleDetailFlowLayout()
            _articleDetailCollectionView = BaseCollectionView(frame: CGRect.zero, collectionViewLayout: articleDetailFlowLayout)
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
