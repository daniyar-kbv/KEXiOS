//
//  BrandsController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class BrandsController: UIViewController {
    
    var brands: [Brand] = []
    var ratios: [ratio] = []
    
    lazy var refreshControl : UIRefreshControl = {
        let action = UIRefreshControl()
        action.attributedTitle = NSAttributedString(string: "Pull to refresh")
        action.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return action
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )

        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(BrandCell.self, forCellWithReuseIdentifier: "BrandCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose brand"
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shuffleButton: UIButton = {
        let button = UIButton()
        button.setTitle("shuffle", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(shuffle), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (brands, ratios) = APIService.shared.getFigmaBrands()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios, itemSpacing: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(shuffleButton)
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true

        shuffleButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        shuffleButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(AuthorizationController(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
        cell.backgroundColor = .clear
        cell.titleLabel.text = brands[indexPath.row].name + ", cellIndex: " + "\(indexPath.row)"
        cell.imageView.image = UIImage(named: "\(brands[indexPath.row].name + String(brands[indexPath.row].priority))")
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.0) {
            cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell.layoutSubviews()
        }
        return cell
    }
}

extension BrandsController {
    @objc func refresh(_ sender: AnyObject) {
        (brands, ratios) = APIService.shared.getCountries()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios, itemSpacing: 16)
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func shuffle(_ sender: UIButton) {
        var brandNames: [String] = []
        for i in brands {
            brandNames.append(i.name)
        }
        brandNames.shuffle()
        for i in 0..<brands.count {
            brands[i].name = brandNames[i]
        }
        collectionView.reloadData()
    }
}

