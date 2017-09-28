//
//  ShareButton.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * ShareButton 分享页面Button(图上文下)
 */
class ShareButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = Font.size15
        self.titleLabel?.textAlignment = .center
        self.setTitleColor(Color.hexffffff, for: .normal)
        self.setTitleColor(Color.hexffffff, for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var center = self.imageView?.center
        center?.x = self.frame.size.width / 2
        center?.y = (self.imageView?.frame.size.height)! / 2
        self.imageView?.center = center!

        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = 0
        newFrame?.origin.y = (self.imageView?.frame.size.height)! + 15
        newFrame?.size.width = self.frame.size.width
        newFrame?.size.height = (self.titleLabel?.frame.height)!
        self.titleLabel?.frame = newFrame!
    }
}
