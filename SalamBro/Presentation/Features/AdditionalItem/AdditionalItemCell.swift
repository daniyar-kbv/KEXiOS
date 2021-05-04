//
//  AdditionalItemCell.swift
//  DetailView
//
//  Created by Arystan on 5/2/21.
//

import UIKit

class AdditionalItemCell: UICollectionViewCell {
    lazy var itemImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "cola")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var itemTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Вода “Coca-Cola” 0,5 л"
        view.font = .systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var itemPriceLabel: UILabel = {
        let view = UILabel()
        view.text = "0 ₸"
        view.font = .systemFont(ofSize: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(itemImageView)
        contentView.addSubview(itemTitleLabel)
        contentView.addSubview(itemPriceLabel)
    }

    func setupConstraints() {
        itemImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 155).isActive = true
        itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        itemTitleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8).isActive = true
        itemTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        itemTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true

        itemPriceLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 4).isActive = true
        itemPriceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        itemPriceLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        itemPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
