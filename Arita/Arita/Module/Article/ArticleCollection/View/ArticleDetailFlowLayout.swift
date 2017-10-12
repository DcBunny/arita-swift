//
//  ArticleDetailFlowLayout.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleDetailFlowLayout **文章详情列表**页的FlowLayout
 */
class ArticleDetailFlowLayout: UICollectionViewFlowLayout {
    //MARK: - Override Method
    override func prepare() {
        super.prepare()
        self.itemSize = CGSize(width: Size.screenWidth - 32, height: Size.screenHeight - Size.naviBarSize!.height - 11)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 6
        self.sectionInset = UIEdgeInsets(top: 5, left: 16, bottom: 6, right: 16)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
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
}
