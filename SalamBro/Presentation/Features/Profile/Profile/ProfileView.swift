//
//  ProfileView.swift
//  SalamBro
//
//  Created by Dan on 8/5/21.
//

import Foundation
import UIKit

final class ProfileView: UIView {
    private var needsLayoutUI = true

    private(set) lazy var phoneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .mildBlue
        return label
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private(set) lazy var changeNameButton: SBTextButton = {
        let button = SBTextButton()
        button.setTitle(SBLocalization.localized(key: ProfileText.Profile.editButton), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    private(set) lazy var middleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, changeNameButton])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 24
        return view
    }()

    private(set) lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()

    private(set) lazy var topStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [phoneTitleLabel, middleStack, emailLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.setCustomSpacing(8, after: phoneTitleLabel)
        return view
    }()

    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .mildBlue
        table.addTableHeaderViewLine()
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.rowHeight = 50
        table.delaysContentTouches = false
        return table
    }()

    private(set) lazy var logoutButton: SBSubmitButton = {
        let button = SBSubmitButton(style: .emptyGray)
        button.setTitle(SBLocalization.localized(key: ProfileText.Profile.logoutButton), for: .normal)
        return button
    }()

    func layoutUI() {
        guard needsLayoutUI else { return }
        needsLayoutUI = false

        backgroundColor = .arcticWhite

        [topStack, logoutButton, tableView].forEach { addSubview($0) }

        topStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

        logoutButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(19)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(logoutButton.snp.top).offset(-8)
        }
    }
}
