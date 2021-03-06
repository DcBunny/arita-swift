//
//  DailyCheckFlowLayout.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 DailyCheckFlowLayout **日签打卡机**页的FlowLayout
 */
class DailyCheckFlowLayout: UICollectionViewFlowLayout {
    //MARK: - Override Method
    override func prepare() {
        super.prepare()
        self.itemSize = CGSize(width: Size.screenWidth - 60, height: Size.screenHeight - Size.naviBarSize!.height - 99)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 15
        self.sectionInset = UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 30)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /* 自由滑动用这个
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rect = CGRect.zero
        rect.origin.x = proposedContentOffset.x
        rect.origin.y = 0
        rect.size = (self.collectionView?.frame.size)!
        
        let attributesArray = super.layoutAttributesForElements(in: rect)
        let centerX = (self.collectionView?.frame.size.width)! / 2 + proposedContentOffset.x
        var minDelta = CGFloat(MAXFLOAT)
        for attrs in attributesArray! {
            if (CGFloat(abs(minDelta)) > abs(attrs.center.x - centerX)) {
                minDelta = attrs.center.x - centerX
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + CGFloat(minDelta), y: proposedContentOffset.y)
    }
    */
}
