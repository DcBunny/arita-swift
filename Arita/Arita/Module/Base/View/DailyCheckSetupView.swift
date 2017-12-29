//
//  DailyCheckSetupView.swift
//  Arita
//
//  Created by 潘东 on 2017/11/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

let kUserDefaults = UserDefaults.standard
let dailyCheckImageName = "dailyCheckImageName"
let dailyCheckUrl = "dailyCheckUrl"
let showtime = 3
/// 日签启动页
class DailyCheckSetupView: UIView {

    // MARK: - Public
    public var filePath = "" {
        didSet {
            imageView.image = UIImage(contentsOfFile: filePath)
        }
    }
    public func show() {
        startTimer()
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
    }

    // MARK: - Private
    fileprivate var _imageView: UIImageView?
    fileprivate var count = showtime
    fileprivate var _countDownTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        imageView.frame = CGRect(x: 5, y: 0, width: frame.size.width - 10, height: frame.size.height)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func removeDailyCheck() {
        countDownTimer.invalidate()
        _countDownTimer = nil
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    // 定时器倒计时
    fileprivate func startTimer() {
        count = showtime
        RunLoop.main.add(countDownTimer, forMode: .commonModes)
    }
    
    @objc fileprivate func countDown() {
        count = count - 1
        if count == 0 {
            removeDailyCheck()
        }
    }
}

// MARK: - Getters and Setters
extension DailyCheckSetupView {
    fileprivate var imageView: UIImageView {
        if _imageView == nil {
            _imageView = UIImageView()
            _imageView?.contentMode = .scaleAspectFit
            _imageView?.clipsToBounds = true
            
            return _imageView!
        }
        
        return _imageView!
    }
    
    fileprivate var countDownTimer: Timer {
        if _countDownTimer == nil {
            _countDownTimer = Timer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            
            return _countDownTimer!
        }
        
        return _countDownTimer!
    }
}
