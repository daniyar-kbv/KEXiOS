//
//  BrandsController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

class BrandsController: UIViewController {
    
    fileprivate lazy var rootView = BrandsView(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    override func loadView() {
        view = rootView
    }
}

extension BrandsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.backgroundView = UIImageView(image: UIImage(named: "logo"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width) - 10
        let height: CGFloat = 100
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("proceed to next vc")
        self.navigationController?.pushViewController(AuthorizationController(), animated: true)
    }
    
}

extension BrandsController: BrandsViewDelegate {
    func test() {
        print("call of test() from BrandsViewDelegate")
    }
}

extension BrandsController {
    private func configUI() {
        navigationItem.title = "Choose brand"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
