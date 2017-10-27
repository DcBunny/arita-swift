//
//  MineSexChooseTableViewCell.swift
//  Arita
//
//  Created by 潘东 on 2017/10/27.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 * 选择性别cell
 */
class MineSexChooseTableViewCell: UITableViewCell {

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
        contentView.addSubview(sexLabel)
        contentView.addSubview(chooseIcon)
        contentView.addSubview(seperatorOne)
        contentView.addSubview(seperatorTwo)
    }
    
    private func layoutCellViews() {
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(25)
            make.width.equalTo(50)
            make.top.equalTo(contentView)
            make.height.equalTo(contentView)
        }
        
        chooseIcon.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-25)
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalTo(contentView)
        }
        
        seperatorOne.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView)
            make.height.equalTo(1 / Size.screenScale)
        }
        
        seperatorTwo.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.height.equalTo(1 / Size.screenScale)
        }
    }
    
    private func setCellViews() {
        backgroundColor = Color.hexffffff
        selectionStyle = .none
        seperatorOne.backgroundColor = Color.hexe4e4e4
        seperatorTwo.backgroundColor = Color.hexe4e4e4
    }
    
    public var isIconHidden = true {
        didSet {
            chooseIcon.isHidden = isIconHidden
        }
    }
    
    public var lableText = "" {
        didSet {
            sexLabel.text = lableText
        }
    }
    
    public var isLast = false {
        didSet {
            if isLast {
                seperatorTwo.isHidden = false
                seperatorOne.isHidden = true
            } else {
                seperatorTwo.isHidden = true
                seperatorOne.isHidden = false
            }
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _sexLabel: UILabel?
    fileprivate var _chooseIcon: UIImageView?
    fileprivate var seperatorOne = UIView()
    fileprivate var seperatorTwo = UIView()
}

// MARK: - Getters and Setters
extension MineSexChooseTableViewCell {
    fileprivate var sexLabel: UILabel {
        if _sexLabel == nil {
            _sexLabel = UILabel()
            _sexLabel?.textAlignment = .left
            _sexLabel?.textColor = Color.hex2a2a2a
            _sexLabel?.font = Font.size14
            
            return _sexLabel!
        }
        
        return _sexLabel!
    }
    
    fileprivate var chooseIcon: UIImageView {
        if _chooseIcon == nil {
            _chooseIcon = UIImageView()
            _chooseIcon?.image = UIImage(named: Icon.sexChoose)
            _chooseIcon?.isHidden = true
            
            return _chooseIcon!
        }
        
        return _chooseIcon!
    }
}
