//
//  GoodsSearchController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/18.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsSearchController: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(type: .normal)
        setNaviRightTextBtn("搜索", action: #selector(searchGoods))
        
        let searchView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: Size.screenWidth - 120, height: 44)))
        let searchIcon = UIImageView(frame: CGRect(x: 0, y: 10, width: 24, height: 24))
        searchIcon.image = UIImage(named: Icon.searchIcon)
        searchView.addSubview(searchIcon)
        
        let searchText = UITextField(frame: CGRect(x: 34, y: 4, width: searchView.frame.size.width - 44, height: 40))
        searchText.clearButtonMode = .whileEditing
        searchView.addSubview(searchText)
        searchTerms = searchText
        
        let splitLine = UIView(frame: CGRect(x: 0, y: 43, width: searchView.frame.size.width, height: 1))
        splitLine.backgroundColor = Color.hex4a4a4a
        searchView.addSubview(splitLine)
        setTitleView(searchView)
    }
    
    private func addPageViews() {
        view.addSubview(tableView)
        view.addSubview(noResultView)
        noResultView.addSubview(noResultIcon)
        noResultView.addSubview(noResultLabel)
    }
    
    private func layoutPageViews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        noResultView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        noResultIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(noResultView)
            make.centerY.equalTo(noResultView).offset(-30)
            make.size.equalTo(CGSize(width: 120, height: 120))
        }
        
        noResultLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(noResultIcon)
            make.top.equalTo(noResultIcon.snp.bottom).offset(25)
        }
    }
    
    private func setPageViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchManager.paramSource = self
        searchManager.delegate = self
    }
    
    // MARK: - Event Response
    @objc private func searchGoods() {
        searchManager.loadData()
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _noResultView: UIView?
    fileprivate var _noResultIcon: UIImageView?
    fileprivate var _noResultLabel: UILabel?
    
    fileprivate var searchTerms: UITextField?
    
    fileprivate var searchArray: [JSON] = []
    fileprivate var _searchManager: SearchManager?
}

extension GoodsSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GoodsCell.self), for: indexPath) as! GoodsCell
        cell.goodData = searchArray[indexPath.row]
        
        return cell
    }
}

extension GoodsSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let good = GoodsController(id: searchArray[indexPath.row]["ID"].stringValue)
        navigationController?.pushViewController(good, animated: true)
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsSearchController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        searchTerms?.resignFirstResponder()
        let keyWord = searchTerms!.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return [
            "search_word": keyWord!
        ]
    }
}

extension GoodsSearchController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        
        searchArray = json.arrayValue
        if searchArray.count == 0 {
            tableView.isHidden = true
            noResultView.isHidden = false
        } else {
            tableView.isHidden = false
            noResultView.isHidden = true
            tableView.reloadData()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension GoodsSearchController {
    
    fileprivate var tableView: UITableView {
        if _tableView == nil {
            _tableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
            _tableView?.backgroundColor = UIColor.white
            _tableView?.showsVerticalScrollIndicator = false
            _tableView?.register(GoodsCell.self, forCellReuseIdentifier: String(describing: GoodsCell.self))
            _tableView?.estimatedRowHeight = 110
            _tableView?.rowHeight = UITableViewAutomaticDimension
            _tableView?.separatorStyle = .none
            _tableView?.backgroundColor = UIColor.clear
            _tableView?.isHidden = true
        }
        
        return _tableView!
    }
    
    fileprivate var noResultView: UIView {
        if _noResultView == nil {
            _noResultView = UIView()
            _noResultView?.isHidden = true
        }
        
        return _noResultView!
    }
    
    fileprivate var noResultIcon: UIImageView {
        if _noResultIcon == nil {
            _noResultIcon = UIImageView()
            _noResultIcon?.image = UIImage(named: Icon.noResultIcon)
        }
        
        return _noResultIcon!
    }
    
    fileprivate var noResultLabel: UILabel {
        if _noResultLabel == nil {
            _noResultLabel = UILabel()
            _noResultLabel?.text = "什么都没有搜索到..."
            _noResultLabel?.font = Font.size13
            _noResultLabel?.textColor = Color.hex919191
            _noResultLabel?.textAlignment = .center
        }
        
        return _noResultLabel!
    }
    
    fileprivate var searchManager: SearchManager {
        if _searchManager == nil {
            _searchManager = SearchManager()
        }
        
        return _searchManager!
    }
}
