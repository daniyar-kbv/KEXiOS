//
//  AdditionalItemChooseController.swift
//  DetailView
//
//  Created by Arystan on 5/1/21.
//

import UIKit

class AdditionalItemChooseController: UIViewController {
    lazy var rootView = AdditionalItemChooseView(delegate: self)

    override func loadView() {
        view = rootView
        rootView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AdditionalItemChooseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdditionalItemCell", for: indexPath) as! AdditionalItemCell
        return cell
    }
}

extension AdditionalItemChooseController: AdditionalItemDelegate {
    func dissmissView() {
        dismiss(animated: true, completion: nil)
    }
}
