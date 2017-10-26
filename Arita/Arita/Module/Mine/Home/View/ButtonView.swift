//
//  ButtonView.swift
//  Arita
//
//  Created by 潘东 on 2017/10/26.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ButtonView: UIView {

    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        calculateWidth()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        addSubview(stackView)
        stackView.addSubview(iconView)
        stackView.addSubview(titleLabel)
    }
    
    private func layoutPageViews() {
        stackView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(stackViewWidth)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.centerY.left.equalTo(stackView)
            make.right.equalTo(titleLabel.snp.left).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.centerY.equalTo(stackView)
            make.right.equalTo(stackView)
        }
    }
    
    private func setPageViews() {
        backgroundColor = Color.hexffffff
    }
    
    private func calculateWidth() {
        let size = "推荐到朋友圈".sizeForFont(Font.size16!, size: CGSize(width: self.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail)
        stackViewWidth = size.width + CGFloat(40)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _iconView: UIImageView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var stackView = UIStackView()
    fileprivate var stackViewWidth: CGFloat = 0
    public func set(image: UIImage, and title: String) {
        self.iconView.image = image
        self.titleLabel.text = title
    }
}

// MARK: - Getters and Setters
extension ButtonView {
    fileprivate var iconView: UIImageView {
        if _iconView == nil {
            _iconView = UIImageView()
            
            return _iconView!
        }
        
        return _iconView!
    }
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hex2a2a2a
            _titleLabel?.textAlignment = .left
            _titleLabel?.font = Font.size16
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
}
