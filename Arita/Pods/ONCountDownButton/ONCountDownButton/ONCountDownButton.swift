//
//  ONCountDownButton.swift
//  ExtensionLabel
//
//  Created by 潘东 on 2017/5/12.
//  Copyright © 2017年 com.onenet.app. All rights reserved.
//

import UIKit

public class ONCountDownButton: UIButton {

    //MARK: - Init Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
    
        initButton()
    }
    
    convenience public init(count: Int) {
        self.init(frame: CGRect.zero)
        
        countDownTime = count
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Private Methods
    private func initButton() {
        super.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        super.setTitle(normalTitle, for: .normal)
        super.setTitleColor(normalTitleColor, for: .normal)
        super.setTitleColor(countingTitleColor, for: .disabled)
        super.addTarget(self, action: #selector(ONCountDownButton.startCounting), for: .touchUpInside)
    }
    
    @objc private func startCounting() {
        super.isEnabled = false
        countingTime = countDownTime
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDownAction(timer:)), userInfo: nil, repeats: true)
        RunLoop.current.add(countDownTimer, forMode: .commonModes)
        if countingAction != nil { countingAction!() }
        super.layer.borderColor = countingBorderColor.cgColor
        super.setBackgroundImage(nil, for: .normal)
        super.setBackgroundImage(nil, for: .highlighted)
        super.setBackgroundImage(countingBackgroundImage, for: .disabled)
    }
    
    @objc private func countDownAction(timer: Timer) {
        countingTime -= 1
        if countingTime == 0 {
            super.isEnabled = true
            super.layer.borderColor = normalBorderColor.cgColor
            super.setBackgroundImage(normalBackgroundImage, for: .normal)
            super.setBackgroundImage(normalBackgroundImage, for: .highlighted)
            super.setBackgroundImage(nil, for: .disabled)
            countDownTimer.invalidate()
            guard countDownTimer != nil else { return }
            countDownTimer = nil
        }
    }
    
    override public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        assertionFailure("Please Use 'countingAction' Instead For Button Action")
    }
    
    override public func setTitle(_ title: String?, for state: UIControlState) {
        assertionFailure("Please Use 'normalTitleColor', 'countingBeginTitle' and 'countingEndTitle' Instead For Button Title")
    }
    
    override public func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        assertionFailure("Please Use 'normalTitleColor' and 'countingTitleColor' Instead For Button Title Color")
    }
    
    override public func setBackgroundImage(_ image: UIImage?, for state: UIControlState) {
        assertionFailure("Please Use 'normalBackgroundImage' and 'countingBackgroundImage' Instead For Button Background Image")
    }
    
    //MARK: - Private Instances
    private var countingTime = 60 {
        didSet {
            super.setTitle(countingBeginTitle + " \(countingTime)s " + countingEndTitle, for: .disabled)
        }
    }
    
    private var countDownTimer: Timer!
    
    //MARK: - Open Instances
    /**
     *  设置倒计时时间，单位秒。
     *
     *  默认60秒
     */
    open var countDownTime = 60 {
        didSet {
            countingTime = countDownTime
        }
    }
    
    /**
     *  设置倒计时按钮回调，点击按钮后需要执行的操作可以在此回调中执行。
     *
     *  默认为空
     */
    open var countingAction: (() -> (Void))?
    
    /**
     *  设置默认(未开始倒计时和倒计时结束)状态下标题。
     *
     *  默认"发送验证码"
     *
     */
    open var normalTitle = "发送验证码" {
        didSet {
            super.setTitle(normalTitle, for: .normal)
        }
    }
    
    /**
     *  设置不可选(正在倒计时)状态下数字之前的标题。
     *
     *  默认"重新发送"
     *
     */
    open var countingBeginTitle = "重新发送"
    
    /**
     *  设置不可选(正在倒计时)状态下数字之后的标题。
     *
     *  默认为空
     *
     */
    open var countingEndTitle = ""
    
    /**
     *  设置标题字体大小。
     *
     *  默认使用系统字体，字体大小13。
     *
     *  若自定义字体，请设置 **UIButton().titleLabel.font** 属性。
     *
     */
    open var titleFont: CGFloat = 13.0 {
        didSet {
            super.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        }
    }
    
    /**
     *  设置默认(未开始倒计时和倒计时结束)状态下标题颜色。
     *
     *  默认颜色#5abbf9
     *
     */
    open var normalTitleColor = UIColor(red: 90 / 255, green: 187 / 255, blue: 249 / 255, alpha: 1) {
        didSet {
            super.setTitleColor(normalTitleColor, for: .normal)
        }
    }
    
    /**
     *  设置不可选(正在倒计时)状态下标题颜色。
     *
     *  默认颜色#999999
     *
     */
    open var countingTitleColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1) {
        didSet {
            super.setTitleColor(countingTitleColor, for: .disabled)
        }
    }
    
    /**
     *  设置默认(未开始倒计时和倒计时结束)状态下边框颜色。
     *
     *  默认颜色#5abbf9
     *
     */
    open var normalBorderColor = UIColor(red: 90 / 255, green: 187 / 255, blue: 249 / 255, alpha: 1) {
        didSet {
            super.layer.borderColor = normalBorderColor.cgColor
        }
    }
    
    /**
     *  设置不可选(正在倒计时)状态下边框颜色。
     *
     *  默认颜色#999999
     *
     */
    open var countingBorderColor = UIColor(red: 153 / 255, green: 153 / 255, blue: 153 / 255, alpha: 1)
    
    /**
     *  设置边框的宽度
     *
     *  默认0
     *
     */
    open var borderWidth = 0.0 / UIScreen.main.scale {
        didSet {
            super.layer.borderWidth = borderWidth
            super.layer.borderColor = normalBorderColor.cgColor
        }
    }
    
    /**
     *  设置圆角半径
     *
     *  默认0
     *
     */
    open var cornerRadius = 0.0  {
        didSet {
            super.layer.cornerRadius = CGFloat(cornerRadius)
            guard cornerRadius != 0 && super.layer.masksToBounds != true && (normalBackgroundImage != nil || countingBackgroundImage != nil) else { return }
            super.layer.masksToBounds = true
        }
    }
    
    /**
     *  设置默认(未开始倒计时和倒计时结束)状态下背景图。
     *
     *  默认为空
     *
     */
    open var normalBackgroundImage: UIImage? = nil {
        didSet {
            super.setBackgroundImage(normalBackgroundImage, for: .normal)
            super.setBackgroundImage(normalBackgroundImage, for: .highlighted)
            guard cornerRadius != 0 && super.layer.masksToBounds != true && (normalBackgroundImage != nil || countingBackgroundImage != nil) else { return }
            // 这里经过测试，同屏18个圆角button，离屏渲染状态下，平均帧率还能达到55以上，CPU与无圆角状态下几乎无差别，故直接使用maskToBounds属性设置背影图圆角。
            super.layer.masksToBounds = true
        }
    }
    
    /**
     *  设置不可选(正在倒计时)状态下背景图。
     *
     *  默认为空
     *
     */
    open var countingBackgroundImage: UIImage? = nil {
        didSet {
            super.setBackgroundImage(countingBackgroundImage, for: .disabled)
            guard cornerRadius != 0 && super.layer.masksToBounds != true && (normalBackgroundImage != nil || countingBackgroundImage != nil) else { return }
            super.layer.masksToBounds = true
        }
    }
}
