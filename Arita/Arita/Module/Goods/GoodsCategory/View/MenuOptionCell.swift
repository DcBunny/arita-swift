//
//  MenuOptionCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/18.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {

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
        addSubview(titleLabel)
        addSubview(splitLine)
    }
    
    private func layoutCellViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.center.equalTo(self)
        }
        
        splitLine.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(self).offset(10)
            ConstraintMaker.right.equalTo(self).offset(-10)
            ConstraintMaker.bottom.equalTo(self)
            ConstraintMaker.height.equalTo(1)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }
    
    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _splitLine: UIView?
}

// MARK: - Getters and Setters
extension MenuOptionCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hex4a4a4a
            _titleLabel?.textAlignment = .center
            _titleLabel?.font = Font.size13
        }
        
        return _titleLabel!
    }
    
    fileprivate var splitLine: UIView {
        if _splitLine == nil {
            _splitLine = UIView()
            _splitLine?.backgroundColor = Color.hexe4e4e4
        }
        
        return _splitLine!
    }
}
