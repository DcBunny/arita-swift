//
//  SearchHistoryCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/11/15.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

protocol HistoryKeyWordDelegate: class {
    func historyKeyWord(with keyWord: String)
}

class SearchHistoryCell: UITableViewCell {

    // MARK: - Init Methods
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addCellViews()
        layoutCellViews()
        setCellViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addCellViews() {
        contentView.addSubview(leftView)
        leftView.addSubview(leftLabel)
        leftView.addSubview(leftBtn)
        contentView.addSubview(rightView)
        rightView.addSubview(rightLabel)
        rightView.addSubview(rightBtn)
    }
    
    private func layoutCellViews() {
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(contentView).offset(5)
            make.right.equalTo(contentView.snp.centerX).offset(-10)
            make.bottom.equalTo(contentView).offset(-5)
            make.height.equalTo(33)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(leftView)
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(leftView)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(leftView)
            make.left.equalTo(contentView.snp.centerX).offset(10)
            make.right.equalTo(contentView).offset(-15)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(rightView)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(rightView)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        leftBtn.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
    }
    
    @objc func buttonSelect(sender: UIButton) {
        delegate?.historyKeyWord(with: cellData[sender.tag])
    }
    
    var cellData: [String] = [] {
        didSet {
            if cellData.count == 2 {
                leftLabel.text = cellData[0]
                rightLabel.text = cellData[1]
                rightView.isHidden = false
            } else {
                leftLabel.text = cellData[0]
                rightView.isHidden = true
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _leftView: UIView?
    fileprivate var _leftLabel: UILabel?
    fileprivate var _leftBtn: UIButton?
    fileprivate var _rightView: UIView?
    fileprivate var _rightLabel: UILabel?
    fileprivate var _rightBtn: UIButton?
    
    weak var delegate: HistoryKeyWordDelegate?
}

// MARK: - Getters and Setters
extension SearchHistoryCell {
    
    fileprivate var leftView: UIView {
        if _leftView == nil {
            _leftView = UIView()
            _leftView?.backgroundColor = UIColor.white
            _leftView?.layer.cornerRadius = CGFloat(5)
            _leftView?.layer.masksToBounds = true
        }
        
        return _leftView!
    }
    
    fileprivate var leftLabel: UILabel {
        if _leftLabel == nil {
            _leftLabel = UILabel()
            _leftLabel?.textColor = Color.hex2a2a2a
            _leftLabel?.font = Font.size12
            _leftLabel?.textAlignment = .center
            _leftLabel?.numberOfLines = 1
        }
        
        return _leftLabel!
    }
    
    fileprivate var leftBtn: UIButton {
        if _leftBtn == nil {
            _leftBtn = UIButton()
            _leftBtn?.tag = 0
        }
        
        return _leftBtn!
    }
    
    fileprivate var rightView: UIView {
        if _rightView == nil {
            _rightView = UIView()
            _rightView?.backgroundColor = UIColor.white
            _rightView?.layer.cornerRadius = CGFloat(5)
            _rightView?.layer.masksToBounds = true
        }
        
        return _rightView!
    }
    
    fileprivate var rightLabel: UILabel {
        if _rightLabel == nil {
            _rightLabel = UILabel()
            _rightLabel?.textColor = Color.hex2a2a2a
            _rightLabel?.font = Font.size12
            _rightLabel?.textAlignment = .center
            _rightLabel?.numberOfLines = 1
        }
        
        return _rightLabel!
    }
    
    fileprivate var rightBtn: UIButton {
        if _rightBtn == nil {
            _rightBtn = UIButton()
            _rightBtn?.tag = 1
        }
        
        return _rightBtn!
    }
}
