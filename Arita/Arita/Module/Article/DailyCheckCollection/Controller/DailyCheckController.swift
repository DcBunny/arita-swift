//
//  DailyCheckController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

/**
 DailyCheckController **日签打卡机/乐活段子**页主页
 */
class DailyCheckController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 极光推送
        let pushJudge = UserDefaults.standard
        if let push = pushJudge.object(forKey: "push") as? String {
            if push == "push" {
                let pushJudge = UserDefaults.standard
                pushJudge.set("", forKey: "push")
                pushJudge.synchronize()
                setBackBtn(.dismiss)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with articleID: Int?, channelID: Int!) {
        self.articleID = articleID
        self.channelID = channelID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        if channelID == 44 {
            setNaviBar(title: "日签打卡机", font: Font.size15)
        } else if channelID == 34 {
            setNaviBar(title: "乐活段子", font: Font.size15)
        }
    }
    
    private func addPageViews() {
        view.addSubview(dailyCheckCollectionView)
        view.addSubview(shareButton)
    }
    
    private func layoutPageViews() {
        if #available(iOS 11.0, *) {
            dailyCheckCollectionView.snp.makeConstraints { (make) in
                make.left.right.equalTo(view)
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.bottom.equalTo(shareButton.snp.top).offset(-20)
            }
            
            shareButton.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 44, height: 44))
                make.top.equalTo(dailyCheckCollectionView.snp.bottom).offset(20)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            }
        } else {
            dailyCheckCollectionView.snp.makeConstraints { (make) in
                make.top.left.right.equalTo(view)
                make.bottom.equalTo(shareButton.snp.top).offset(-20)
            }
            
            shareButton.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 44, height: 44))
                make.top.equalTo(dailyCheckCollectionView.snp.bottom).offset(20)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view).offset(-20)
            }
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = Color.hexf5f5f5!
        dailyCheckCollectionView.backgroundColor = UIColor.clear
        dailyCheckCollectionView.delegate = self
        dailyCheckCollectionView.dataSource = self
        
        articleAPIManager.delegate = self
        articleAPIManager.paramSource = self
    }
    
    private func loadData() {
        articleAPIManager.loadData()
    }
    
    // MARK: - Event Responses
    @objc fileprivate func gotoShare() {
        if currentIndex == nil { currentIndex = IndexPath(item: 0, section: 0) }
        let shareUrl = API.articleDetailUrl + "\(idArray[currentIndex!.row])"
        let content = [ShareKey.shareUrlKey: shareUrl,
                       ShareKey.shareTitleKey: titleArray[currentIndex!.row],
                       ShareKey.shareDescribtionKey: descriptionArray[currentIndex!.row],
                       ShareKey.shareImageUrlKey: imageUrlArray[currentIndex!.row]
        ]
        guard !isScrolling else { return }
        DispatchQueue.main.async {
            let shareController = ShareController(content: content)
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            self.present(shareController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    fileprivate func pageWith() -> Float {
        return Float((self.dailyCheckCollectionView.collectionViewLayout as! DailyCheckFlowLayout).itemSize.width + (self.dailyCheckCollectionView.collectionViewLayout as! DailyCheckFlowLayout).minimumLineSpacing)
    }
    
    fileprivate func positionArticle() {
        var currentIndex: Int?
        for (index, value) in idArray.enumerated() {
            if self.articleID! == value {
                currentIndex = index
            }
        }
        
        guard currentIndex != nil else { return }
        dailyCheckCollectionView.scrollToItem(at: IndexPath(row: currentIndex!, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _dailyCheckCollectionView: UICollectionView?
    fileprivate var _shareButton: UIButton?
    fileprivate var articleAPIManager = ArticleAPIManager()
    fileprivate var isScrolling = false
    fileprivate var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
    fileprivate var idArray: [Int] = [Int]()
    fileprivate var titleArray = [String]()
    fileprivate var descriptionArray = [String]()
    fileprivate var imageUrlArray = [String]()
    fileprivate var currentPage = 0
    fileprivate var articleID: Int?
    fileprivate var channelID: Int!
}

// MARK: - ONAPIManagerParamSource
extension DailyCheckController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["timestamp": 0, "articlesNum": 100, "channel_ID": channelID]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension DailyCheckController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        let items = json["articleArrNew"].arrayValue
        for item in items {
            idArray.append(item["ID"].intValue)
            titleArray.append(item["title"].stringValue)
            descriptionArray.append(item["description"].stringValue)
            imageUrlArray.append(item["thumb_path"].stringValue)
        }
        dailyCheckCollectionView.reloadData()
        if self.articleID != nil {  // 说明是从首页列表进入的，需要定位
            positionArticle()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - UICollecitonView Data Source
extension DailyCheckController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DailyCheckCell.self), for: indexPath) as! DailyCheckCell
        cell.dailyImage = imageUrlArray[indexPath.row]
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension DailyCheckController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UIScrollView Delegate
extension DailyCheckController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pInView = self.view.convert(self.dailyCheckCollectionView.center, to: self.dailyCheckCollectionView)
        let indexNow = self.dailyCheckCollectionView.indexPathForItem(at: pInView)
        currentIndex = indexNow
        isScrolling = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        currentPage = Int(floor((Float(self.dailyCheckCollectionView.contentOffset.x) - pageWith() / 2) / pageWith())) + 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(self.dailyCheckCollectionView.contentSize.width)
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
extension DailyCheckController {
    fileprivate var dailyCheckCollectionView: UICollectionView {
        if _dailyCheckCollectionView == nil {
            let dailyCheckFlowLayout = DailyCheckFlowLayout()
            _dailyCheckCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: dailyCheckFlowLayout)
            _dailyCheckCollectionView?.register(DailyCheckCell.self, forCellWithReuseIdentifier: String(describing: DailyCheckCell.self))
            _dailyCheckCollectionView?.showsVerticalScrollIndicator = false
            _dailyCheckCollectionView?.showsHorizontalScrollIndicator = false
            _dailyCheckCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            
            return _dailyCheckCollectionView!
        }
        
        return _dailyCheckCollectionView!
    }
    
    fileprivate var shareButton: UIButton {
        if _shareButton == nil {
            _shareButton = UIButton()
            _shareButton?.setImage(UIImage(named: Icon.shareButton), for: .normal)
            _shareButton?.setImage(UIImage(named: Icon.shareButton), for: .highlighted)
            _shareButton?.addTarget(self, action: #selector(gotoShare), for: .touchUpInside)
            
            return _shareButton!
        }
        
        return _shareButton!
    }
}
