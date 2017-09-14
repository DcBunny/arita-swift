//
//  ViewController.swift
//  Arita
//
//  Created by 李宏博 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 Navigation Bar的样式
 */
enum NaviType {
    /// 默认模式，包含左返回键，无分割线
    case normal
    /// 自定义
    case custom
    /// 空白且无分割线
    case blank
    /// 隐藏导航栏
    case none
}

/**
 Navigation Bar的Back 按钮的返回方式
 */
enum BackType {
    case pop
    case dismiss
}

/**
 BaseController 为OneApp的基类，主要提供导航栏定制的功能
 */
class BaseController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaseConditions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controller Settings
    private func setBaseConditions() {
        view.backgroundColor = Color.hexf5f5f5
        
        navigationController?.navigationBar.isTranslucent = false // 关闭导航栏半透明效果
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        edgesForExtendedLayout = UIRectEdge()
        
        hideShadowImage()
        setNaviBarBackground(color: Color.hexf5f5f5Alpha95!)
        setNaviBar(type: .custom)   // 默认custom
    }
    
    // MARK: - Public Methods
    /**
     设置当前 Navigation Bar 背景色
     
     - parameter color: 背景色
     */
    public func setNaviBarBackground(color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
    }
    
    /**
     设置当前 Navigation Bar 标题
     
     - parameter title: 标题
     */
    public func setNaviBar(title: String?, font: UIFont?) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        titleLabel.text = title
        if font != nil {
            titleLabel.font = font
        } else {
            titleLabel.font = Font.size16L
        }
        titleLabel.textColor = Color.hex4a4a4a
        titleLabel.textAlignment = .center
        navigationItem.titleView = titleLabel
    }
    
    /**
     设置当前 Navigation Bar 样式
     
     - parameter type: navigationBar的样式
     
     - .normal:
     
     一般样式，左侧有返回键，pop弹出(可更换为dismiss)，无分割线
     
     可设置右侧item为文字按钮或者图片按钮
     
     可实现:
     ```
     setNaviRightTextBtn(_ text:, action:)
     ```
     设置右侧文字按钮
     
     可实现:
     ```
     setNaviRightIconBtn(_ icon:, action:)
     ```
     设置右侧按钮图标
     
     可设置左侧返回键颜色以及返回方式
     
     可实现:
     ```
     setBackBtn(_ color:, action:)
     ```
     更改返回键样式
     
     - .custom:
     
     默认自定义导航栏样式，左侧无返回键，有分割线，可定义两侧文字按钮或图标按钮
     
     可实现:
     ```
     setNaviItem(_ leftItem: String?, leftAction: Selector, rightItem: String?, rightAction: Selector)
     ```
     设置两侧Item及点击事件(推荐)
     
     也可以实现:
     ```
     setTitleView(_ titleView: UIVIew)
     setNavi(leftText: String, leftAction: Selector, rightText: String, rightAction: Selector)
     setNavi(leftText: String, leftAction: Selector, rightIcon: UIImage, rightAction: Selector)
     setNavi(leftIcon: UIImage, leftAction: Selector, rightIcon: UIImage, rightAction: Selector)
     setNavi(leftIcon: UIImage, leftAction: Selector, rightText: String, rightAction: Selector)
     ```
     
     - .blank:
     
     空白导航栏样式，左侧无返回键，无分割线，可定义两侧文字按钮或图标按钮
     
     可实现:
     ```
     setNaviItem(_ leftItem: String?, leftAction: Selector, rightItem: String?, rightAction: Selector)
     ```
     设置两侧Item及点击事件(推荐)
     
     也可以实现:
     ```
     setNavi(leftText: String, leftAction: Selector, rightText: String, rightAction: Selector)
     setNavi(leftText: String, leftAction: Selector, rightIcon: UIImage, rightAction: Selector)
     setNavi(leftIcon: UIImage, leftAction: Selector, rightIcon: UIImage, rightAction: Selector)
     setNavi(leftIcon: UIImage, leftAction: Selector, rightText: String, rightAction: Selector)
     ```
     - .none:
     
     隐藏导航栏
     
     */
    public func setNaviBar(type: NaviType) {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        removeBarItem()
        
        switch type {
            
        case .normal:
            hideShadowImage()
            setBackBtn(.pop)
            
        case .custom:
            
            setBorderColor()
            
        case .blank:
            
            hideShadowImage()
            
        case .none:
            hideShadowImage()
            navigationController?.setNavigationBarHidden(true, animated: false)
            
        }
    }
    
    // MARK: - ================== For Normal ==================
    /**
     设置当前 Navigation 返回按钮
     
     - parameter backType: 返回的方式(pop或者dismiss)
     
     */
    public func setBackBtn(_ backType: BackType) {
        let icon = UIImage(named: Icon.back)
        let barBtnItem: UIBarButtonItem!
        
        switch backType {
            
        case .pop:
            barBtnItem = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysOriginal),
                                         style: .plain, target: self, action: #selector(pop))
            
        case .dismiss:
            barBtnItem = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysOriginal),
                                         style: .plain, target: self, action: #selector(viewDismiss))
            
        }
        
        navigationItem.leftBarButtonItem = barBtnItem
    }
    
    /**
     设置当前 Navigation 右侧图片按钮
     
     - parameter icon: 按钮图标
     - parameter action: 点击事件
     */
    public func setNaviRightIconBtn(_ icon: UIImage, action: Selector) {
        
        let barBtnItem = UIBarButtonItem(image: icon.withRenderingMode(.alwaysOriginal),
                                         style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = barBtnItem
    }
    
    /**
     设置当前 Navigation 右侧文字按钮
     
     - parameter text: 按钮标题
     - parameter action: 点击事件
     */
    public func setNaviRightTextBtn(_ text: String, action: Selector) {
        let barBtnItem = UIBarButtonItem(title: text, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = barBtnItem
    }
    
    // MARK: - ============== For Custom And Blank ==============
    /**
     设置当前 Navigation 的标题试图
     
     - parameter titleView: 标题试图
     */
    public func setTitleView(_ titleView: UIView?) {
        navigationItem.titleView = titleView
    }
    
    /**
     设置当前 Navigation 左侧和右侧Item样式，Item可为文字或者图标
     如果Item文字按钮，请输入文本(String)，如果Item为图标，请输入图标名称(String)
     
     - parameter leftItem: 左侧Item
     - parameter leftAction: 左侧Item点击事件
     - parameter rightItem: 右侧Item
     - parameter rightAction: 右侧Item点击事件
     */
    public func setNaviItem(_ leftItem: String?, leftAction: Selector, rightItem: String?, rightAction: Selector) {
        if leftItem != nil {
            if let image = UIImage(named: leftItem!) {
                let leftBarBtnItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal),
                                                     style: .plain, target: self, action: leftAction)
                navigationItem.rightBarButtonItem = leftBarBtnItem
            } else {
                let leftBarBtnItem = UIBarButtonItem(title: leftItem, style: .plain, target: self, action: leftAction)
                navigationItem.leftBarButtonItem = leftBarBtnItem
            }
        }
        
        if rightItem != nil {
            if let image = UIImage(named: rightItem!) {
                let rightBarBtnItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal),
                                                      style: .plain, target: self, action: rightAction)
                navigationItem.rightBarButtonItem = rightBarBtnItem
            } else {
                let rightBarBtnItem = UIBarButtonItem(title: rightItem, style: .plain, target: self, action: rightAction)
                rightBarBtnItem.isEnabled = false
                navigationItem.rightBarButtonItem = rightBarBtnItem
            }
        }
    }
    
    /**
     设置当前 Navigation 左侧和右侧文字按钮
     优先使用 setNaviItem(, leftAction: , rightItem: , rightAction: )方法
     
     - parameter leftText: 左侧文字标题
     - parameter leftAction: 左侧文字点击事件
     - parameter rightText: 右侧文字标题
     - parameter rightAction: 右侧文字点击事件
     */
    public func setNavi(leftText: String, leftAction: Selector, rightText: String, rightAction: Selector) {
        
        let leftBarBtnItem = UIBarButtonItem(title: leftText, style: .plain, target: self, action: leftAction)
        navigationItem.leftBarButtonItem = leftBarBtnItem
        
        let rightBarBtnItem = UIBarButtonItem(title: rightText, style: .plain, target: self, action: rightAction)
        rightBarBtnItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    
    /**
     设置当前 Navigation 左侧文字按钮和右侧图标按钮
     优先使用 setNaviItem(, leftAction: , rightItem: , rightAction: )方法
     
     - parameter leftText: 左侧文字标题
     - parameter leftAction: 左侧文字点击事件
     - parameter rightIcon: 右侧图标
     - parameter rightAction: 右侧图标点击事件
     */
    public func setNavi(leftText: String, leftAction: Selector, rightIcon: UIImage, rightAction: Selector) {
        
        let leftBarBtnItem = UIBarButtonItem(title: leftText, style: .plain, target: self, action: leftAction)
        navigationItem.leftBarButtonItem = leftBarBtnItem
        
        let rightBarBtnItem = UIBarButtonItem(image: rightIcon.withRenderingMode(.alwaysOriginal),
                                              style: .plain, target: self, action: rightAction)
        navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    
    /**
     设置当前 Navigation 左侧图标按钮和右侧图标按钮
     优先使用 setNaviItem(, leftAction: , rightItem: , rightAction: )方法
     
     - parameter leftIcon: 左侧图标
     - parameter leftAction: 左侧图标点击事件
     - parameter rightIcon: 右侧图标
     - parameter rightAction: 右侧图标点击事件
     */
    public func setNavi(leftIcon: UIImage, leftAction: Selector, rightIcon: UIImage, rightAction: Selector) {
        
        let leftBarBtnItem = UIBarButtonItem(image: leftIcon.withRenderingMode(.alwaysOriginal),
                                             style: .plain, target: self, action: leftAction)
        navigationItem.leftBarButtonItem = leftBarBtnItem
        
        let rightBarBtnItem = UIBarButtonItem(image: rightIcon.withRenderingMode(.alwaysOriginal),
                                              style: .plain, target: self, action: rightAction)
        navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    
    /**
     设置当前 Navigation 左侧图标按钮和右侧文字按钮
     优先使用 setNaviItem(, leftAction: , rightItem: , rightAction: )方法
     
     - parameter leftIcon: 左侧图标
     - parameter leftAction: 左侧图标点击事件
     - parameter rightText: 右侧文字
     - parameter rightAction: 右侧文字点击事件
     */
    public func setNavi(leftIcon: UIImage, leftAction: Selector, rightText: String, rightAction: Selector) {
        
        let leftBarBtnItem = UIBarButtonItem(image: leftIcon.withRenderingMode(.alwaysOriginal),
                                             style: .plain, target: self, action: leftAction)
        navigationItem.rightBarButtonItem = leftBarBtnItem
        
        let rightBarBtnItem = UIBarButtonItem(title: rightText, style: .plain, target: self, action: rightAction)
        rightBarBtnItem.isEnabled = false
        navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    
    @objc func viewDismiss() {
        if let topViewController = UIApplication.topViewController() {
            topViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    @objc private func pop() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// 移除所有item
    private func removeBarItem() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    /// 隐藏导航条的边线
    private func hideShadowImage() {
        navigationController?.navigationBar.setBackgroundImage(Color.hexf5f5f5Alpha95!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale), isCircle: false), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /// 设置导航条的边线颜色
    private func setBorderColor() {
        navigationController?.navigationBar.setBackgroundImage(Color.hexf5f5f5Alpha95!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale), isCircle: false), for: .default)
        navigationController?.navigationBar.shadowImage = Color.hexe4e4e4!.imageWithColorAndSize(CGSize(width: 1 / UIScreen.main.scale, height: 1 / UIScreen.main.scale), isCircle: false)
    }
}
