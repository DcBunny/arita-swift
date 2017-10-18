//
//  CategoryController.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/17.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SnapKit

class CategoryController: BaseController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        addPageViews()
        layoutPageViews()
        setPageViews()
        
        categoryTableHeightConstraint?.update(offset: 120)
        priceTableHeightConstraint?.update(offset: 200)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init Methods
    init(with title: String) {
        self.conTitle = title
        super.init(nibName: nil, bundle: nil)
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
            priceTableHeightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    private func setPageViews() {
        leftButton.addTarget(self, action: #selector(changeMenuOption), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(changeMenuOption), for: .touchUpInside)
        
        categoryTable.dataSource = self
        categoryTable.delegate = self
        priceTable.dataSource = self
        priceTable.delegate = self
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
    
    // MARK: - Private Methods
    
    // MARK: - Controller Attributes
    fileprivate var conTitle: String?
    
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
    fileprivate var priceTableHeightConstraint: Constraint? = nil
    
    let categorys = ["全部", "笔记本", "台式"]
    let prices = ["全部", "0~1000", "1000~2000", "2000~3000", "3000~4000"]
}

// MARK: - UITableViewDataSource
extension CategoryController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTable {
            return 3
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoryTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuOptionCell.self), for: indexPath) as! MenuOptionCell
            cell.titleText = categorys[indexPath.row]
            
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
            _rightLabel?.text = "价格排序"
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
}
