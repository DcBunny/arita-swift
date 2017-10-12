//
//  ShareController.swift
//  Arita
//
//  Created by 潘东 on 2017/9/28.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * ShareController 分享页面主页
 */
class ShareController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        findSharePlatform()
        caculateHeight()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .none)
    }
    
    private func addPageViews() {
        view.addSubview(titleLabel)
        view.addSubview(shareCollectionView)
        view.addSubview(closeButton)
    }
    
    private func layoutPageViews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(topHeight)
            make.left.right.equalTo(view)
            make.bottom.equalTo(shareCollectionView.snp.top).offset(-55)
        }
        
        shareCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(closeButton.snp.top).offset(-50)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(shareCollectionView.snp.bottom).offset(50)
            make.centerX.equalTo(shareCollectionView)
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.bottom.equalTo(view).offset(-bottomHeight)
        }
    }
    
    private func setPageViews() {
        view.backgroundColor = Color.hex000000Alpha50
        shareCollectionView.delegate = self
        shareCollectionView.dataSource = self
        ShareTool.sharedInstance.delegate = self
    }
    
    // MARK: - Event Responses
    
    // MARK: - Private Methods
    private func findSharePlatform() {
        shareModel.append(ShareModel.shareLink())

        if !QQApiInterface.isQQInstalled() {
            shareModel.insert(ShareModel.shareQzone(), at: 0)
            shareModel.insert(ShareModel.shareQQ(), at: 0)
        }

        if !WeiboSDK.isWeiboAppInstalled() {
            shareModel.insert(ShareModel.shareWeibo(), at: 0)
        }

        if !WXApi.isWXAppInstalled() {
            shareModel.insert(ShareModel.shareWechatMoments(), at: 0)
            shareModel.insert(ShareModel.shareWechatFriends(), at: 0)
        }
    }
    
    private func caculateHeight() {
        size1 = "微信好友".sizeForFont(Font.size15!, size: CGSize(width: self.view.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail)
        size2 = "分享你的视野".sizeForFont(Font.size22!, size: CGSize(width: self.view.bounds.size.width, height: CGFloat(MAXFLOAT)), lineBreakMode: NSLineBreakMode.byTruncatingTail)
        if shareModel.count > 3 {
            topHeight = Size.screenHeight / 2 - 145 - size1.height - size2.height
            bottomHeight = Size.screenHeight / 2 - 179 - size1.height
        } else {
            topHeight = Size.screenHeight / 2 - 92.5 - size1.height / 2 - size2.height
            bottomHeight = Size.screenHeight / 2 - 149 - size1.height / 2
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _shareCollectionView: UICollectionView?
    fileprivate var _closeButton: UIButton?
    
    private var size1 = CGSize.zero
    private var size2 = CGSize.zero
    private var topHeight = CGFloat(Size.screenHeight / 2 - 197)
    private var bottomHeight = CGFloat(Size.screenHeight / 2 - 200)
    
    fileprivate var shareModel: [ShareModel] = []
}

//TODO: 后期删除
private let shareDemo = ShareModel.demoModel()

// MARK: - UICollecitonView Data Source
extension ShareController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShareCollectionCell.self), for: indexPath) as! ShareCollectionCell
        cell.shareModel = shareModel[indexPath.row]
        return cell
    }
}

extension ShareController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((Size.screenWidth - 60) / 3), height: 96)
    }
}

// MARK: - UICollecitonView Delegate
extension ShareController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShareCollectionCell.self), for: indexPath) as! ShareCollectionCell
        guard let shareType = cell.shareType else { return }
        ShareTool.sharedInstance.shareWith(content: nil, to: shareType)
    }
}

// MARK: - Share Delegate
extension ShareController: ShareDelegate {
    func didSucessed(shareTo platform: ShareType) {
        
    }
    
    func didFailed(shareTo platform: ShareType, with error: Error?) {
        
    }
    
    func didCanceled(shareTo platform: ShareType) {
        
    }
}

// MARK: - Getters and Setters
extension ShareController {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textAlignment = .center
            _titleLabel?.font = Font.size22
            _titleLabel?.textColor = Color.hexffffff
            _titleLabel?.text = "分享你的视野"
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    var shareCollectionView: UICollectionView {
        if _shareCollectionView == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 30
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.itemSize = CGSize(width: ((Size.screenWidth - 60) / 3), height: 96)
            _shareCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _shareCollectionView?.register(ShareCollectionCell.self, forCellWithReuseIdentifier: String(describing: ShareCollectionCell.self))
            _shareCollectionView?.showsVerticalScrollIndicator = false
            _shareCollectionView?.translatesAutoresizingMaskIntoConstraints = false
            _shareCollectionView?.isScrollEnabled = false
            _shareCollectionView?.backgroundColor = UIColor.clear
            
            return _shareCollectionView!
        }
        
        return _shareCollectionView!
    }
    
    var closeButton: UIButton {
        if _closeButton == nil {
            _closeButton = UIButton()
            _closeButton?.setImage(UIImage(named: Icon.shareClose), for: .normal)
            _closeButton?.setImage(UIImage(named: Icon.shareClose), for: .highlighted)
            _closeButton?.addTarget(self, action: #selector(viewDismiss), for: .touchUpInside)
            
            return _closeButton!
        }
        
        return _closeButton!
    }
}
