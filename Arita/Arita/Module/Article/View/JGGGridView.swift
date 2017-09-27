//
//  JGGGridView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/// 九宫格数据类型
protocol JGGGridViewDataType {
   func convertToImage() -> UIImageView
}

/// 扩展UIImage为九宫格数据类型
extension UIImage: JGGGridViewDataType {
    func convertToImage() -> UIImageView {
        return UIImageView(image: self)
    }
}

/// 扩展String为九宫格数据类型
extension String: JGGGridViewDataType {
    func convertToImage() -> UIImageView {
        if let image = UIImage(named: self) {
            return UIImageView(image: image)
        } else {
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: self))
            return imageView
        }
    }
}

/// 扩展URL为九宫格数据类型
extension URL: JGGGridViewDataType {
    func convertToImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.kf.setImage(with: self)
        return imageView
    }
}


/**
    JGGGridView 九宫格试图数据源
 */
protocol JGGGridViewDataSource: class {
    // MARK: Required
    /**
         九宫格图片，可以返回实现了 **JGGGridViewDataType**  协议的任何类型, **UIImage**, **String**, **URL** 类型已默认实现
         
         **@Required**
         
         - Parameter gridView: 用以通知代理的 `JGGGridView` 类型的对象
         - Parameter index: 当前选择的 `item` 的位置
         - Returns: 九宫格图片试图
     */
    func gridView(_ gridView: JGGGridView, imageForItemAt index: Int) -> UIImageView
    
    // MARK: Optional
    /**
        九宫格图片的数量，未实现的话默认返回是0
        
        **@Optional**
     
        - Parameter gridView: 用以通知代理的 `JGGGridView` 类型的对象
        - Returns: 九宫格图片数量(0-9)，不得大于9，否则以9为准
     */
    func numberOfItems(in gridView: JGGGridView) -> Int // Default is 0 if not implemented
    
    /**
        九宫格图片的间隔，未实现的话默认返回是5
         
        **@Optional**
     
        - Parameter gridView: 用以通知代理的 `JGGGridView` 类型的对象
        - Returns: 九宫格图片间隔
     */
    func gapBetweenItems(in gridView: JGGGridView) -> CGFloat // Default is 5 if not implemented
    /**
     九宫格图片的大小，默认图片宽高比1：1，大小为`CGSize(width: (UIScreen.main.bounds.size.width - 22) / 3, height: (UIScreen.main.bounds.size.width - 22) / 3)`。
     
     **@Optional**
     
     - Parameter gridView: 用以通知代理的 `JGGGridView` 类型的对象
     - Returns: 九宫格图片大小
     */
    func sizeOfItems(in gridView: JGGGridView) -> CGSize
}

extension JGGGridViewDataSource {
    func numberOfItems(in gridView: JGGGridView) -> Int {
        return 0
    }
    
    func gapBetweenItems(in gridView: JGGGridView) -> CGFloat {
        return 5
    }
    
    func sizeOfItems(in gridView: JGGGridView) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 22) / 3, height: (UIScreen.main.bounds.size.width - 22) / 3)
    }
}

/**
    JGGGridViewDelegate 九宫格试图代理方法
 */
protocol JGGGridViewDelegate: class {
    /**
        告诉代理在 index 位置的 item 被选择(点击)了
        
        **@Optional**
     
        - Parameter gridView: 用以通知代理的 JGGGridView 类型的对象
        - Parameter index: 当前选择的 item 的位置
     */
    func gridView(_ gridView: JGGGridView, didSelectRowIndex index: Int)
}

extension JGGGridViewDelegate {
    func gridView(_ gridView: JGGGridView, didSelectRowIndex index: Int) {
        // 默认什么也不实现
    }
}

//MARK: =================================================================================================================================================

/**
 JGGGridView 九宫格试图
 */
class JGGGridView: UIView {
    //MARK:- 初始化方法
    init(with dataSource: JGGGridViewDataSource?, and delegate: JGGGridViewDelegate?) {
        super.init(frame: CGRect.zero)
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        creatJGGView()
    }
    
    convenience init() {
        self.init(with: nil, and: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 试图设置
    public func creatJGGView() {
        guard dataSource != nil else { return }
        // 防止多次添加数据源导致重复增加UIImageView
        for subView in self.subviews {
            if subView is UIImageView {
                subView.removeFromSuperview()
                subView.gestureRecognizers?.removeAll()
            }
        }
        for index in 0..<dataSource!.numberOfItems(in: self) {
            let imageView = dataSource!.gridView(self, imageForItemAt: index)
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            addSubview(imageView)
            
            //九宫格布局
            let imageX = (imageWidth() + dataSource!.gapBetweenItems(in: self)) * CGFloat(index % 3)
            let imageY = (imageHeight() + dataSource!.gapBetweenItems(in: self)) * CGFloat(floorf(Float(index / 3)))
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth(), height: imageHeight())
            
            //九宫格点击事件
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapImageAction(tap:)))
            imageView.addGestureRecognizer(singleTap)
        }
    }
    
    @objc private func tapImageAction(tap: UITapGestureRecognizer) {
        if let imageView = tap.view as? UIImageView {
            delegate?.gridView(self, didSelectRowIndex: imageView.tag)
        }
    }
    
    //MARK: - 公开属性
    ///九宫格显示的数据源
    public var dataSource: JGGGridViewDataSource?
    ///九宫格视图代理
    public var delegate: JGGGridViewDelegate?
    
    //MARK: - 公开方法
    ///获取九宫格图片的宽
    public func imageWidth() -> CGFloat {
        if self.dataSource == nil {
            return 0
        } else {
            return self.dataSource!.sizeOfItems(in: self).width
        }
    }
    
    ///获取九宫格图片的高
    public func imageHeight() -> CGFloat {
        if self.dataSource == nil {
            return 0
        } else {
            return self.dataSource!.sizeOfItems(in: self).height
        }
    }
}
