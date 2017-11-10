//
//  CalendarButton.swift
//  Arita
//
//  Created by 潘东 on 2017/11/10.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class CalendarButton: UIButton {

    override func draw(_ rect: CGRect) {
        let attribute = [NSFontAttributeName: Font.size12 as Any,
                         NSForegroundColorAttributeName: Color.hex4a4a4a as Any
            ]
        let textSize = dayString.sizeForString(attribute: attribute, in: CGSize(width: CGFloat(MAXFLOAT), height: 0), lineBreakMode: .byTruncatingTail)
        let xPosition = CGFloat(self.frame.width - textSize.width) / 2
        let yPosition = CGFloat(self.frame.height - textSize.height + 5) / 2
        let drawPoint = CGPoint(x: xPosition, y: yPosition)
        (dayString as NSString).draw(at: drawPoint, withAttributes: attribute)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(named: Icon.topCalendar), for: .normal)
        self.setImage(UIImage(named: Icon.topCalendar), for: .highlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var dayString = "01" {
        didSet {
            setNeedsDisplay()
        }
    }
}
