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
        setEvents()
        loadHistoryData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pageViewInit()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pageViewDeinit()
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
        view.addSubview(historyView)
        historyView.addSubview(historyLabel)
        historyView.addSubview(histroyClean)
        historyView.addSubview(historyTableView)
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
        
        historyView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        historyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(historyView).offset(35)
            make.left.equalTo(historyView).offset(15)
        }
        
        histroyClean.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(historyLabel)
            make.right.equalTo(historyView).offset(-15)
            make.width.equalTo(25)
        }
        
        historyTableView.snp.makeConstraints { (make) in
            make.top.equalTo(historyLabel.snp.bottom).offset(15)
            make.left.equalTo(historyLabel)
            make.right.equalTo(histroyClean)
            make.bottom.equalTo(historyView)
        }
    }
    
    private func setPageViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTerms?.delegate = self
        
        searchManager.paramSource = self
        searchManager.delegate = self
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
    }
    
    private func setEvents() {
        histroyClean.addTarget(self, action: #selector(cleanHistory), for: .touchUpInside)
    }
    
    private func loadHistoryData() {
        historykeyWords = UserManager.sharedInstance.historyKeyword.keywords
    }
    
    private func pageViewInit() {
        searchTerms?.becomeFirstResponder()
    }
    
    private func pageViewDeinit() {
        searchTerms?.resignFirstResponder()
    }
    
    // MARK: - Event Response
    @objc private func searchGoods() {
        if let keyword = searchTerms?.text {
            if !keyword.isEmpty {
                let index = historykeyWords.index(of: keyword)
                if index != nil {
                    historykeyWords.remove(at: index!)
                }
                historykeyWords.insert(keyword, at: 0)
                UserManager.sharedInstance.addKeyword(keyword: keyword)
            }
        }
        
        historyKeyWord = nil
        searchManager.loadData()
    }
    
    @objc private func cleanHistory() {
        historykeyWords = []
        UserManager.sharedInstance.cleanKeyword()
        historyTableView.reloadData()
    }
    
    // MARK: - Controller Attributes
    fileprivate var _tableView: UITableView?
    fileprivate var _noResultView: UIView?
    fileprivate var _noResultIcon: UIImageView?
    fileprivate var _noResultLabel: UILabel?
    
    fileprivate var searchTerms: UITextField?
    
    fileprivate var searchArray: [JSON] = []
    fileprivate var _searchManager: SearchManager?
    
    fileprivate var _historyView: UIView?
    fileprivate var _historyLabel: UILabel?
    fileprivate var _histroyClean: UIButton?
    fileprivate var _historyTableView: UITableView?
    fileprivate var historyKeyWord: String? = nil
    
    fileprivate var historykeyWords: [String] = []
}

extension GoodsSearchController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        historyView.isHidden = false
        historyTableView.reloadData()
        noResultView.isHidden = true
        tableView.isHidden = true
    }
}

extension GoodsSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.tableView {
            return searchArray.count
        } else {
            if historykeyWords.count % 2 == 0 {
                return historykeyWords.count / 2
            } else {
                return historykeyWords.count / 2 + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GoodsCell.self), for: indexPath) as! GoodsCell
            cell.goodData = searchArray[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchHistoryCell.self), for: indexPath) as! SearchHistoryCell
            var cellData = [historykeyWords[indexPath.row * 2]]
            if historykeyWords.count > indexPath.row * 2 + 1 {
                cellData.append(historykeyWords[indexPath.row * 2 + 1])
            }
            cell.cellData = cellData
            cell.delegate = self
            
            return cell
        }
    }
}

extension GoodsSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let good = GoodsController(id: searchArray[indexPath.row]["ID"].stringValue)
        navigationController?.pushViewController(good, animated: true)
    }
}

extension GoodsSearchController: HistoryKeyWordDelegate {
    func historyKeyWord(with keyWord: String) {
        historyKeyWord = keyWord
        searchManager.loadData()
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension GoodsSearchController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        searchTerms?.resignFirstResponder()
        var keyWord = ""
        if historyKeyWord == nil {
            keyWord = searchTerms!.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
        } else {
            keyWord = (historyKeyWord?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
        }
        
        return [
            "search_word": keyWord
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
            historyView.isHidden = true
            noResultView.isHidden = false
        } else {
            tableView.isHidden = false
            noResultView.isHidden = true
            historyView.isHidden = true
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
    
    fileprivate var historyView: UIView {
        if _historyView == nil {
            _historyView = UIView()
            _historyView?.isHidden = true
        }
        
        return _historyView!
    }
    
    fileprivate var historyLabel: UILabel {
        if _historyLabel == nil {
            _historyLabel = UILabel()
            _historyLabel?.text = "历史搜索"
            _historyLabel?.font = Font.size14
            _historyLabel?.textColor = Color.hex919191
        }
        
        return _historyLabel!
    }
    
    fileprivate var histroyClean: UIButton {
        if _histroyClean == nil {
            _histroyClean = UIButton()
            _histroyClean?.setTitle("清除", for: .normal)
            _histroyClean?.setTitleColor(Color.hex4a4a4a, for: .normal)
            _histroyClean?.titleLabel?.font = Font.size12
        }
        
        return _histroyClean!
    }
    
    fileprivate var historyTableView: UITableView {
        if _historyTableView == nil {
            _historyTableView = UITableView(frame: .zero, style: UITableViewStyle.plain)
            _historyTableView?.backgroundColor = UIColor.white
            _historyTableView?.showsVerticalScrollIndicator = false
            _historyTableView?.register(SearchHistoryCell.self, forCellReuseIdentifier: String(describing: SearchHistoryCell.self))
            _historyTableView?.estimatedRowHeight = 43
            _historyTableView?.rowHeight = UITableViewAutomaticDimension
            _historyTableView?.separatorStyle = .none
            _historyTableView?.backgroundColor = UIColor.clear
            _historyTableView?.allowsSelection = false
        }
        
        return _historyTableView!
    }
}
