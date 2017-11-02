//
//  DailyCheckController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

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
        DispatchQueue.main.async {
//            let shareController = ShareController()
//            shareController.modalTransitionStyle = .crossDissolve
//            shareController.providesPresentationContextTransitionStyle = true
//            shareController.definesPresentationContext = true
//            shareController.modalPresentationStyle = .overFullScreen
//            self.present(shareController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var _dailyCheckCollectionView: UICollectionView?
    fileprivate var _shareButton: UIButton?
    fileprivate var articleAPIManager = ArticleAPIManager()
    fileprivate var todayTata: ArticleHomeModel
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
//        if isFirst {
//            articleModel.removeAll()
//            isFirst = false
//        }
//        if manager is TataBaoAPIManager {
//            let data = manager.fetchDataWithReformer(nil)
//            let viewModel = ArticleViewModel(data: data)
//            articleModel = viewModel.articles
//            totalCount = viewModel.totalCount
//            articleCollectionView.reloadData()
//        } else if manager is ArticleAPIManager {
//            let data = manager.fetchDataWithReformer(nil)
//            let viewModel = NormalArticleViewModel(data: data)
//            articleModel = viewModel.articles
//            totalCount = viewModel.totalCount
//            articleCollectionView.reloadData()
//        }
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DailyCheckCell.self), for: indexPath) as! DailyCheckCell
        cell.dailyImage = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=123028776,535225046&fm=27&gp=0.jpg"
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension DailyCheckController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
