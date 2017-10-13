//
//  MineQRCodeController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/13.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * MineQRCodeController **推荐好友**页面主页
 */
class MineQRCodeController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "微信公众号", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(qrCode)
    }
    
    private func layoutPageViews() {
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(view).offset(6)
            ConstraintMaker.right.equalTo(view).offset(-6)
            ConstraintMaker.top.equalTo(view).offset(5)
            ConstraintMaker.bottom.equalTo(view).offset(-12)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        qrCode.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.center.equalTo(bodyView)
            ConstraintMaker.size.equalTo(CGSize(width: 320, height: 450))
        }
    }
    
    private func setPageView() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction(tap:)))
        bodyView.addGestureRecognizer(longTap)
    }
    
    // MARK: - Event Responses
    @objc fileprivate func longTapAction(tap: UILongPressGestureRecognizer) {
        if tap.state == .began {
            let alert = UIAlertController(title: "是否保存二维码", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { [weak self] (_) in
                guard let strongSelf = self else { return }
                strongSelf.saveImage()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Methods
    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(UIImage(named: Icon.qrCode)!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error == nil {
            ONTipCenter.showToast("保存成功")
        } else {
            if AuthorizationTool.canUsePhotos() == .notDetermined {
                if AuthorizationTool.requestPhotoAuthorization() {
                    ONTipCenter.showToast("已获取权限，请重新保存图片")
                } else {
                    getPhotosAuthorization()
                }
            } else if AuthorizationTool.canUsePhotos() == .canNotUse {
                getPhotosAuthorization()
            } else {
                ONTipCenter.showToast("保存失败，请重试")
            }
        }
    }
    
    private func getPhotosAuthorization() {
        let alert = UIAlertController(title: "照片访问受限", message: "点击“设置”，允许访问您的照片", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "设置", style: .default, handler: { _ in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if let url = url, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                UIApplication.shared.openURL(url!)
                }
            }))
        alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Controller Attributes
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _qrCode: UIImageView?
}

// MARK: - Getters and Setters
extension MineQRCodeController {
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(2)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowColor = Color.hexe4e4e4!.cgColor
            
            return _shadowView!
        }
        
        return _shadowView!
    }
    
    fileprivate var bodyView: UIView {
        if _bodyView == nil {
            _bodyView = UIView()
            _bodyView?.backgroundColor = Color.hexffffff
            _bodyView?.layer.cornerRadius = CGFloat(6)
            _bodyView?.layer.masksToBounds = true
            
            return _bodyView!
        }
        
        return _bodyView!
    }
    
    fileprivate var qrCode: UIImageView {
        if _qrCode == nil {
            _qrCode = UIImageView()
            _qrCode?.image = UIImage(named: Icon.qrCode)
            
            return _qrCode!
        }
        
        return _qrCode!
    }
}
