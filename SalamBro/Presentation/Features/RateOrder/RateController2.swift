//
//  RateController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/16/21.
//

import Cosmos
import SnapKit
import UIKit

class RateController2: UIViewController {
    private var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .red
        return view
    }()

    private var contentView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .arcticWhite
        return view
    }()

    private var cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.filledColor = .kexRed
        view.settings.filledBorderColor = .kexRed
        view.settings.filledBorderWidth = 0
        view.settings.emptyBorderColor = .kexRed
        view.settings.emptyColor = .white
        view.settings.starSize = 30
        view.settings.starMargin = 16
        view.settings.minTouchRating = 0
        view.settings.emptyImage = UIImage(named: "star.empty")
        view.settings.filledImage = UIImage(named: "star.filled")
        return view
    }()

    private var questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.text = L10n.RateOrder.title
        label.textColor = .darkGray
        label.baselineAdjustment = .alignBaselines
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.contentMode = .left
        label.numberOfLines = 0
        return label
    }()

    private var suggestionLabel: UILabel = {
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

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 10
        return view
    }()

    private let commentTextField: UITextField = {
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
        return textfield
    }()

    private let sendButton: UIButton = {
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

    lazy var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        return view
    }()

    var data: [String] = []

    var arrayStar13: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.CourierNotFoundClient.text, L10n.RateOrder.Cell.FoodIsMissing.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar4: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar5: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text]

    // MARK: Tech Debt - Create in a viewModel

    var selectedItems: [String] = []

    lazy var commentarySheetVC = CommentarySheetController()

    init() {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = .arcticWhite
        // navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.title = L10n.RateOrder.title
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
    }
}

extension RateController2 {
    private func layoutUI() {
        view.backgroundColor = .arcticWhite

        [scrollView, sendButton].forEach {
            view.addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalTo(view)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView)
            $0.left.right.equalTo(view)
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }

        [cosmosView, questionLabel, suggestionLabel, collectionView, commentView].forEach {
            contentView.addSubview($0)
        }

        cosmosView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(100)
            $0.right.equalToSuperview().offset(-100)
            $0.top.equalToSuperview().offset(34)
        }

        questionLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(cosmosView.snp.bottom).offset(32)
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
            $0.height.equalTo(300)
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
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }

        commentTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
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

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 100, bottom: view.safeAreaInsets.bottom - 50, right: 100)

        view.addSubview(shadow)
        shadow.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }

    private func didFinishTouchRating(_ rating: Double) {
        sendButton.isEnabled = true
        sendButton.backgroundColor = .kexRed
        switch rating {
        case 1.0 ..< 2.0:
            questionLabel.text = L10n.RateOrder.BadRate.title
            suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 2.0 ..< 3.0:
            questionLabel.text = L10n.RateOrder.BadRate.title
            suggestionLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 3.0 ..< 4.0:
            questionLabel.text = L10n.RateOrder.AverageRate.title
            suggestionLabel.text = L10n.RateOrder.AverageRate.title
            data = arrayStar13
        case 4.0 ..< 5.0:
            questionLabel.text = L10n.RateOrder.GoodRate.title
            suggestionLabel.text = L10n.RateOrder.GoodRate.subtitle
            data = arrayStar4
        case 5.0:
            questionLabel.text = L10n.RateOrder.ExcellentRate.title
            suggestionLabel.text = L10n.RateOrder.ExcellentRate.subtitle
            data = arrayStar5
        default:
            questionLabel.text = nil
            suggestionLabel.text = nil
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
}

extension RateController2 {
    @objc func dismissVC() {
        print("dismiss")
    }

    @objc func commentaryViewTapped() {
        showCommentarySheet()
    }

    @objc func goBack() {
        if navigationController?.presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }

        navigationController?.popViewController(animated: true)
    }
}

extension RateController2: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(for: indexPath, cellType: RateItemCell.self)
        cell.titleLabel.text = data[indexPath.row]
        if selectedItems.firstIndex(of: data[indexPath.row]) != nil {
            cell.setSelectedUI()
        } else {
            cell.setDeselectedUI()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = selectedItems.firstIndex(of: data[indexPath.row]) {
            selectedItems.remove(at: index)
            cell.setDeselectedUI()
        } else {
            cell.setSelectedUI()
            selectedItems.append(data[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        if let index = selectedItems.firstIndex(of: data[indexPath.row]) {
            selectedItems.remove(at: index)
        }
        cell.setDeselectedUI()
    }
}

// MARK: Tech Debt - Change from MapDelegate logic

extension RateController2: MapDelegate {
    func dissmissView() {}

    func hideCommentarySheet() {}

    func showCommentarySheet() {
        addChild(commentarySheetVC)
        view.addSubview(commentarySheetVC.view)
        commentarySheetVC.commentTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.RateOrder.CommentaryField.placeholder,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        commentarySheetVC.delegate = self
        commentarySheetVC.didMove(toParent: self)
        commentarySheetVC.modalPresentationStyle = .overCurrentContext

        let height: CGFloat = 185.0
        let width = view.frame.width

        getScreenSize(heightOfSheet: height, width: width)
    }

    private func getScreenSize(heightOfSheet: CGFloat, width: CGFloat) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height

        commentarySheetVC.view.frame = height <= 736 ? CGRect(x: 0, y: view.bounds.height - 49 - heightOfSheet, width: width, height: heightOfSheet) : CGRect(x: 0, y: view.bounds.height - 64 - heightOfSheet, width: width, height: heightOfSheet)
    }

    func passCommentary(text: String) {
        commentTextField.text = text
    }

    func reverseGeocoding(searchQuery _: String, title _: String) {
        print("rateController shoud have mapdelegate...")
    }

    func mapShadow(toggle: Bool) {
        if toggle {
            shadow.isHidden = false
        } else {
            shadow.isHidden = true
        }
    }
}
