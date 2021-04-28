//
//  TestController.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit

class TestController: UIViewController {
    
    var categoryCollectionView: UICollectionView!
    var categories: [FoodType] = APIService.shared.getCategories()
    var item: [Food] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCollectionView()
        setupTableView()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        brandSelectView.addSubview(logoView)
        brandSelectView.addSubview(brandLabel)
        view.addSubview(brandSelectView)
        view.addSubview(itemTableView)
    }
    
    func setupConstraints() {
        logoView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        logoView.topAnchor.constraint(equalTo: brandSelectView.topAnchor).isActive = true
        logoView.leftAnchor.constraint(equalTo: brandSelectView.leftAnchor).isActive = true
        
        brandLabel.leftAnchor.constraint(equalTo: logoView.rightAnchor, constant: 8).isActive = true
        brandLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor).isActive = true
        
        brandSelectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        brandSelectView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        brandSelectView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        brandSelectView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        itemTableView.topAnchor.constraint(equalTo: brandSelectView.bottomAnchor, constant: 8).isActive = true
        itemTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        itemTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        itemTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupTableView() {
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(UINib(nibName: "AddressPickCell", bundle: nil), forCellReuseIdentifier: "AddressPickCell")
        itemTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        itemTableView.register(UINib(nibName: "AdTableViewCell", bundle: nil), forCellReuseIdentifier: "AdTableViewCell")
        itemTableView.showsVerticalScrollIndicator = false
        itemTableView.bounces = false
        itemTableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.scrollDirection = .horizontal

        categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44), collectionViewLayout: layout)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
}

extension TestController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 44
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView(frame: CGRect.zero)
        } else if section == 1 {
            return categoryCollectionView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "text"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath)
                return cell
            } else if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressPickCell", for: indexPath)
                return cell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
            return cell
        }
    }
}

extension TestController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = categories[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        let text = categories[indexPath.row]
        let textSize = text.title.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        width = textSize.width + 8
        height = 44
        return .init(width: width, height: height)
    }
}
