//
//  MenuView.swift
//  SalamBro
//
//  Created by Arystan on 4/28/21.
//

import UIKit

class MenuView: UIView {

    lazy var categoryCollectionView: UICollectionView = UICollectionView()
    
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SalamBro4")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var brandLabel: UILabel = {
        let view = UILabel()
        view.text = "SalamBro"
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var brandSelectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var itemTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(delegate: (UITableViewDelegate & UITableViewDataSource & UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout)) {
        
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupTableView(delegate)
        setupCollectionView(delegate)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
        brandSelectView.addSubview(logoView)
        brandSelectView.addSubview(brandLabel)
        addSubview(brandSelectView)
        addSubview(itemTableView)
    }
    
    func setupConstraints() {
        logoView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        logoView.topAnchor.constraint(equalTo: brandSelectView.topAnchor).isActive = true
        logoView.leftAnchor.constraint(equalTo: brandSelectView.leftAnchor).isActive = true
        
        brandLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: 8).isActive = true
        brandLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        
        brandSelectView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        brandSelectView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        brandSelectView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        brandSelectView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        itemTableView.topAnchor.constraint(equalTo: brandSelectView.bottomAnchor, constant: 8).isActive = true
        itemTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        itemTableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        itemTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupTableView(_ delegate: (UITableViewDelegate & UITableViewDataSource)) {
        
        itemTableView.register(UINib(nibName: "AddressPickCell", bundle: nil), forCellReuseIdentifier: "AddressPickCell")
        itemTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        itemTableView.register(UINib(nibName: "AdCollectionCell", bundle: nil), forCellReuseIdentifier: "AdCollectionCell")
        
        itemTableView.delegate = delegate
        itemTableView.dataSource = delegate

        itemTableView.showsVerticalScrollIndicator = false
        itemTableView.bounces = false
        itemTableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func setupCollectionView(_ delegate: UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal

        categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 44), collectionViewLayout: layout)
        
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        
        categoryCollectionView.dataSource = delegate
        categoryCollectionView.delegate = delegate
        

        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}
