//
//  NormalArticleDetailController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/31.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge
import SwiftyJSON

/**
 NormalArticleDetailController **一般分类文章详情列表**页主页
 */
class NormalArticleDetailController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        loadData()
        setJSBridge()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(conTitle: String?, content: [String: Any], isFromHome: Bool) {
        self.content =  content
        self.conTitle = conTitle
        self.isFromHome = isFromHome
        if !isFromHome {
            self.shareContent = content as? [String: String]
        } else {
            self.shareContent = nil
        }
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
        view.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(detailWebView)
    }
    
    private func layoutPageViews() {
        if #available(iOS 11.0, *) {
            shadowView.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(6)
                make.right.equalTo(view).offset(-6)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
                make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
            }
        } else {
            shadowView.snp.makeConstraints { (make) in
                make.left.equalTo(view).offset(6)
                make.right.equalTo(view).offset(-6)
                make.top.equalTo(view).offset(5)
                make.bottom.equalTo(view).offset(-6)
            }
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        detailWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(bodyView)
        }
    }
    
    private func setPageViews() {
        if let url = URL(string: content[ShareKey.shareUrlKey] as! String) {
            let request = URLRequest(url: url)
            detailWebView.load(request)
        }
        view.backgroundColor = Color.hexf5f5f5
    }
    
    private func loadData() {
        if isFromHome {    // 如果来自首页，则说明分享数据不全，需要拉接口
            articleAPIManager.delegate = self
            articleAPIManager.paramSource = self
            articleAPIManager.loadData()
        }
    }
    
    private func setJSBridge() {
        jsBridge = WKWebViewJavascriptBridge(for: detailWebView)
        jsBridge.setWebViewDelegate(self)
        jsBridge.registerHandler("AppNativeHandler") { (data, responseCallback) in
            let json = JSON(data as Any)
            let action = json["action"].stringValue
            let data = json["data"]
            if action == "loadPage" {
                if let url = data["url"].string, let channelName = data["channel_name"].string, let title = data["title"].string, let description = data["description"].string, let pic = data["thumb_path"].string  {
                    let content = [ShareKey.shareUrlKey: url,
                                   ShareKey.shareTitleKey: title,
                                   ShareKey.shareDescribtionKey: description,
                                   ShareKey.shareImageUrlKey: pic
                    ]
                    let nextPageController = NormalArticleDetailController(conTitle: channelName, content: content, isFromHome: false)
                    self.navigationController?.pushViewController(nextPageController, animated: true)
                }
            }
        }
    }
    
    fileprivate func findArticle() {
        var currentIndex: Int?
        let articleIdArray = articleModel.map { $0.articleID }
        for (index, value) in articleIdArray.enumerated() {
            if (self.content["articleID"] as! Int) == value {
                currentIndex = index
            }
        }
        if currentIndex != nil {
            self.shareContent = [ShareKey.shareUrlKey: content[ShareKey.shareUrlKey] as! String,
                                 ShareKey.shareTitleKey: articleModel[currentIndex!].articleTitle,
                                 ShareKey.shareDescribtionKey: articleModel[currentIndex!].articleContent,
                                 ShareKey.shareImageUrlKey: articleModel[currentIndex!].articlePic
            ]
        }
    }
    // MARK: - Event Responses
    @objc private func gotoShare() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.shareContent != nil {
                let shareController = ShareController(content: strongSelf.shareContent!)
                shareController.modalTransitionStyle = .crossDissolve
                shareController.providesPresentationContextTransitionStyle = true
                shareController.definesPresentationContext = true
                shareController.modalPresentationStyle = .overFullScreen
                strongSelf.present(shareController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _detailWebView: WKWebView?
    fileprivate var content: [String: Any]!
    fileprivate var shareContent: [String: String]?
    fileprivate var articleAPIManager = ArticleAPIManager()
    fileprivate var articleModel: [ArticleModel] = [ArticleModel.initial]
    private var conTitle: String?
    private var isFromHome: Bool!
    private var jsBridge: WKWebViewJavascriptBridge!
}

// MARK: - ONAPIManagerParamSource
extension NormalArticleDetailController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if manager is ArticleAPIManager {
            return ["timestamp": 0, "articlesNum": 100, "channel_ID": self.content["channelID"] as Any]
        } else {
            return [:]
        }
    }
}

// MARK: - ONAPIManagerCallBackDelegate
extension NormalArticleDetailController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if manager is ArticleAPIManager {
            let data = manager.fetchDataWithReformer(nil)
            let viewModel = NormalArticleViewModel(data: data)
            articleModel = viewModel.articles
            findArticle()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension NormalArticleDetailController {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            _shadowView?.layer.shadowOpacity = 1.0
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var detailWebView: WKWebView {
        if _detailWebView == nil {
            _detailWebView = WKWebView(frame: CGRect.zero)
            _detailWebView?.backgroundColor = UIColor.clear
            _detailWebView?.scrollView.showsVerticalScrollIndicator = false
            _detailWebView?.scrollView.showsHorizontalScrollIndicator = false
            
            return _detailWebView!
        }
        
        return _detailWebView!
    }
}

