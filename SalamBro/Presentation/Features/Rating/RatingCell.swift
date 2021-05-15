//
//  RatingCell.swift
//  SalamBro
//
//  Created by Arystan on 5/6/21.
//

import UIKit

public final class RatingCell: UITableViewCell {
    lazy var placeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var placeLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.text = "text"
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.text = "instagram"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var sumLabel: UILabel = {
        let view = UILabel()
        view.text = "123"
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            self.nameLabel,
            self.usernameLabel,
        ])
        view.alignment = .leading
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder _: NSCoder) { nil }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        [placeImageView, stackView, sumLabel, placeLabel].forEach { contentView.addSubview($0) }
    }

    private func setupConstraints() {
        placeImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 40, height: 50))
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        placeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }

        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(56)
            $0.right.equalTo(sumLabel.snp.left).offset(-8)
            $0.centerY.equalToSuperview()
        }

        sumLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }

    func bindData(place: Int, name: String, link: String, price: String) {
        placeLabel.text = "\(place)"
        nameLabel.text = name
        usernameLabel.text = "@" + link
        sumLabel.text = price + "₸"
    }
}
