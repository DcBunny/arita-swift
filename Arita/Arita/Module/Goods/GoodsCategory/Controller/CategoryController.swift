//
//  CategoryController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/17.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import SwiftyJSON

fileprivate let prices = ["全部", "0 - 1999", "2000 - 2999", "3000 - 5999", "6000 - 30000"]
fileprivate let priceCondition = [[0, 30000], [0, 1999], [2000, 2999], [3000, 5999], [6000, 30000]]

class CategoryController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        setAPIManager()
        initPageData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with title: String, id: String) {
        super.init(nibName: nil, bundle: nil)
        self.conTitle = title
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller Settings
    private func setNavigationBar() {
        setNaviBar(title: conTitle, font: Font.size15)
        setNaviBar(type: .normal)
    }
    
    private func addPageViews() {
        view.addSubview(menuView)
        menuView.addSubview(leftLabel)
        menuView.addSubview(leftArrow)
        menuView.addSubview(rightLabel)
        menuView.addSubview(rightArrow)
        menuView.addSubview(leftButton)
        menuView.addSubview(rightButton)
        view.addSubview(goodsTable)
        view.addSubview(categoryTable)
        view.addSubview(priceTable)
    }
    
    private func layoutPageViews() {
        menuView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(35)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(menuView)
            make.centerX.equalTo(Size.screenWidth/4 - 10.5)
        }
        
        leftArrow.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.centerY.equalTo(leftLabel)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(menuView)
            make.centerX.equalTo(Size.screenWidth/4 * 3 - 10.5)
        }
        
        rightArrow.snp.makeConstraints { (make) in
            make.left.equalTo(rightLabel.snp.right).offset(5)
            make.centerY.equalTo(rightLabel)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(menuView)
            make.right.equalTo(menuView.snp.centerX)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.left.equalTo(menuView.snp.centerX)
            make.top.right.bottom.equalTo(menuView)
        }
        
        goodsTable.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        
        categoryTable.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom)
            make.left.equalTo(view).offset(6)
            make.right.equalTo(view.snp.centerX)
            categoryTableHeightConstraint = make.height.equalTo(0).constraint
        }
        
        priceTable.snp.makeConstraints { (make) in
            make.top.equalTo(menuView.snp.bottom)
            make.right.equalTo(view).offset(-6)
            make.left.equalTo(view.snp.centerX)
            make.height.equalTo(200)
        }
    }
    
    private func setPageViews() {
        leftButton.addTarget(self, action: #selector(changeMenuOption), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(changeMenuOption), for: .touchUpInside)
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        priceTable.dataSource = self
        priceTable.delegate = self
        
        goodsTable.dataSource = self
        goodsTable.delegate = self
        goodsTable.mj_header.setRefreshingTarget(self, refreshingAction: #selector(loadPageData))
        goodsTable.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(loadMorePageData))
    }
    
    private func setAPIManager() {
        thirdCategoryManager.paramSource = self
        thirdCategoryManager.delegate = self
        
        goodsChildListManager.paramSource = self
        goodsChildListManager.delegate = self
    }
    
    private func initPageData() {
        thirdCategoryManager.loadData()
        goodsTable.mj_header.beginRefreshing()
    }
    
    // MARK: - Event Responses
    @objc private func changeMenuOption(sender: UIButton) {
        if sender == leftButton {
            if !priceTable.isHidden {
                priceTable.isHidden = true
            }
            categoryTable.isHidden = !categoryTable.isHidden
        } else {
            if !categoryTable.isHidden {
                categoryTable.isHidden = true
            }
            priceTable.isHidden = !priceTable.isHidden
        }
    }
    
    @objc private func loadPageData() {
        goodsNum = -1
        currentPage = 1
        goodsChildListManager.loadData()
    }
    
    @objc private func loadMorePageData() {
        if goodsArray.count < goodsNum {
            goodsChildListManager.loadData()
        } else {
            goodsTable.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var conTitle: String?
    fileprivate var id: String?
    
    fileprivate var _menuView: UIView?
    fileprivate var _leftLabel: UILabel?
    fileprivate var _leftArrow: UIImageView?
    fileprivate var _leftButton: UIButton?
    fileprivate var _rightLabel: UILabel?
    fileprivate var _rightArrow: UIImageView?
    fileprivate var _rightButton: UIButton?
    
    fileprivate var _categoryTable: UITableView?
    fileprivate var _priceTable: UITableView?
    
    fileprivate var categoryTableHeightConstraint: Constraint? = nil
    
    fileprivate var _goodsTable: UITableView?
    
    fileprivate var _thirdCategoryManager: GoodsThirdCategoryManager?
    fileprivate var categoryArray: [JSON] = []
    
    fileprivate var _goodsChildListManager: GoodsChildListManager?
    fileprivate var goodsArray: [JSON] = []
    
    fileprivate var childId = -1
    fileprivate var minPrice = 0
    fileprivate var maxPrice = 30000
    fileprivate var goodsNum = -1
    fileprivate var currentPage = 1
}

// MARK: - UITableViewDataSource
extension CategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == goodsTable {
            return goodsArray.count
        } else if tableView == categoryTable {
            return categoryArray.count
        } else {
            return prices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == goodsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GoodsCell.self), for: indexPath) as! GoodsCell
            cell.goodData = goodsArray[indexPath.row]
            
            return cell
            
        } else if tableView == categoryTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuOptionCell.self), for: indexPath) as! MenuOptionCell
            cell.titleText = categoryArray[indexPath.row]["child_name"].stringValue
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuOptionCell.self), for: indexPath) as! MenuOptionCell
            cell.titleText = prices[indexPath.row]
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CategoryController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === categoryTable {
            childId = categoryArray[indexPath.row]["ID"].intValue
            leftLabel.text = categoryArray[indexPath.row]["child_name"].stringValue
            loadDataWithCondition(tableView)
        } else if tableView === priceTable {
            minPrice = priceCondition[indexPath.row][0]
            maxPrice = priceCondition[indexPath.row][1]
            rightLabel.text = prices[indexPath.row]
            loadDataWithCondition(tableView)
        } else {
            let good = GoodsController(id: goodsArray[indexPath.row]["ID"].stringValue)
            navigationController?.pushViewController(good, animated: true)
        }
    }
    
    func loadDataWithCondition(_ tableView: UITableView) {
        goodsTable.mj_header.beginRefreshing()
        tableView.isHidden = true
    }
}

