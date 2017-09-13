//
//  GuideController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SnapKit

/**
 GuideController **引导**页试图控制器
 */
class GuideController: BaseController {
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
    /**
     初始化GuideController方法。
     - parameter pics: 引导页的图片名称数组。
     */
    init(pics: [String]) {
        super.init(nibName: nil, bundle: nil)
        
        self.pics = pics
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
//        setNaviBar(type: .none)
    }
    
    private func addPageViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(comfirmButton)
    }
    
    private func layoutPageViews() {
        scrollView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        //根据数据数量来动态创建视图
        guard pics.count != 0 else { return }
        let size = pics.count
        
        for count in 0 ..< size {
            let imageView = UIImageView()
            
            //设置左边距离，根据数据对应数组的位置
            let lBounds = Size.screenWidth * CGFloat(count)
            imageView.frame = CGRect(x: lBounds, y: 0, width: Size.screenWidth, height: Size.screenHeight)
            
            let path = pics[count]
            let image = UIImage(named: path as String)
            imageView.image = image
            
            //添加button
            let btnLBounds = Size.screenWidth * CGFloat(size - 1)
            comfirmButton.frame = CGRect(x: btnLBounds, y: 0, width: Size.screenWidth, height: Size.screenHeight)
            
            //把视图加入到scrollView中
            self.scrollView.addSubview(imageView)
            self.scrollView.addSubview(comfirmButton)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _scrollView: UIScrollView?
    fileprivate var _comfirmButton: UIButton?
    
    fileprivate var pics: [String] = []
}

// MARK: - Getters and Setters
extension GuideController {
    fileprivate var scrollView: UIScrollView {
        if _scrollView == nil {
            _scrollView = UIScrollView()
            _scrollView?.isPagingEnabled = true
            _scrollView?.showsVerticalScrollIndicator = false
            _scrollView?.showsHorizontalScrollIndicator = false
            _scrollView?.bounces = false
            _scrollView?.contentSize = CGSize(width: Size.screenWidth * CGFloat(pics.count), height: Size.screenHeight)
            
            return _scrollView!
        }
        
        return _scrollView!
    }
    
    var comfirmButton: UIButton {
        if _comfirmButton == nil {
            _comfirmButton = UIButton()
            _comfirmButton?.backgroundColor = UIColor.clear
            
            return _comfirmButton!
        }
        
        return _comfirmButton!
    }
}
