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
   func convertToImage() -> UIImage?
}

/// 扩展UIImage为九宫格数据类型
extension UIImage: JGGGridViewDataType {
    func convertToImage() -> UIImage? {
        return self
    }
}

/// 扩展String为九宫格数据类型
extension String: JGGGridViewDataType {
    func convertToImage() -> UIImage? {
        if let image = UIImage(named: self) {
            return image
        } else {
            if let url = URL(string: self) {
                do {
                    let data = try Data(contentsOf: url)
                    return UIImage(data: data)
                } catch {
                    return nil
                }
            }
            
            return nil
        }
    }
}

/// 扩展URL为九宫格数据类型
extension URL: JGGGridViewDataType {
    func convertToImage() -> UIImage? {
        do {
            let data = try Data(contentsOf: self)
            return UIImage(data: data)
        } catch {
            return nil
        }
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
         
         - Parameter gridView: 用以通知代理的 JGGGridView 类型的对象
         - Parameter index: 当前选择的 item 的位置
         - Returns: 九宫格图片
     */
    func gridView(_ gridView: JGGGridView, imageForItemAt index: Int) -> JGGGridViewDataType
    
    // MARK: Optional
    /**
        九宫格图片的数量，未实现的话默认返回是0
        
        **@Optional**
     
        - Parameter gridView: 用以通知代理的 JGGGridView 类型的对象
        - Returns: 九宫格图片数量(0-9)，不得大于9，否则以9为准
     */
    func numberOfItems(in gridView: JGGGridView) -> Int // Default is 0 if not implemented
    
    /**
        九宫格图片的间隔，未实现的话默认返回是5
         
        **@Optional**
     
        - Parameter gridView: 用以通知代理的 JGGGridView 类型的对象
        - Returns: 九宫格图片间隔
     */
    func gapBetweenItems(in gridView: JGGGridView) -> Int // Default is 5 if not implemented
    // TODO: DAXIAO
    /**
     九宫格图片的大小，默认图片宽高比1：1，大小为.
     
     **@Optional**
     
     - Parameter gridView: 用以通知代理的 JGGGridView 类型的对象
     - Returns: 九宫格图片大小
     */
    func sizeOfItems(in gridView: JGGGridView) -> CGSize
}

extension JGGGridViewDataSource {
    func numberOfItems(in gridView: JGGGridView) -> Int {
        return 0
    }
    
    func gapBetweenItems(in gridView: JGGGridView) -> Int {
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
    
    ///九宫格显示的数据源
    public var dataSource: JGGGridViewDataSource?
    ///九宫格视图代理
    public var delegate: JGGGridViewDelegate?
}