// MARK: - ONAPIManagerParamSource & ONAPIManagerCallBackDelegate
extension CategoryController: ONAPIManagerParamSource {
    
    func paramsForApi(manager: ONAPIBaseManager) -> ONParamData {
        if manager === goodsChildListManager {
            var params: [String: Any] = ["channel_ID": id!, "goodsNum": 40, "minPrice": minPrice, "maxPrice": maxPrice, "currentPage": currentPage]
            if childId != -1 {
                params["childID"] = childId
            }
            
            return params
        } else {
            return ["channelID": id!]
        }
    }
}

extension CategoryController: ONAPIManagerCallBackDelegate {
    
    func managerCallAPIDidSuccess(manager: ONAPIBaseManager) {
        if goodsTable.mj_header.isRefreshing() {
            goodsTable.mj_header.endRefreshing()
        }
        
        if goodsTable.mj_footer.isRefreshing() {
            goodsTable.mj_footer.endRefreshing()
        }
        
        let data = manager.fetchDataWithReformer(nil)
        let json = JSON(data: data as! Data)
        if manager === goodsChildListManager {
            if goodsNum == -1 {
                goodsNum = json["goodsNum"].intValue
                goodsArray.removeAll()
                goodsArray = json["goodsArrNew"].arrayValue
            } else {
                goodsNum = json["goodsNum"].intValue
                goodsArray += json["goodsArrNew"].arrayValue
            }
            currentPage += 1
            goodsTable.reloadData()
        } else {
            categoryArray = json.arrayValue
            categoryTableHeightConstraint?.update(offset: categoryArray.count * 40)
            categoryTable.reloadData()
        }
    }
    
    func managerCallAPIDidFailed(manager: ONAPIBaseManager) {
        if let errorMessage = manager.errorMessage {
            ONTipCenter.showToast(errorMessage)
        }
    }
}

// MARK: - Getters and Setters
extension CategoryController {
    
