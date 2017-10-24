//
//  Goods4GridCell.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/11.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol Goods4GridDelegate: class {
    func goods(disSelectAt indexPath: IndexPath)
}

class Goods4GridCell: UITableViewCell {
    
    weak var delegate: Goods4GridDelegate?
    
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
    
    // MARK: - Public Attributes
    public var cellData: [JSON]? = [] {
        didSet {
            goodsCollection.reloadData()
        }
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
        return cellData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsGridCell.self), for: indexPath) as! GoodsGridCell
        cell.goodImage.kf.setImage(with: URL(string: cellData![indexPath.row]["thumb_path"].stringValue))
        cell.goodLabel.text = cellData![indexPath.row]["title"].stringValue
        cell.goodPriceLabel.text = "¥" + cellData![indexPath.row]["price"].stringValue
        
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension Goods4GridCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.goods(disSelectAt: indexPath)
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
