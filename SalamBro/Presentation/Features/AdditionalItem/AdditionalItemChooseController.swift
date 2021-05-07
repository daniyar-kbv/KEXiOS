//
//  AdditionalItemChooseController.swift
//  DetailView
//
//  Created by Arystan on 5/1/21.
//

import UIKit

class AdditionalItemChooseController: UIViewController {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .systemRed
        button.setImage(UIImage(named: "back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Выберите напиток"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.register(AdditionalItemCell.self, forCellWithReuseIdentifier: "AdditionalItemCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = StagLayout(widthHeightRatios: [(0.5, 0.6), (0.5, 0.6)], itemSpacing: 8)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(backButton)
    }

    func setupConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true

        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true

        collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc func backButtonTapped(_: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}

extension AdditionalItemChooseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = view.frame.size.height
//        let width = view.frame.size.width
//        // in case you you want the cell to be 40% of your controllers view
//        return CGSize(width: width * 0.45, height: width * 0.45)
//    }

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
