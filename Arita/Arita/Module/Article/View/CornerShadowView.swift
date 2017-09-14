//
//  CornerShadowView.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

@IBDesignable
class CornerShadowView: UIView {
    
    // MARK: - IBOutlet
    
    // MARK: - properties
    @IBInspectable
    public var topLeft: Bool = false{
        didSet{
            redraw()
        }
    }
    
    @IBInspectable
    public var bottomLeft: Bool = false{
        didSet{
            redraw()
        }
    }
    
    @IBInspectable
    public var topRight: Bool = false{
        didSet{
            redraw()
        }
    }
    
    @IBInspectable
    public var bottomRight: Bool = false{
        didSet{
            redraw()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 10{
        didSet{
            redraw()
        }
    }
    @IBInspectable
    public var shadowOffset: CGSize = .zero{
        didSet{
            redraw()
        }
    }
    @IBInspectable
    public var shadowRadius: CGFloat = 0{
        didSet{
            redraw()
        }
    }
    @IBInspectable
    public var shadowColor: UIColor = .black{
        didSet{
            redraw()
        }
    }
    @IBInspectable
    public var fillColor: UIColor = .white{
        didSet{
            redraw()
        }
    }
    
    // MARK: - initial method
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var corners: UIRectCorner = []
        if topLeft {
            corners.insert(.topLeft)
        }
        if bottomLeft {
            corners.insert(.bottomLeft)
        }
        if topRight {
            corners.insert(.topRight)
        }
        if bottomRight {
            corners.insert(.bottomRight)
        }
        
        if shadowRadius > 0 {
            //绘制阴影
            let shadowPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            
            let context = UIGraphicsGetCurrentContext()
            context?.setShadow(offset: shadowOffset, blur: shadowRadius, color: shadowColor.cgColor)
            fillColor.setFill()
            shadowPath.fill()
        }
        
        //绘制mask
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = rect
        layer.mask = maskLayer
    }
    
    // MARK: - lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - private method
    fileprivate func redraw(){
        setNeedsDisplay()
        if shadowRadius > 0 {
            backgroundColor = UIColor.clear
        }
    }
}
