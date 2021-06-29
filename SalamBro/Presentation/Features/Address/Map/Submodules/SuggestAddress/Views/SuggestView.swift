//
//  SuggestView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/21/21.
//

import UIKit

protocol SuggestViewDelegate: AnyObject {
    func searchBarTapped(_ textField: UITextField)
    func doneButtonTapped()
}

final class SuggestView: UIView {
    weak var delegate: SuggestViewDelegate?

    private lazy var searchItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.tintColor = .mildBlue
        return imageView
    }()

    private(set) lazy var searchBar: UITextField = {
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

    private lazy var doneButton: UIButton = {
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

    init(delegate: SuggestViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        layoutUI()
        configureActions()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SuggestView {
    private func configureActions() {
        searchBar.addTarget(self, action: #selector(queryChange(sender:)), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }

    func setSearchBarText(with text: String) {
        searchBar.text = text
    }

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

    @objc private func queryChange(sender: UITextField) {
        delegate?.searchBarTapped(sender)
    }

    @objc private func cancelAction(_: UIButton) {
        delegate?.doneButtonTapped()
    }
}
