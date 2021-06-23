//
//  RateView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/21/21.
//

import Cosmos
import SnapKit
import UIKit

final class RateView: UIView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private lazy var cosmosContainerView: UIView = {
        let view = UIView()
        return view
    }()

    public lazy var cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.filledColor = .kexRed
        view.settings.filledBorderColor = .kexRed
        view.settings.filledBorderWidth = 0
        view.settings.emptyBorderColor = .kexRed
        view.settings.emptyColor = .white
        view.settings.starSize = 30
        view.settings.starMargin = 16
        view.settings.emptyImage = UIImage(named: "star.empty")
        view.settings.filledImage = UIImage(named: "star.filled")
        view.rating = 0
        return view
    }()

    public lazy var questionLabel: UILabel = {
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

    public lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = L10n.RateOrder.description
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.contentMode = .left
        label.numberOfLines = 0
        return label
    }()

    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    public lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        return view
    }()

    public lazy var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(
            string: L10n.RateOrder.CommentaryField.placeholder,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        textfield.borderStyle = .none
        textfield.clearButtonMode = .never
        textfield.minimumFontSize = 17
        textfield.adjustsFontSizeToFitWidth = true
        textfield.contentHorizontalAlignment = .left
        textfield.contentVerticalAlignment = .center
        textfield.isUserInteractionEnabled = false
        return textfield
    }()

    public lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.RateOrder.SubmitButton.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mildBlue
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.cornerRadius = 10
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.adjustsImageWhenHighlighted = true
        button.adjustsImageWhenDisabled = true
        return button
    }()

    public var collectionViewHeightConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RateView {
    private func configureViews() {
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true
        collectionView.register(cellType: RateItemCell.self)

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: safeAreaInsets.bottom + 50, right: 0)
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

        [cosmosContainerView, questionLabel, suggestionLabel, collectionView, commentView].forEach {
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
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(cosmosContainerView.snp.bottom).offset(32)
        }

        suggestionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(questionLabel.snp.bottom).offset(8)
        }

        collectionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(suggestionLabel.snp.bottom).offset(8)
            collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }

        commentView.addSubview(commentTextField)

        commentView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }

        commentTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerX.centerY.equalToSuperview()
        }

        sendButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }
}