    fileprivate var menuView: UIView {
        if _menuView == nil {
            _menuView = UIView()
        }
        
        return _menuView!
    }
    
    fileprivate var leftLabel: UILabel {
        if _leftLabel == nil {
            _leftLabel = UILabel()
            _leftLabel?.text = "分类浏览"
            _leftLabel?.textColor = Color.hex4a4a4a
            _leftLabel?.font = Font.size13
            _leftLabel?.textAlignment = .center
        }
        
        return _leftLabel!
    }
    
    fileprivate var leftArrow: UIImageView {
        if _leftArrow == nil {
            _leftArrow = UIImageView()
            _leftArrow?.image = UIImage(named: Icon.menuIcon)
        }
        
        return _leftArrow!
    }
    
    fileprivate var leftButton: UIButton {
        if _leftButton == nil {
            _leftButton = UIButton()
        }
        
        return _leftButton!
    }
    
    fileprivate var rightLabel: UILabel {
        if _rightLabel == nil {
            _rightLabel = UILabel()
            _rightLabel?.text = "价格筛选"
            _rightLabel?.textColor = Color.hex4a4a4a
            _rightLabel?.font = Font.size13
            _rightLabel?.textAlignment = .center
        }
        
        return _rightLabel!
    }
    
    fileprivate var rightArrow: UIImageView {
        if _rightArrow == nil {
            _rightArrow = UIImageView()
            _rightArrow?.image = UIImage(named: Icon.menuIcon)
        }
        
        return _rightArrow!
    }
    
    fileprivate var rightButton: UIButton {
        if _rightButton == nil {
            _rightButton = UIButton()
        }
        
        return _rightButton!
    }
    
    fileprivate var categoryTable: UITableView {
        if _categoryTable == nil {
            _categoryTable = UITableView(frame: .zero, style: UITableViewStyle.plain)
            _categoryTable?.backgroundColor = UIColor.white
            _categoryTable?.showsVerticalScrollIndicator = false
            _categoryTable?.register(MenuOptionCell.self, forCellReuseIdentifier: String(describing: MenuOptionCell.self))
            _categoryTable?.rowHeight = 40
            _categoryTable?.separatorStyle = .none
            _categoryTable?.isHidden = true
        }
        
        return _categoryTable!
    }
    
    fileprivate var priceTable: UITableView {
        if _priceTable == nil {
            _priceTable = UITableView(frame: .zero, style: UITableViewStyle.plain)
            _priceTable?.backgroundColor = UIColor.white
            _priceTable?.showsVerticalScrollIndicator = false
            _priceTable?.register(MenuOptionCell.self, forCellReuseIdentifier: String(describing: MenuOptionCell.self))
            _priceTable?.rowHeight = 40
            _priceTable?.separatorStyle = .none
            _priceTable?.isHidden = true
        }
        
        return _priceTable!
    }
    
    fileprivate var goodsTable: UITableView {
        if _goodsTable == nil {
            _goodsTable = UITableView(frame: .zero, style: UITableViewStyle.plain)
            _goodsTable?.backgroundColor = UIColor.white
            _goodsTable?.showsVerticalScrollIndicator = false
            _goodsTable?.register(GoodsCell.self, forCellReuseIdentifier: String(describing: GoodsCell.self))
            _goodsTable?.estimatedRowHeight = 110
            _goodsTable?.rowHeight = UITableViewAutomaticDimension
            _goodsTable?.separatorStyle = .none
            _goodsTable?.backgroundColor = UIColor.clear
            _goodsTable?.mj_header = MJRefreshNormalHeader()
            _goodsTable?.mj_footer = MJRefreshAutoNormalFooter()
        }
        
        return _goodsTable!
    }
    
    fileprivate var thirdCategoryManager: GoodsThirdCategoryManager {
        if _thirdCategoryManager == nil {
            _thirdCategoryManager = GoodsThirdCategoryManager()
        }
        
        return _thirdCategoryManager!
    }
    
    fileprivate var goodsChildListManager: GoodsChildListManager {
        if _goodsChildListManager == nil {
            _goodsChildListManager = GoodsChildListManager()
        }
        
        return _goodsChildListManager!
    }
}
