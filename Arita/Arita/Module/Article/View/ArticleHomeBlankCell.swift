//
//  ArticleHomeBlankCell.swift
//  Arita
//
//  Created by 潘东 on 2017/9/18.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

/**
 ArticleHomeBlankCell **文章**页每个section尾多得8px的占位cell
 */
class ArticleHomeBlankCell: UITableViewCell {
    
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
        addSubview(view)
    }
    
    private func layoutCellViews() {
        view.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(self)
            ConstraintMaker.height.equalTo(8)
        }
    }
    
    private func setCellViews() {
        backgroundColor = Color.hexf5f5f5
        selectionStyle = .none
    }
    
    // MARK: - Controller Attributes
    let view = UIView()
}

