//
//  ArticleSectionHeaderView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ArticleSectionHeaderView: UITableViewHeaderFooterView {

    // MARK: - Init Methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addHeaderViews()
        layoutHeaderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addHeaderViews() {
        addSubview(DateTitleLabel)
        addSubview(leftSeperator)
        addSubview(rightSeperator)
    }
    
    private func layoutHeaderViews() {
        DateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(40)
            make.bottom.centerX.equalTo(self)
            make.left.equalTo(leftSeperator.snp.right).offset(20)
            make.right.equalTo(rightSeperator.snp.left).offset(-20)
        }
        
        leftSeperator.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.height.equalTo(1 / UIScreen.main.scale)
            make.centerY.equalTo(DateTitleLabel)
            make.right.equalTo(DateTitleLabel.snp.left).offset(-20)
        }
        
        rightSeperator.snp.makeConstraints { (make) in
            make.width.equalTo(35)
            make.height.equalTo(1 / UIScreen.main.scale)
            make.centerY.equalTo(DateTitleLabel)
            make.left.equalTo(DateTitleLabel.snp.right).offset(20)
        }
    }
    
    // MARK: - Public Attributes
    public var date: String? = "" {
        didSet {
            DateTitleLabel.attributedText = date?.convertDateString()
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _DateTitleLabel: UILabel?
    fileprivate var _leftSeperator: UIView?
    fileprivate var _rightSeperator: UIView?
}

// MARK: - Getters and Setters
extension ArticleSectionHeaderView {
    fileprivate var DateTitleLabel: UILabel {
        if _DateTitleLabel == nil {
            _DateTitleLabel = UILabel()
            _DateTitleLabel?.textAlignment = .center
            
            return _DateTitleLabel!
        }
        
        return _DateTitleLabel!
    }
    
    fileprivate var leftSeperator: UIView {
        if _leftSeperator == nil {
            _leftSeperator = UIView()
            _leftSeperator?.backgroundColor = Color.hexea9120!
            
            return _leftSeperator!
        }
        
        return _leftSeperator!
    }
    
    fileprivate var rightSeperator: UIView {
        if _rightSeperator == nil {
            _rightSeperator = UIView()
            _rightSeperator?.backgroundColor = Color.hexea9120!
            
            return _rightSeperator!
        }
        
        return _rightSeperator!
    }
}
