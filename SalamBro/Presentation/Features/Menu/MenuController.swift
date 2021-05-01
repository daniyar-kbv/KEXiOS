//
//  MenuController.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit

class MenuController: UIViewController {
    var item: [Food] = []
    
    var menuViewModel: MenuViewModel = MenuViewModel(menuRepository: MenuRepositoryMockImpl())
    
    lazy var rootView = MenuView(delegate: self)
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
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
            return rootView.categoryCollectionView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return menuViewModel.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdCollectionCell", for: indexPath)
                return cell
            } else if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddressPickCell", for: indexPath)
                return cell
            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.bindData(item: menuViewModel.items[indexPath.row])
            return cell
        }
    }
}

extension MenuController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuViewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryLabel.text = menuViewModel.categories[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        let textSize = menuViewModel.categories[indexPath.row].title.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        width = textSize.width + 8
        height = 44
        return .init(width: width, height: height)
    }
}
