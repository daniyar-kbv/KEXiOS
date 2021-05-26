//
//  AdditionalItemChooseController.swift
//  DetailView
//
//  Created by Arystan on 5/1/21.
//

import UIKit

class AdditionalItemChooseController: ViewController {
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .kexRed
        button.setImage(UIImage(named: "chevron.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
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

        collectionView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }

    @objc func backButtonTapped(_: UIButton!) {
        dismiss(animated: true, completion: nil)
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
