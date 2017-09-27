//
//  ArticleHomePicCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/14.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleHomePicCell **文章**页九宫格cell试图
 */
class ArticleHomePicCell: UITableViewCell {

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
        addSubview(shadowView)
        shadowView.addSubview(bodyView)
        bodyView.addSubview(picGridView)
        bodyView.addSubview(contentLabel)
    }
    
    private func layoutCellViews() {
        titleLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.equalTo(self).offset(20)
            ConstraintMaker.left.equalTo(self).offset(6)
            ConstraintMaker.right.equalTo(self).offset(-6)
            ConstraintMaker.height.equalTo(44)
            ConstraintMaker.bottom.equalTo(bodyView.snp.top)
        }
        
        shadowView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.equalTo(titleLabel)
            ConstraintMaker.top.equalTo(titleLabel.snp.bottom)
            ConstraintMaker.bottom.equalTo(self).offset(-16)
        }
        
        bodyView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(shadowView)
        }
        
        picGridView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.right.top.equalTo(bodyView)
            ConstraintMaker.height.equalTo(titleLabel.snp.width)
            ConstraintMaker.bottom.equalTo(contentLabel.snp.top).offset(-16)
        }
        
        contentLabel.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.left.equalTo(bodyView).offset(16)
            ConstraintMaker.right.equalTo(bodyView).offset(-16)
            ConstraintMaker.top.equalTo(picGridView.snp.bottom).offset(16)
            ConstraintMaker.bottom.equalTo(bodyView).offset(-48)
        }
    }
    
    private func setCellViews() {
        backgroundColor = Color.hexf5f5f5
        selectionStyle = .none
        
        picGridView.delegate = self
        picGridView.dataSource = self
    }

    // MARK: - Public Attributes
    public var titleText = "" {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: Color.hexea9120!)
        }
    }
    
    public var picArr = [String]() {
        didSet {
            picGridView.creatJGGView()
        }
    }
    
    public var contentText = "" {
        didSet {
            contentLabel.text = contentText
        }
    }
    
    public var color = Color.hexe57e33! {
        didSet {
            titleLabel.attributedText = titleText.withColorCircle(color: color)
        }
    }

    // MARK: - Controller Attributes
    fileprivate var _titleLabel: UILabel?
    fileprivate var _shadowView: UIView?
    fileprivate var _bodyView: UIView?
    fileprivate var _picGridView: JGGGridView?
    fileprivate var _contentLabel: UILabel?
}

// MARK: - JGGGridViewDataSource
extension ArticleHomePicCell: JGGGridViewDataSource {
    func numberOfItems(in gridView: JGGGridView) -> Int {
        return picArr.count
    }
    
    func gridView(_ gridView: JGGGridView, imageForItemAt index: Int) -> UIImageView {
        return picArr[index].convertToImage()
    }
    
    func gapBetweenItems(in gridView: JGGGridView) -> CGFloat {
        return CGFloat(1)
    }
    
    func sizeOfItems(in gridView: JGGGridView) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 22) / 3, height: (UIScreen.main.bounds.size.width - 22) / 3)
    }
}

// MARK: - JGGGridViewDelegate
extension ArticleHomePicCell: JGGGridViewDelegate {
    func gridView(_ gridView: JGGGridView, didSelectRowIndex index: Int) {
        //None
    }
}


// MARK: - Getters and Setters
extension ArticleHomePicCell {
    fileprivate var titleLabel: UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.textColor = Color.hexe57e33
            _titleLabel?.textAlignment = .left
            _titleLabel?.font = Font.size14
            
            return _titleLabel!
        }
        
        return _titleLabel!
    }
    
    fileprivate var shadowView: UIView {
        if _shadowView == nil {
            _shadowView = UIView()
            _shadowView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            _shadowView?.layer.shadowRadius = CGFloat(4)
            _shadowView?.layer.masksToBounds = false
            _shadowView?.layer.shadowOpacity = 0.5
            
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
    
    fileprivate var picGridView: JGGGridView {
        if _picGridView == nil {
            _picGridView = JGGGridView()
            
            return _picGridView!
        }
        
        return _picGridView!
    }
    
    fileprivate var contentLabel: UILabel {
        if _contentLabel == nil {
            _contentLabel = UILabel()
            _contentLabel?.textColor = Color.hex2f2f2f
            _contentLabel?.textAlignment = .left
            _contentLabel?.font = Font.size18
            _contentLabel?.numberOfLines = 0
            
            return _contentLabel!
        }
        
        return _contentLabel!
    }
}
