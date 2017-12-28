//
//  BaseCollectionView.swift
//  Arita
//
//  Created by 潘东 on 2017/12/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/// 解决右滑与scrollView手势冲突
class BaseCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func panBack(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let locationX: CGFloat = 40
        if gestureRecognizer == self.panGestureRecognizer {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let point = pan.translation(in: self)
            let state = gestureRecognizer.state

            if state == .began || state == .possible {
                let location = gestureRecognizer.location(in: self)

                if point.x > 0 && location.x < locationX && self.contentOffset.x <= 0 {
                    return true
                }
            }
        }

        return false
    }
}

extension BaseCollectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer) {
            return true
        }

        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.panBack(gestureRecognizer) {
            return false
        }

        return true
    }
}
