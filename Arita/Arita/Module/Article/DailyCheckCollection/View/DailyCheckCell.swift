//
//  DailyCheckCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 DailyCheckCell **日签打卡机**页的cell
 */
class DailyCheckCell: UICollectionViewCell {
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addPageViews()
        layoutPageViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addPageViews() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(dailyImageView)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        bodyView.snp.makeConstraints { (make) in
            make.edges.equalTo(shadowView)
        }
        
        dailyImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(bodyView)
        }
    }
    
    // MARK: - Public Attributes
    public var dailyImage = " " {
        didSet {
            dailyImageView.kf.setImage(with: URL(string: dailyImage))
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _dailyImageView: UIImageView?
}

// MARK: - Getters and Setters
extension DailyCheckCell {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var dailyImageView: UIImageView {
        if _dailyImageView == nil {
            _dailyImageView = UIImageView()
            _dailyImageView?.contentMode = .scaleToFill
            
            return _dailyImageView!
        }
        
        return _dailyImageView!
    }
}

