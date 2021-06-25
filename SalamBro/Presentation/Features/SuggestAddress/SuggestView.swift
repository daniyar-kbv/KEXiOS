//
//  SuggestView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/21/21.
//

import SnapKit
import UIKit

final class SuggestView: UIView {
    private lazy var searchItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.tintColor = .mildBlue
        return imageView
    }()

    public lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.attributedPlaceholder = NSAttributedString(
            string: L10n.Suggest.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        searchBar.borderStyle = .none
        searchBar.clearButtonMode = .never
        searchBar.minimumFontSize = 17
        searchBar.adjustsFontSizeToFitWidth = true
        searchBar.contentHorizontalAlignment = .left
        searchBar.contentVerticalAlignment = .center
        return searchBar
    }()

    public lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Suggest.Button.title, for: .normal)
        button.setTitleColor(.kexRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.adjustsImageWhenHighlighted = true
        button.adjustsImageWhenDisabled = true
        return button
    }()

    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
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

extension SuggestView {
    private func layoutUI() {
        backgroundColor = .arcticWhite
        [searchItem, searchBar, doneButton, separator].forEach {
            addSubview($0)
        }

        searchItem.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(24)
            $0.height.equalTo(28)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19)
            $0.left.equalTo(searchItem.snp.right).offset(8)
            $0.centerY.equalTo(searchItem.snp.centerY)
        }

        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(searchBar.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(searchBar.snp.centerY)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(searchItem.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(0.3)
            $0.bottom.equalToSuperview()
        }
    }
}
