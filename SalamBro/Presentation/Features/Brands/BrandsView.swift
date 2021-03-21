//
//  BrandsView.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

protocol BrandsViewDelegate {
    func test()
}

class BrandsView: UIView {
    public var delegate: BrandsViewDelegate?
    
    lazy var brandsCollectionView: UICollectionView = {
        let f = UICollectionViewFlowLayout()
        f.scrollDirection = .vertical
        let collection = UICollectionView(frame: frame, collectionViewLayout: f)
        collection.showsVerticalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    init(delegate: (UICollectionViewDelegate & UICollectionViewDataSource & BrandsViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.brandsCollectionView.dataSource = delegate
        self.brandsCollectionView.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        brandsCollectionView.reloadData()
    }
}

extension BrandsView {
    func setupViews() {
        backgroundColor = .white
        addSubview(brandsCollectionView)
    }
    
    func setupConstraints() {
        brandsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        brandsCollectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        brandsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        brandsCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
    }
}
