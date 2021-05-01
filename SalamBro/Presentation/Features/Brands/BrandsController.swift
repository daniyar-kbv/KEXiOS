//
//  BrandsController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class BrandsController: UIViewController {
    
    var brands: [Brand] = APIService.shared.getFigmaBrands().0
    var ratios: [ratio] = APIService.shared.getFigmaBrands().1
    
    lazy var refreshControl : UIRefreshControl = {
        let action = UIRefreshControl()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        setupCollectionView()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
    }
    
    func setupConstraints() {
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = L10n.Brands.Navigation.title
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.black,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]
    }
    
    func setupCollectionView() {
        collectionView.collectionViewLayout = StagLayout(widthHeightRatios: ratios, itemSpacing: 16)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension BrandsController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
        cell.backgroundColor = .clear
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
}

