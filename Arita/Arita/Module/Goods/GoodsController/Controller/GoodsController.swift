//
//  GoodsController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/19.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        setAPIManager()
        loadPageData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(title: "良品类", font: Font.size15)
        setNaviBar(type: .normal)
    }
    
    private func addPageViews() {
        view.addSubview(pageView)
        pageView.addSubview(cycleImageView)
        pageView.addSubview(titleLabel)
        pageView.addSubview(contentLabel)
        pageView.addSubview(priceLabel)
        pageView.addSubview(likeButton)
        pageView.addSubview(shareButton)
        pageView.addSubview(buyButton)
    }
    
    private func layoutPageViews() {
        pageView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 6, bottom: 6, right: 6))
        }
        
        cycleImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(pageView)
            make.height.equalTo(cycleImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cycleImageView.snp.bottom).offset(25)
            make.left.equalTo(cycleImageView).offset(30)
            make.right.equalTo(cycleImageView).offset(-30)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(15)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pageView).offset(-25)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalTo(shareButton.snp.left).offset(-60)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pageView).offset(-25)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerX.equalTo(pageView.snp.centerX)
        }
        
        buyButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(pageView).offset(-25)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.left.equalTo(shareButton.snp.right).offset(60)
        }
    }
    
    private func setPageViews() {
        buyButton.addTarget(self, action: #selector(buy), for: .touchUpInside)
    }
    
    private func setAPIManager() {
        goodsManager.paramSource = self
        goodsManager.delegate = self
    }
    
    private func loadPageData() {
        goodsManager.loadData()
    }
    
    @objc private func buy() {
        if let link = buyLink {
            let linkUrl = URL(string: link)
            UIApplication.shared.openURL(linkUrl!)
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _pageView: UIView?
    fileprivate var _cycleImageView: WRCycleScrollView?
    fileprivate var _titleLabel: UILabel?
    fileprivate var _contentLabel: UILabel?
    fileprivate var _priceLabel: UILabel?
    fileprivate var _likeButton: UIButton?
    fileprivate var _shareButton: UIButton?
    fileprivate var _buyButton: UIButton?
    
    fileprivate var id: String?
    fileprivate var _goodsManager: GoodsManager?
    fileprivate var buyLink: String?
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        return ["goodsID": id!]
    }
}

extension GoodsController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        var serverImages: [String] = []
        for img in json["imgArr"].arrayValue {
            serverImages.append(img.stringValue)
        }
        cycleImageView.serverImgArray = serverImages
        titleLabel.text = json["title"].stringValue
        contentLabel.text = json["description"].stringValue
        priceLabel.text = "¥" + json["price"].stringValue
        buyLink = json["buy_link"].stringValue
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension GoodsController {
    
    fileprivate var pageView: UIView {
        if _pageView == nil {
            _pageView = UIView()
            _pageView?.backgroundColor = UIColor.white
            _pageView?.layer.cornerRadius = 5
            _pageView?.layer.masksToBounds = true
        }
        
        return _pageView!
    }
    
    fileprivate var cycleImageView: WRCycleScrollView {
        if _cycleImageView == nil {
            _cycleImageView = WRCycleScrollView(frame: CGRect(x: 0, y: 0, width: Size.screenWidth - 12, height: Size.screenWidth - 12))
            _cycleImageView?.imgsType = .SERVER
            _cycleImageView?.autoScrollInterval = 2
            _cycleImageView?.currentDotColor = Color.hexea9120!
            _cycleImageView?.otherDotColor = Color.hexd3d3d3!
        }
        
        return _cycleImageView!
    }
    
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textAlignment = .center
            _titleLabel?.font = Font.size20
            _titleLabel?.textColor = Color.hex2a2a2a
        }
        
        return _titleLabel!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.font = Font.size13
            _contentLabel?.textColor = Color.hex919191
            _contentLabel?.textAlignment = .center
            _contentLabel?.numberOfLines = 3
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
    
    fileprivate var priceLabel: UILabel {
        if _priceLabel == nil {
            _priceLabel = UILabel()
            _priceLabel?.font = Font.size22
            _priceLabel?.textColor = Color.hexea9120
            _priceLabel?.textAlignment = .center
        }
        
        return _priceLabel!
    }
    
    fileprivate var likeButton: UIButton {
        if _likeButton == nil {
            _likeButton = UIButton()
            _likeButton?.setBackgroundImage(UIImage(named: Icon.likeIcon)!, for: .normal)
        }
        
        return _likeButton!
    }
    
    fileprivate var shareButton: UIButton {
        if _shareButton == nil {
            _shareButton = UIButton()
            _shareButton?.setBackgroundImage(UIImage(named: Icon.share)!, for: .normal)
        }
        
        return _shareButton!
    }
    
    fileprivate var buyButton: UIButton {
        if _buyButton == nil {
            _buyButton = UIButton()
            _buyButton?.setBackgroundImage(UIImage(named: Icon.buyIcon)!, for: .normal)
        }
        
        return _buyButton!
    }
    
    fileprivate var goodsManager: GoodsManager {
        if _goodsManager == nil {
            _goodsManager = GoodsManager()
        }
        
        return _goodsManager!
    }
}
