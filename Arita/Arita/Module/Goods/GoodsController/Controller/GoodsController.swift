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
            if UIDevice.current.isIphoneX() {
                make.edges.equalTo(UIEdgeInsets(top: 5, left: 6, bottom: 25, right: 6))
            } else {
                make.edges.equalTo(UIEdgeInsets(top: 5, left: 6, bottom: 6, right: 6))
            }
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
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buy), for: .touchUpInside)
    }
    
    private func setAPIManager() {
        goodsManager.paramSource = self
        goodsManager.delegate = self
        
        likeManager.paramSource = self
        likeManager.delegate = self
        
        unlikeManager.paramSource = self
        unlikeManager.delegate = self
    }
    
    private func loadPageData() {
        goodsManager.loadData()
    }
    
    @objc private func like() {
        if UserManager.sharedInstance.isLogin() {
            if isLiked {
                unlikeManager.loadData()
            } else {
                likeManager.loadData()
            }
        } else {
            let loginController = LoginController(isPopMode: true)
            let loginNav = UINavigationController(rootViewController: loginController)
            present(loginNav, animated: true, completion: nil)
        }
    }
    
    @objc private func share() {
        let shareUrl = API.goodsDetailUrl + id!
        let content = [ShareKey.shareUrlKey: shareUrl,
                       ShareKey.shareTitleKey: goodTitle!,
                       ShareKey.shareDescribtionKey: goodDetail!,
                       ShareKey.shareImageUrlKey: goodImg!
        ]
        DispatchQueue.main.async {
            let shareController = ShareController(content: content, isImage: false)
            shareController.modalTransitionStyle = .crossDissolve
            shareController.providesPresentationContextTransitionStyle = true
            shareController.definesPresentationContext = true
            shareController.modalPresentationStyle = .overFullScreen
            self.present(shareController, animated: true, completion: nil)
        }
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
    fileprivate var _likeManager: LikeGoodsManager?
    fileprivate var _unlikeManager: UnlikeGoodsManager?
    fileprivate var buyLink: String?
    fileprivate var goodTitle: String?
    fileprivate var goodDetail: String?
    fileprivate var goodImg: String?
    fileprivate var isLiked: Bool = false {
        didSet {
            if isLiked {
                likeButton.setBackgroundImage(UIImage(named: Icon.likeIcon)!, for: .normal)
            } else {
                likeButton.setBackgroundImage(UIImage(named: Icon.unlikeIcon)!, for: .normal)
            }
        }
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if manager === goodsManager {
            if UserManager.sharedInstance.isLogin() {
                return ["goodsID": id!, "userID": UserManager.sharedInstance.getUserInfo()?.userId as Any]
            } else {
                return ["goodsID": id!]
            }
        } else if manager === likeManager {
            return ["goodsID": id!, "id": UserManager.sharedInstance.getUserInfo()?.userId as Any]
        } else {
            return ["goodsID": id!, "id": UserManager.sharedInstance.getUserInfo()?.userId as Any]
        }
    }
}

extension GoodsController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        if manager === goodsManager {
            var serverImages: [String] = []
            if json["imgArr"].arrayValue.count != 0 {
                for img in json["imgArr"].arrayValue {
                    serverImages.append(img["img"].stringValue)
                }
            } else {
                let thumb = json["thumb_path"].stringValue
                serverImages.append(thumb)
            }
            cycleImageView.serverImgArray = serverImages
            if serverImages.count == 1 {
                cycleImageView.isEndlessScroll = false
            }
            goodTitle = json["title"].stringValue
            titleLabel.text = goodTitle
            goodDetail = json["description"].stringValue
            contentLabel.text = goodDetail
            priceLabel.text = "¥" + json["price"].stringValue
            buyLink = json["buy_link"].stringValue
            goodImg = json["thumb_path"].stringValue
            isLiked = json["userLike"].boolValue
            setNaviBar(title: json["channel_name"].string, font: Font.size15)
        } else if manager === likeManager {
            if json["flag"].stringValue == "1" {
                isLiked = !isLiked
            } else {
                ONTipCenter.showToast("收藏失败")
            }
        } else {
            if json["flag"].stringValue == "1" {
                isLiked = !isLiked
            } else {
                ONTipCenter.showToast("取消失败")
            }
        }
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
            _cycleImageView = WRCycleScrollView(frame: CGRect(x: 0, y: 0, width: Size.screenWidth - 12, height: Size.screenWidth - 12), type: .SERVER, imgs: ["http:zhanwei.com/img"], descs: nil)
            _cycleImageView?.autoScrollInterval = 2
            _cycleImageView?.currentDotColor = Color.hexea9120!
            _cycleImageView?.otherDotColor = Color.hexd3d3d3!
            _cycleImageView?.isAutoScroll = false
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
            if UIDevice.current.isIphoneX() {
                _contentLabel?.numberOfLines = 6
            } else {
                _contentLabel?.numberOfLines = 3
            }
            
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
            _likeButton?.setBackgroundImage(UIImage(named: Icon.unlikeIcon)!, for: .normal)
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
    
    fileprivate var likeManager: LikeGoodsManager {
        if _likeManager == nil {
            _likeManager = LikeGoodsManager()
        }
        
        return _likeManager!
    }
    
    fileprivate var unlikeManager: UnlikeGoodsManager {
        if _unlikeManager == nil {
            _unlikeManager = UnlikeGoodsManager()
        }
        
        return _unlikeManager!
    }
}
