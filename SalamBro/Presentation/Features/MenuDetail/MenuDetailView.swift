//
//  MenuDetailView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/22/21.
//

import UIKit

class MenuDetailView: UIView {
    public lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    public lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    public lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    public lazy var commentaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()

    private lazy var chooseAdditionalItemView = UIView()

    private lazy var chooseAdditionalItemLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.text = L10n.MenuDetail.additionalItemLabel
        view.textColor = .systemGray
        view.font = .systemFont(ofSize: 12)
        return view
    }()

    private lazy var additionalItemLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    public lazy var chooseAdditionalItemButton: UIButton = {
        let view = UIButton()
        view.setTitle(L10n.MenuDetail.chooseAdditionalItemButton, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.setTitleColor(.kexRed, for: .normal)
        return view
    }()

    public lazy var commentaryField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(
            string: L10n.MenuDetail.commentaryField,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        view.isEnabled = false
        return view
    }()

    public lazy var proceedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .kexRed
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuDetailView {
    private func layoutUI() {
        [chooseAdditionalItemLabel, additionalItemLabel, chooseAdditionalItemButton].forEach { chooseAdditionalItemView.addSubview($0)
        }
        commentaryView.addSubview(commentaryField)
        [imageView, itemTitleLabel, descriptionLabel, chooseAdditionalItemView, commentaryView, proceedButton].forEach {
            addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(43)
            $0.left.equalToSuperview().offset(40)
            $0.right.equalToSuperview().offset(-40)
            $0.height.equalToSuperview().multipliedBy(0.33)
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(27)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        chooseAdditionalItemLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        additionalItemLabel.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview()
            $0.right.equalTo(chooseAdditionalItemButton.snp.left).offset(-8)
            $0.bottom.equalToSuperview()
        }

        chooseAdditionalItemButton.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalTo(additionalItemLabel.snp.centerY)
        }

        chooseAdditionalItemView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(36)
        }

        commentaryField.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }

        commentaryView.snp.makeConstraints {
            $0.top.equalTo(chooseAdditionalItemView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        proceedButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }
}
