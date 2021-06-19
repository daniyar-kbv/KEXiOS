//
//  RateController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Cosmos
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class RateController: UIViewController {
    private let viewModel: RateViewModel
    private let disposeBag = DisposeBag()

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
        view.settings.emptyImage = UIImage(named: "star.empty")
        view.settings.filledImage = UIImage(named: "star.filled")
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
        label.text = L10n.RateOrder.description
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.contentMode = .left
        label.numberOfLines = 0
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        return view
    }()

    private lazy var commentTextField: UITextField = {
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

    private lazy var sendButton: UIButton = {
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
        button.addTarget(self, action: #selector(dismissVC), for: .allTouchEvents)
        return button
    }()

    private var collectionViewHeightConstraint: Constraint?

    private var overlay = OverlayTransitioningDelegate()

    init(viewModel: RateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint?.update(offset: collectionView.contentSize.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.title = L10n.RateOrder.title
    }
}

extension RateController {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        [scrollView, sendButton].forEach {
            view.addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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

        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true
        collectionView.register(cellType: RateItemCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self

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
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(43)
        }

        cosmosView.didFinishTouchingCosmos = didFinishTouchRating

        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(commentaryViewTapped))
        commentView.addGestureRecognizer(tapCommentary)

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 50, right: 0)
    }

    private func didFinishTouchRating(_ rating: Double) {
        sendButton.isEnabled = true
        sendButton.backgroundColor = .kexRed
        switch rating {
        case 1.0 ..< 2.0:
            questionLabel.text = L10n.RateOrder.BadRate.title
            suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            viewModel.data = viewModel.arrayStar13
        case 2.0 ..< 3.0:
            questionLabel.text = L10n.RateOrder.BadRate.title
            suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            viewModel.data = viewModel.arrayStar13
        case 3.0 ..< 4.0:
            questionLabel.text = L10n.RateOrder.AverageRate.title
            suggestionLabel.text = L10n.RateOrder.AverageRate.title
            viewModel.data = viewModel.arrayStar13
        case 4.0 ..< 5.0:
            questionLabel.text = L10n.RateOrder.GoodRate.title
            suggestionLabel.text = L10n.RateOrder.GoodRate.subtitle
            viewModel.data = viewModel.arrayStar4
        case 5.0:
            questionLabel.text = L10n.RateOrder.ExcellentRate.title
            suggestionLabel.text = L10n.RateOrder.ExcellentRate.subtitle
            viewModel.data = viewModel.arrayStar5
        default:
            questionLabel.text = nil
            suggestionLabel.text = nil
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}

extension RateController: OverlaySheetDelegate {
    func passCommentary(text: String) {
        commentTextField.text = text
    }
}

extension RateController {
    @objc func dismissVC() {
        if navigationController?.presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController?.popViewController(animated: true)
    }

    @objc func commentaryViewTapped() {
        let overlayVC = OverlayViewController()
        overlayVC.transitioningDelegate = overlay
        overlayVC.modalPresentationStyle = .custom
        overlayVC.delegate = self
        present(overlayVC, animated: true, completion: nil)
    }
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(for: indexPath, cellType: RateItemCell.self)
        cell.titleLabel.text = viewModel.data[indexPath.row]
        if viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) != nil {
            cell.setSelectedUI()
        } else {
            cell.setDeselectedUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.selectedItems.remove(at: index)
            cell.setDeselectedUI()
        } else {
            cell.setSelectedUI()
            viewModel.selectedItems.append(viewModel.data[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = viewModel.selectedItems.firstIndex(of: viewModel.data[indexPath.row]) {
            viewModel.selectedItems.remove(at: index)
        }
        cell.setDeselectedUI()
    }
}
