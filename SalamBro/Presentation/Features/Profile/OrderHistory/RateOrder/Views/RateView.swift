//
//  RateView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/21/21.
//

import Cosmos
import SnapKit
import UIKit

protocol RateViewDelegate: AnyObject {
    func sendButtonTapped()
    func updateViewModelData(at rating: Int)
}

final class RateView: UIView {
    weak var delegate: RateViewDelegate?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var cosmosContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.filledColor = .kexRed
        view.settings.filledBorderColor = .kexRed
        view.settings.filledBorderWidth = 0
        view.settings.emptyBorderColor = .kexRed
        view.settings.emptyColor = .white
        view.settings.starSize = 30
        view.settings.starMargin = 16
        view.settings.emptyImage = SBImageResource.getIcon(for: ProfileIcons.RateOrder.starEmpty)
        view.settings.filledImage = SBImageResource.getIcon(for: ProfileIcons.RateOrder.starFilled)
        view.rating = 0
        return view
    }()

    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.contentMode = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = SBLocalization.localized(key: ProfileText.RateOrder.Description.defaultTitle)
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.contentMode = .left
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var commentTextField: MapTextField = {
        let view = MapTextField()
        view.placeholder = SBLocalization.localized(key: ProfileText.RateOrder.commentaryPlaceholder)
        return view
    }()

    private lazy var sendButton: SBSubmitButton = {
        let button = SBSubmitButton(style: .filledRed)
        button.setTitle(SBLocalization.localized(key: ProfileText.RateOrder.submitButton), for: .normal)
        return button
    }()

    private var questionTitle: String = ""
    private var suggestionDescription: String = ""
    private(set) var rating: Int = 0

    private(set) var collectionViewHeightConstraint: Constraint?

    init(delegate: RateViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        layoutUI()
        configureActions()
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RateView {
    private func configureActions() {
        sendButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }

    private func configureViews() {
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true
        collectionView.register(cellType: RateItemCell.self)

        scrollView.contentInset = UIEdgeInsets(top: 0,
                                               left: 0,
                                               bottom: safeAreaInsets.bottom + 50,
                                               right: 0)

        cosmosView.didFinishTouchingCosmos = didFinishTouchRating
    }

    func setCollectionViewHeight() {
        collectionViewHeightConstraint?.update(offset: collectionView.contentSize.height)
    }

    func configureTextField(with text: String) {
        commentTextField.set(text: text)
    }

    func getComment() -> String {
        if !commentTextField.isEmpty {
            return commentTextField.text
        } else {
            return ""
        }
    }

    private func layoutUI() {
        [scrollView, sendButton].forEach {
            addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.width.equalTo(scrollView)
        }

        [cosmosContainerView, questionLabel, suggestionLabel, collectionView, commentTextField].forEach {
            contentView.addSubview($0)
        }

        cosmosContainerView.addSubview(cosmosView)

        cosmosView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }

        cosmosContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(34)
            $0.left.right.equalToSuperview()
        }

        questionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(cosmosContainerView.snp.bottom).offset(32)
        }

        suggestionLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(questionLabel.snp.bottom).offset(8)
        }

        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(suggestionLabel.snp.bottom).offset(8)
            collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }

        commentTextField.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.greaterThanOrEqualTo(50)
        }

        sendButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }

    func configureQuestionLabel(title: String) {
        questionTitle = title
    }

    func configureSuggestionLabel(description: String) {
        suggestionDescription = description
    }

    private func didFinishTouchRating(_ rating: Double) {
        sendButton.isEnabled = true
        self.rating = Int(rating)
        delegate?.updateViewModelData(at: self.rating)
        questionLabel.text = questionTitle
        suggestionLabel.text = suggestionDescription
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    @objc private func dismissVC() {
        delegate?.sendButtonTapped()
    }

    func setCommentary(action: @escaping () -> Void) {
        commentTextField.onShouldBeginEditing = action
    }
}
