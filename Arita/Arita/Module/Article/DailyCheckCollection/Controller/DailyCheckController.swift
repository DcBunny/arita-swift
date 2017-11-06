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
 DailyCheckController **日签打卡机**页主页
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(_ tataInfo: ArticleHomeModel) {
        self.todayTata = tataInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "日签打卡机", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(dailyCheckCollectionView)
        view.addSubview(shareButton)
    }
    
    private func layoutPageViews() {
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
        let shareUrl = API.articleDetailUrl + idArray[currentIndex!.row]
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
    
    // MARK: - Controller Attributes
    fileprivate var _dailyCheckCollectionView: UICollectionView?
    fileprivate var _shareButton: UIButton?
    fileprivate var articleAPIManager = ArticleAPIManager()
    fileprivate var todayTata: ArticleHomeModel
    fileprivate var isScrolling = false
    fileprivate var currentIndex: IndexPath? = IndexPath(item: 0, section: 0)
    fileprivate var idArray: [String] = [String]()
    fileprivate var titleArray = [String]()
    fileprivate var descriptionArray = [String]()
    fileprivate var imageUrlArray = [String]()
}

// MARK: - ONAPIManagerParamSource
extension DailyCheckController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["timestamp": 0, "articlesNum": 1000, "channel_ID": 44]
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension DailyCheckController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        let items = json["articleArrNew"].arrayValue
        for item in items {
            idArray.append(item["ID"].stringValue)
            titleArray.append(item["title"].stringValue)
            descriptionArray.append(item["description"].stringValue)
            imageUrlArray.append(item["thumb_path"].stringValue)
        }
        dailyCheckCollectionView.reloadData()
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
