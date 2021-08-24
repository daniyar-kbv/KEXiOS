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

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom + 75, right: 0)
        view.delaysContentTouches = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private lazy var contentView = UIView()

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

    private(set) lazy var modifiersTableView: UITableView = {
        let view = UITableView()
        view.register(MenuDetailModifierCell.self, forCellReuseIdentifier: String(describing: MenuDetailModifierCell.self))
        view.isScrollEnabled = false
        view.separatorStyle = .none
        view.estimatedRowHeight = 51
        return view
    }()

    private lazy var commentaryField: MapTextField = {
        let view = MapTextField()
        view.placeholder = SBLocalization.localized(key: MenuText.MenuDetail.commentPlaceholder)
        return view
    }()

    private(set) lazy var proceedButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .filledRed)
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
        commentaryField.set(text: text)
    }

    func setImageView(with url: URL) {
        imageView.setImage(url: url)
    }

    private func configureActions() {
        proceedButton.addTarget(self, action: #selector(proceedButtonTapped), for: .touchUpInside)
    }

    private func layoutUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        [imageView, itemTitleLabel, descriptionLabel, modifiersTableView, commentaryField].forEach {
            contentView.addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(snp.width).multipliedBy(298 / 217)
        }

        itemTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
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
            $0.top.equalTo(modifiersTableView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(50)
            $0.bottom.equalToSuperview()
        }

        addSubview(proceedButton)
        proceedButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }

    func updateTableViewHeight() {
        modifiersTableView.snp.updateConstraints {
            $0.height.equalTo(modifiersTableView.contentSize.height)
        }
    }

    func setProceedButton(isActive: Bool) {
        proceedButton.isEnabled = isActive
    }

    func setCommentary(action: @escaping () -> Void) {
        commentaryField.onShouldBeginEditing = action
    }

    @objc private func commetaryViewTapped(_: UITapGestureRecognizer? = nil) {
        delegate?.commentaryViewTapped()
    }

    @objc private func proceedButtonTapped() {
        delegate?.proceedButtonTapped()
    }
}
