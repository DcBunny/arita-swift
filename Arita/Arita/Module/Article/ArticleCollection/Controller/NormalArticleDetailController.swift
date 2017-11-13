//
//  NormalArticleDetailController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/31.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import WebKit

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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(conTitle: String?, content: [String: String]) {
        self.content =  content
        self.conTitle = conTitle
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
        if let url = URL(string: content[ShareKey.shareUrlKey]!) {
            let request = URLRequest(url: url)
            detailWebView.load(request)
        }
        view.backgroundColor = Color.hexf5f5f5
    }
    
    // MARK: - Event Responses
    @objc private func gotoShare() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let shareController = ShareController(content: strongSelf.content)
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            strongSelf.present(shareController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _detailWebView: WKWebView?
    private var content: [String: String]!
    private var conTitle: String?
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

