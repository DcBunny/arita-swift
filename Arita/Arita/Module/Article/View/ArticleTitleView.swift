//
//  ArticleTitleView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleTitleView **文章**页标题日期试图
 */
class ArticleTitleView: UIView {

    // MARK: - Init Methods
    init(_ titleText: String!) {
        self.titleText = titleText
        
        super.init(frame: CGRect.zero)
        
        addPageViews()
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        addSubview(titleLabel)
        addSubview(leftSeperator)
        addSubview(rightSeperator)
    }
    
    private func layoutPageViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.center.equalTo(self)
        }
        
        leftSeperator.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.height.equalTo(1 / Size.screenScale)
            ConstraintMaker.centerY.equalTo(titleLabel)
            ConstraintMaker.width.equalTo(18)
            ConstraintMaker.right.equalTo(titleLabel.snp.left).offset(-20)
        }
        
        rightSeperator.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.height.equalTo(1 / Size.screenScale)
            ConstraintMaker.centerY.equalTo(titleLabel)
            ConstraintMaker.width.equalTo(18)
            ConstraintMaker.left.equalTo(titleLabel.snp.right).offset(20)
        }

    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _leftSeperator: UIView?
    fileprivate var _rightSeperator: UIView?
    fileprivate var titleText: String!
}

// MARK: - Getters and Setters
extension ArticleTitleView {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hexe57e33
            _titleLabel?.textAlignment = .center
            let attributes = [NSFontAttributeName: Font.size20D!,
                             NSKernAttributeName: 4] as [String : Any]
            _titleLabel?.attributedText = NSAttributedString(string: titleText, attributes: attributes)
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var leftSeperator: UIView {
        if _leftSeperator == nil {
            _leftSeperator = UIView()
            _leftSeperator?.backgroundColor = Color.hexea9120
            
            return _leftSeperator!
        }
        
        return _leftSeperator!
    }
    
    fileprivate var rightSeperator: UIView {
        if _rightSeperator == nil {
            _rightSeperator = UIView()
            _rightSeperator?.backgroundColor = Color.hexea9120
            
            return _rightSeperator!
        }
        
        return _rightSeperator!
    }

}
