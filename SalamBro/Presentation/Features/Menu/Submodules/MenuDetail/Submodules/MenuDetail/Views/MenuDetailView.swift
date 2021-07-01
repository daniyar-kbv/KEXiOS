//
//  MenuDetailView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/22/21.
//

import SnapKit
import UIKit

protocol MenuDetailViewDelegate: AnyObject {
    func commentaryViewTapped()
    func proceedButtonTapped()
}

final class MenuDetailView: UIView {
    weak var delegate: MenuDetailViewDelegate?

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private(set) lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    lazy var modifiersTableView: UITableView = {
        let view = UITableView()
        view.register(MenuDetailModifierCell.self, forCellReuseIdentifier: String(describing: MenuDetailModifierCell.self))
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.rowHeight = 51
        return view
    }()

    private lazy var commentaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        return view
    }()

    private lazy var commentaryField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(
            string: L10n.MenuDetail.commentaryField,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        view.borderStyle = .none
        view.clearButtonMode = .never
        view.minimumFontSize = 17
        view.adjustsFontSizeToFitWidth = true
        view.contentHorizontalAlignment = .left
        view.contentVerticalAlignment = .center
        view.isUserInteractionEnabled = false
        return view
    }()

    private(set) lazy var proceedButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .kexRed
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    init(delegate: MenuDetailViewDelegate) {
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

extension MenuDetailView {
    func configureTextField(text: String) {
        commentaryField.text = text
    }

    func setImageView(with url: URL) {
        imageView.setImage(url: url)
    }

    private func configureActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(commetaryViewTapped(_:)))
        commentaryView.addGestureRecognizer(tap)

        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
    }

    private func layoutUI() {
        commentaryView.addSubview(commentaryField)
        [imageView, itemTitleLabel, descriptionLabel, modifiersTableView, commentaryView, proceedButton].forEach {
            addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(43)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalToSuperview().multipliedBy(0.33)
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(27)
            $0.left.right.equalToSuperview().inset(24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(itemTitleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
        }

        modifiersTableView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(0)
        }

        commentaryField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.centerX.centerY.equalToSuperview()
        }

        commentaryView.snp.makeConstraints {
            $0.top.equalTo(modifiersTableView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }

        proceedButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }

    func updateTableViewHeight() {
        let height = CGFloat((0 ..< modifiersTableView.numberOfSections)
            .map { modifiersTableView.numberOfRows(inSection: $0) }
            .reduce(0, +))
            * modifiersTableView.rowHeight

        modifiersTableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

    func setProceedButton(isActive: Bool) {
        proceedButton.backgroundColor = isActive ? .kexRed : .calmGray
        proceedButton.isUserInteractionEnabled = isActive
    }

    @objc private func commetaryViewTapped(_: UITapGestureRecognizer? = nil) {
        delegate?.commentaryViewTapped()
    }

    @objc func proceedButtonTapped() {
        delegate?.proceedButtonTapped()
    }
}
