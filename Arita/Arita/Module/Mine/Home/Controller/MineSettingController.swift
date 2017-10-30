//
//  MineSettingController.swift
//  Arita
//
//  Created by 潘东 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import Kingfisher

/**
 * MineSettingController **设置**页面主页
 */
class MineSettingController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        sizeOfCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviBar(title: "设置", font: Font.size15)
    }
    
    private func addPageViews() {
        view.addSubview(userInfoTableView)
    }
    
    private func layoutPageViews() {
        userInfoTableView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(view)
        }
    }
    
    private func setPageViews() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
    }
    
    // MARK: - Event Responses
    @objc fileprivate func switchAction(sender: UISwitch) {
        if sender.isOn {
            
        } else {
            print("关闭了")
        }
    }
    
    // MARK: - Private Methods
    /// 当前缓存总大小
    private func sizeOfCache() {
        var sizeText = ""
        KingfisherManager.shared.cache.calculateDiskCacheSize { [weak self] size in
            guard let strongSelf = self else { return }
            let fileSize = strongSelf.folderSizeAtPath()
            let total = Float(size) + fileSize
            if total / 1024 / 1024 > 1 {
                let cacheSize = Double(total) / 1024 / 1024
                sizeText = "已缓存" + String(Int(cacheSize)) + " M"
            } else {
                let cacheSize = Double(total) / 1024
                sizeText = "已缓存" + String(Int(cacheSize)) + " K"
            }
            strongSelf.infoArray[0] = sizeText
            DispatchQueue.main.async {
                strongSelf.userInfoTableView.reloadData()
            }
        }
    }
    
    /// 当前系统缓存大小
    private func folderSizeAtPath() -> Float {
        let manager = FileManager.default
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        let files = manager.subpaths(atPath: cachePath!)
        var folderSize: Float = 0.0
        for fileName in files! {
            let fullPath = cachePath?.appendingFormat("/\(fileName)")
            let floder = try! manager.attributesOfItem(atPath: fullPath!)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size {
                    folderSize += bcd as! Float
                }
            }
        }
        return folderSize
    }
    
    /// 清除当前缓存
    fileprivate func clearCache() {
        KingfisherManager.shared.cache.clearDiskCache { [weak self] in
            guard let strongSelf = self else { return }
            let manager = FileManager.default
            let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let files = manager.subpaths(atPath: cachePath!)
            for fileName in files! {            // 拼接路径
                if !fileName.contains("Snapshots") {
                    let path = cachePath!.appendingFormat("/\(fileName)")
                    // 判断是否可以删除
                    if(manager.fileExists(atPath: path)){
                        // 删除
                        do {
                            try manager.removeItem(atPath: path as String)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.sizeOfCache()
            }
        }
    }
    // MARK: - Controller Attributes
    fileprivate var _userInfoTableView: UITableView?
    
    fileprivate var itemArray = ["清空缓存", "开启推送"]
    fileprivate var infoArray = ["", "35"]
}

// MARK: - TableView Data Source
extension MineSettingController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineUserInfoNormalTableViewCell.self), for: indexPath) as! MineUserInfoNormalTableViewCell
            cell.itemName = itemArray[0]
            cell.infoName = infoArray[0]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MineNotificationTableViewCell.self), for: indexPath) as! MineNotificationTableViewCell
            cell.itemName = itemArray[1]
            cell.switchButton.addTarget(self, action: #selector(switchAction(sender:)), for: .valueChanged)
            return cell
        }
    }
}

// MARK: - TableView Delegate
extension MineSettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            clearCache()
        }
    }
}

// MARK: - Getters and Setters
extension MineSettingController {
    fileprivate var userInfoTableView: UITableView {
        if _userInfoTableView == nil {
            _userInfoTableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
            _userInfoTableView?.backgroundColor = Color.hexffffff!
            _userInfoTableView?.showsVerticalScrollIndicator = false
            _userInfoTableView?.separatorStyle = .none
            _userInfoTableView?.register(MineNotificationTableViewCell.self, forCellReuseIdentifier: String(describing: MineNotificationTableViewCell.self))
            _userInfoTableView?.register(MineUserInfoNormalTableViewCell.self, forCellReuseIdentifier: String(describing: MineUserInfoNormalTableViewCell.self))
            
            return _userInfoTableView!
        }
        
        return _userInfoTableView!
    }
}

