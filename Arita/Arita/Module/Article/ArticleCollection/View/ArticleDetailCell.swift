//
//  ArticleDetailCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import WebKit

/**
 ArticleDetailCell **文章详情列表**页的cell
 */
class ArticleDetailCell: UICollectionViewCell {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(detailWebView)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        detailWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(bodyView)
        }
    }
    
    private func setPageViews() {
        backgroundColor = Color.hexf5f5f5
    }
    
    // MARK: - Public Attributes
    public var webUrl = "https://www.baidu.com" {
        didSet {
            if let url = URL(string: webUrl) {
                let request = URLRequest(url: url)
                detailWebView.load(request)
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _detailWebView: WKWebView?
}

// MARK: - Getters and Setters
extension ArticleDetailCell {
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
