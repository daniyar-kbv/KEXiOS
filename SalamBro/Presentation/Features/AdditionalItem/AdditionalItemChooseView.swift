//
//  AdditionalItemChooseView.swift
//  DetailView
//
//  Created by Arystan on 5/1/21.
//

import UIKit

class AdditionalItemChooseView: UIView {
    var delegate: AdditionalItemDelegate?

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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var collectionView = UICollectionView()

    init(delegate: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) {
        super.init(frame: .zero)
        setupCollectionView(delegate)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        backgroundColor = .white
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        addSubview(backButton)
    }

    func setupConstraints() {
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        backButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true

        collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 24).isActive = true
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupCollectionView(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 160, height: 195)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.register(AdditionalItemCell.self, forCellWithReuseIdentifier: "AdditionalItemCell")
        collectionView.showsVerticalScrollIndicator = false
    }

    @objc func backButtonTapped(_: UIButton!) {
        print("tapped")
        delegate?.dissmissView()
    }
}
