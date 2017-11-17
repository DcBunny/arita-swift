//
//  ThirdLoginReusableView.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/17.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ThirdLoginReusableView: UICollectionReusableView {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addHeaderViews()
        layoutHeaderViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addHeaderViews() {
        addSubview(leftLine)
        addSubview(titleLabel)
        addSubview(rightLine)
    }
    
    private func layoutHeaderViews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        
        leftLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(self)
            make.right.equalTo(titleLabel.snp.left).offset(-10)
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(self)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _leftLine: UIView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _rightLine: UIView?
}

// MARK: - Getters and Setters
extension ThirdLoginReusableView {
    
    fileprivate var leftLine: UIView {
        if _leftLine == nil {
            _leftLine = UIView()
            _leftLine?.backgroundColor = Color.hexe4e4e4
        }
        
        return _leftLine!
    }
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.text = "使用社交账号登录"
            _titleLabel?.textColor = Color.hex919191
            _titleLabel?.font = Font.size12
        }
        
        return _titleLabel!
    }
    
    fileprivate var rightLine: UIView {
        if _rightLine == nil {
            _rightLine = UIView()
            _rightLine?.backgroundColor = Color.hexe4e4e4
        }
        
        return _rightLine!
    }
}
