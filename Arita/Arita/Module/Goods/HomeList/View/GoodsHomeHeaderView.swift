//
//  GoodsHomeHeaderView.swift
//  Arita
//
//  Created by 李宏博 on 2017/10/12.
//  Copyright © 2017年 arita. All rights reserved.
//

import UIKit

class GoodsHomeHeaderView: UITableViewHeaderFooterView {

    // MARK: - Init Methods
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addHeaderViews()
        layoutHeaderViews()
        setHeaderView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Settings
    private func addHeaderViews() {
        addSubview(albumImage)
        addSubview(splitLine)
        addSubview(categoryView)
        categoryView.addSubview(categoryCollection)
        addSubview(bottomSplitLine)
    }
    
    private func layoutHeaderViews() {
        albumImage.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(albumImage.snp.width).multipliedBy(2.0/3)
        }
        
        splitLine.snp.makeConstraints { (make) in
            make.top.equalTo(albumImage.snp.bottom).offset(20)
            make.left.right.equalTo(albumImage)
            make.height.equalTo(1)
        }
        
        categoryView.snp.makeConstraints { (make) in
            make.top.equalTo(splitLine.snp.bottom).offset(20)
            make.left.right.equalTo(splitLine)
        }
        
        categoryCollection.snp.makeConstraints { (make) in
            make.top.equalTo(categoryView).offset(10)
            make.left.equalTo(categoryView).offset(20)
            make.bottom.equalTo(categoryView).offset(-10)
            make.right.equalTo(categoryView).offset(-20)
        }
        
        bottomSplitLine.snp.makeConstraints { (make) in
            make.top.equalTo(categoryView.snp.bottom).offset(20)
            make.left.right.equalTo(categoryView)
            make.height.equalTo(1)
            make.bottom.equalTo(self).offset(-20)
        }
    }
    
    private func setHeaderView() {
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
    }
    
    // MARK: - Public Attributes
    public var imageUrl: String? = "" {
        didSet {
            albumImage.backgroundColor = UIColor.green
        }
    }
    
    // MARK: - Controller Attributes
    fileprivate var _albumImage: UIImageView?
    fileprivate var _splitLine: UIView?
    fileprivate var _categoryView: UIView?
    fileprivate var _categoryCollection: UICollectionView?
    fileprivate var _bottomSplitLine: UIView?
}

// MARK: - UICollecitonView Data Source
extension GoodsHomeHeaderView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoodsCategoryCell.self), for: indexPath) as! GoodsCategoryCell
        cell.categoryImage.backgroundColor = UIColor.blue
        cell.categoryLabel.text = "趣玩"
        
        return cell
    }
}

// MARK: - UICollecitonView Delegate
extension GoodsHomeHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShareCollectionCell.self), for: indexPath) as! ShareCollectionCell
        //        guard let shareType = cell.shareType else { return }
        //        ShareTool.sharedInstance.shareWith(content: nil, to: shareType)
    }
}

// MARK: - Getters and Setters
extension GoodsHomeHeaderView {
    
    fileprivate var albumImage: UIImageView {
        if _albumImage == nil {
            _albumImage = UIImageView()
            _albumImage?.layer.cornerRadius = CGFloat(6)
            _albumImage?.layer.masksToBounds = true
        }
        
        return _albumImage!
    }
    
    fileprivate var splitLine: UIView {
        if _bottomSplitLine == nil {
            _bottomSplitLine = UIView()
            _bottomSplitLine?.backgroundColor = UIColor.black
        }
        
        return _bottomSplitLine!
    }
    
    fileprivate var categoryView: UIView {
        if _categoryView == nil {
            _categoryView = UIView()
            _categoryView?.backgroundColor = UIColor.white
            _categoryView?.layer.cornerRadius = CGFloat(5)
            _categoryView?.layer.masksToBounds = true
        }
        
        return _categoryView!
    }
    
    fileprivate var categoryCollection: UICollectionView {
        if _categoryCollection == nil {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            let sizeValue = ((Size.screenWidth - 60) / 3)
            flowLayout.itemSize = CGSize(width: sizeValue, height: sizeValue)
            _categoryCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
            _categoryCollection?.register(GoodsCategoryCell.self, forCellWithReuseIdentifier: String(describing: GoodsCategoryCell.self))
            _categoryCollection?.showsVerticalScrollIndicator = false
            _categoryCollection?.translatesAutoresizingMaskIntoConstraints = false
            _categoryCollection?.isScrollEnabled = false
            _categoryCollection?.backgroundColor = UIColor.clear
        }
        
        return _categoryCollection!
    }
    
    fileprivate var bottomSplitLine: UIView {
        if _splitLine == nil {
            _splitLine = UIView()
            _splitLine?.backgroundColor = UIColor.black
        }
        
        return _splitLine!
    }
}
