//
//  Goods4GridCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/11.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class Goods4GridCell: UITableViewCell {
    
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
        addSubview(goodsCollection)
    }
    
    private func layoutCellViews() {
        goodsCollection.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.bottom.equalTo(self)
            ConstraintMaker.left.equalTo(self).offset(10)
            ConstraintMaker.right.equalTo(self).offset(-10)
            ConstraintMaker.height.equalTo(560)
        }
    }
    
    private func setCellViews() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        goodsCollection.dataSource = self
        goodsCollection.delegate = self
    }
    
    // MARK: - Controller Attributes
    fileprivate var _goodsCollection: UICollectionView?
}

// MARK: - UICollecitonView Data Source
extension Goods4GridCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsGridCell.self), for: indexPath) as! GoodsGridCell
        cell.goodImage.backgroundColor = UIColor.blue
        cell.goodLabel.text = "1233211233211231231231231231aaa"
        cell.goodPriceLabel.text = "¥" + "89"
        
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension Goods4GridCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShareCollectionCell.self), for: indexPath) as! ShareCollectionCell
//        guard let shareType = cell.shareType else { return }
//        ShareTool.sharedInstance.shareWith(content: nil, to: shareType)
    }
}

// MARK: - Getters and Setters
extension Goods4GridCell {
    fileprivate var goodsCollection: UICollectionView {
        if _goodsCollection == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.itemSize = CGSize(width: ((Size.screenWidth - 25) / 2), height: 275)
            _goodsCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _goodsCollection?.register(GoodsGridCell.self, forCellWithReuseIdentifier: String(describing: GoodsGridCell.self))
            _goodsCollection?.showsVerticalScrollIndicator = false
            _goodsCollection?.translatesAutoresizingMaskIntoConstraints = false
            _goodsCollection?.isScrollEnabled = false
            _goodsCollection?.backgroundColor = UIColor.clear
            
            return _goodsCollection!
        }
        
        return _goodsCollection!
    }
}