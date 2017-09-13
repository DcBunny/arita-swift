//
//  PlaceholderView.swift
//  tableview
//
//  Created by 潘东 on 2017/5/8.
//  Copyright © 2017年 com.onenet.app. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPageViews() {
        addSubview(defaultImage)
        addSubview(defaultLabel)
        addSubview(reloadButton)
    }
    
    private func layoutPageViews() {
        // 使用Auto Layout的方式来布局
        defaultImage.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 创建一个控件数组
        let views = ["defaultImage": defaultImage,
                     "defaultLabel": defaultLabel]
        // 创建水平居中约束
        addConstraint(NSLayoutConstraint(item: defaultImage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: defaultLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[defaultImage(==185)]", options: .alignAllCenterX, metrics: nil, views: views))
        // 创建垂直方向约束
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-170-[defaultImage(==144)]-20-[defaultLabel]", options: .alignAllCenterX, metrics: nil, views: views))
    }
    
    private func setPageViews() {
        backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    }
    
    @objc fileprivate func reloadClick(sender: UIButton) {
        guard reloadClickBlock != nil else { return }
        reloadClickBlock!()
    }
    
    // MARK: - Public Instance
    open var reloadClickBlock: (() -> ())?
        
    // MARK: - Instance
    fileprivate var _reloadButton: UIButton?
    fileprivate var _defaultImage: UIImageView?
    fileprivate var _defaultLabel: UILabel?
}

// MARK: - Getters and Setters
extension PlaceholderView {
    fileprivate var defaultImage: UIImageView {
        if _defaultImage == nil {
            _defaultImage = UIImageView()
            _defaultImage?.image = UIImage(named: "placeholder_noData", in: Bundle(for: PlaceholderView.self), compatibleWith: nil)

            return _defaultImage!
        }
        
        return _defaultImage!
    }
    
    fileprivate var defaultLabel: UILabel {
        if _defaultLabel == nil {
            _defaultLabel = UILabel()

            _defaultLabel?.text = "暂无数据"
            _defaultLabel?.textAlignment = .center
            _defaultLabel?.textColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1.0)
            _defaultLabel?.font = UIFont.systemFont(ofSize: 15)
            
            return _defaultLabel!
        }
        
        return _defaultLabel!
    }
    
    fileprivate var reloadButton: UIButton {
        if _reloadButton == nil {
            _reloadButton = UIButton(type: .system)
            _reloadButton?.frame = bounds
            _reloadButton?.backgroundColor = UIColor.clear
            _reloadButton?.addTarget(self, action: #selector(reloadClick(sender:)), for: .touchUpInside)
            
            return _reloadButton!
        }
        
        return _reloadButton!
    }
}
