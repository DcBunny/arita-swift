//
//  ONCollectionView.swift
//  ONTableViewDemo
//
//  Created by 潘东 on 2017/5/10.
//  Copyright © 2017年 com.onenet.app. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    open override class func initialize() {
        // Make sure this isn't a subclass
        guard self === UICollectionView.self else { return }
        
        // Method Swizzling
        let _: () = {
            let originalSelector = #selector(self.reloadData)
            let swizzledSelector = #selector(self.on_reloadData)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }()
    }
    
    // MARK: - Private Method
    @objc private func on_reloadData() {
        if isShowPlaceholder == nil || isShowPlaceholder! {
            if firstReload != nil && firstReload! {
                checkEmpty()
            }
        }
        firstReload = true
        on_reloadData()
    }
    
    private func checkEmpty() {
        var isEmpty = true
        let dataSource: UICollectionViewDataSource? = self.dataSource
        var sections = 1    // 默认一组
        
        guard dataSource != nil else { return } // 如果没有设置dataSource，则直接返回
        
        if dataSource!.responds(to: #selector(UICollectionViewDataSource.numberOfSections(in:))) {
            sections = dataSource!.numberOfSections!(in: self)   // 获取当前collectionView的组数
        }
        
        for section in 0..<sections {
            let rows = dataSource!.collectionView(self, numberOfItemsInSection: section)
            if rows != 0 {
                isEmpty = false     // 检查每组的行数，若任意一组的行数存在，不为零，则列表不为空
            }
        }
        
        if isEmpty {
            // 若为空，则显示占位页面
            if placeholderView == nil {   // 占位页面为空，使用默认界面
                makeDefaultPlaceholderView()
            }
            placeholderView!.isHidden = false
            addSubview(placeholderView!)
            placeholderView?.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        } else {
            // 若不为空，则去除占位页面
            guard placeholderView != nil else { return }
            placeholderView!.isHidden = true
        }
    }
    
    private func makeDefaultPlaceholderView() {
        let defaultView = PlaceholderView(frame: bounds)
        defaultView.reloadClickBlock = { [weak self] in
            guard self?.reloadClosure != nil else { return }
            self?.reloadClosure!()
        }
        self.placeholderView = defaultView
    }
    
    // MARK: - Open Instance
    /**
     *  占位图
     *
     */
    open var placeholderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.PlaceholderView) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.PlaceholderView, newValue , .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     *  默认占位图点击事件的回调
     *  如不使用默认占位图，则不需要设置
     *
     */
    open var reloadClosure: (() -> ())? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.ReloadClosure) as? () -> ()
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.ReloadClosure, newValue , .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /**
     *  首次加载未完成是是否显示占位图，默认不显示
     *  设置为True，则开启显示
     *
     */
    open var firstReload: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.FirstReload) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.FirstReload, newValue , .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /**
     *  设置是否开启自动占位图功能，默认开启
     *  设置为False，则关闭自动占位图功能
     *
     */
    open var isShowPlaceholder: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociaKey.IsShowPlaceholder) as? Bool
        }
        
        set {
            objc_setAssociatedObject(self, &AssociaKey.IsShowPlaceholder, newValue , .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK: - Accociate Instance Key
    private struct AssociaKey{
        static var FirstReload: String = "firstReload"
        static var PlaceholderView: String = "placeholderView"
        static var ReloadClosure: String = "reloadClosure"
        static var IsShowPlaceholder = "isShowPlaceholder"
    }
}
