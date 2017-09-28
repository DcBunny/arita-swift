//
//  ArticleTitleView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleTitleView **文章**页标题日期试图(暂时不用)）
 */
class ArticleTitleView: UIView {

    // MARK: - Init Methods
    init(_ titleImage: String!) {
        self.titleImageName = titleImage
        
        super.init(frame: CGRect.zero)
        
        addPageViews()
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        addSubview(titleImage)
    }
    
    private func layoutPageViews() {
        titleImage.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.center.equalTo(self)
            ConstraintMaker.size.equalTo(CGSize(width: 80, height: 21))
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleImage: UIImageView?
    fileprivate var titleImageName: String!
}

// MARK: - Getters and Setters
extension ArticleTitleView {
    fileprivate var titleImage: UIImageView {
        if _titleImage == nil {
            _titleImage = UIImageView()
            _titleImage?.image = UIImage(named: titleImageName)
            
            return _titleImage!
        }
        
        return _titleImage!
    }
}
