//
//  ThirdLoginCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/17.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class ThirdLoginCell: UICollectionViewCell {
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
        contentView.addSubview(logoImage)
    }
    
    private func layoutPageViews() {
        logoImage.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    var loginType: Int = 0 {
        didSet {
            switch loginType {
            case 1:
                logoImage.image = UIImage(named: Icon.buttonWechatFriends)
            case 2:
                logoImage.image = UIImage(named: Icon.buttonWeibo)
            case 3:
                logoImage.image = UIImage(named: Icon.buttonQQ)
            default:
                return
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _logoImage: UIImageView?
}

// MARK: - Getters and Setters
extension ThirdLoginCell {
    
    var logoImage: UIImageView {
        if _logoImage == nil {
            _logoImage = UIImageView()
        }
        
        return _logoImage!
    }
}
