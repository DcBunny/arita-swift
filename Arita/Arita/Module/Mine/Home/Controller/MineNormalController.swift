//
//  MineNormalController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineNormalController **关于我们，投稿合作**页面主页
 */
class MineNormalController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(isAboutUs: Bool) {
        self.isAboutUs = isAboutUs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: (isAboutUs ? "关于我们" : "合作投稿"), font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(backGroundView)
        view.addSubview(appIconImageView)
        view.addSubview(topLabel)
        view.addSubview(mediumLabel)
        view.addSubview(mailIcon)
        view.addSubview(bottomBg)
    }
    
    private func layoutPageViews() {
        backGroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        appIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 60, height: 88))
            make.bottom.equalTo(topLabel.snp.top).offset(-30)
        }
        
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(appIconImageView.snp.bottom).offset(30)
            make.left.equalTo(view).offset(80)
            make.right.equalTo(view).offset(-80)
            make.bottom.equalTo(mediumLabel.snp.top).offset(-10)
        }
        
        mediumLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.left.equalTo(view).offset(80)
            make.right.equalTo(view).offset(-80)
            make.bottom.equalTo(mailIcon.snp.top).offset(-15)
        }
        
        mailIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.top.equalTo(mediumLabel.snp.bottom).offset(15)
        }
        
        bottomBg.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(Size.screenWidth * 580 / 750)
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = Color.hexf5f5f5
        if isAboutUs {
            topLabel.attributedText = "这里每天有全球最新的创意资讯、奇思妙想的设计作品、妙趣横生的多彩生活。".convertMineContentString()
            mediumLabel.attributedText = "内容包含设计、创意、艺术、建筑、家居、摄影、手工......".convertMineContentString()
            bottomBg.image = UIImage(named: Icon.aboutUsBg)
        } else {
            topLabel.attributedText = "如果你有合作相关的需求，请发送邮件至邮箱".convertMineContentString()
            mediumLabel.attributedText = "arita7@163.com".convertMineContentString()
            bottomBg.image = UIImage(named: Icon.messageBg)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _backGroundView: UIImageView?
    fileprivate var _appIconImageView: UIImageView?
    fileprivate var _topLabel: UILabel?
    fileprivate var _mediumLabel: UILabel?
    fileprivate var _mailIcon: UIImageView?
    fileprivate var _bottomBg: UIImageView?
    
    fileprivate var isAboutUs = true
}

// MARK: - Getters and Setters
extension MineNormalController {
    fileprivate var backGroundView: UIImageView {
        if _backGroundView == nil {
            _backGroundView = UIImageView()
            _backGroundView?.backgroundColor = UIColor.init(patternImage: UIImage(named: Icon.background)!)
            
            return _backGroundView!
        }

        return _backGroundView!
    }
    
    fileprivate var appIconImageView: UIImageView {
        if _appIconImageView == nil {
            _appIconImageView = UIImageView()
            _appIconImageView?.image = UIImage(named: Icon.appIcon)
            
            return _appIconImageView!
        }
        
        return _appIconImageView!
    }
    
    fileprivate var topLabel: UILabel {
        if _topLabel == nil {
            _topLabel = UILabel()
            _topLabel?.numberOfLines = 0
            
            return _topLabel!
        }
        
        return _topLabel!
    }
    
    fileprivate var mediumLabel: UILabel {
        if _mediumLabel == nil {
            _mediumLabel = UILabel()
            _mediumLabel?.numberOfLines = 0
            
            return _mediumLabel!
        }
        
        return _mediumLabel!
    }
    
    fileprivate var mailIcon: UIImageView {
        if _mailIcon == nil {
            _mailIcon = UIImageView()
            _mailIcon?.image = UIImage(named: Icon.message)
            _mailIcon?.isHidden = isAboutUs
            
            return _mailIcon!
        }
        
        return _mailIcon!
    }
    
    fileprivate var bottomBg: UIImageView {
        if _bottomBg == nil {
            _bottomBg = UIImageView()
            _bottomBg?.contentMode = .scaleAspectFit
            
            return _bottomBg!
        }
        
        return _bottomBg!
    }
}
