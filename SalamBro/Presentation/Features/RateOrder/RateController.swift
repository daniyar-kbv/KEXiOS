//
//  RateController.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import Cosmos
import UIKit

class RateController: ViewController {
    var data: [String] = []

    var arrayStar13: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.CourierNotFoundClient.text, L10n.RateOrder.Cell.FoodIsMissing.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar4: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar5: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text]

    // MARK: Tech Debt - Create in a viewModel

    var selectedItems: [String] = []

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var subtitleFirstLabel: UILabel!
    @IBOutlet var subtitleSecondLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var commentaryField: UITextField!
    @IBOutlet var commentaryView: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView!

    lazy var commentarySheetVC = CommentarySheetController()

    lazy var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    private func setupViews() {
        view.addSubview(shadow)
        titleLabel.text = L10n.RateOrder.title
        subtitleSecondLabel.text = L10n.RateOrder.description
        button.setTitle(L10n.RateOrder.SubmitButton.title, for: .normal)
        commentaryField.attributedPlaceholder = NSAttributedString(
            string: L10n.RateOrder.CommentaryField.placeholder,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        ratingView.didFinishTouchingCosmos = didFinishTouchRating

        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "RateItemCell", bundle: nil), forCellWithReuseIdentifier: "RateItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true

        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(commentaryViewTapped))
        commentaryView.addGestureRecognizer(tapCommentary)

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom - 230, right: 0)
    }

    func setupConstraints() {
        shadow.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }

    private func didFinishTouchRating(_ rating: Double) {
        button.isEnabled = true
        button.backgroundColor = .kexRed
        switch rating {
        case 1.0 ..< 2.0:
            subtitleFirstLabel.text = L10n.RateOrder.BadRate.title
            subtitleSecondLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 2.0 ..< 3.0:
            subtitleFirstLabel.text = L10n.RateOrder.BadRate.title
            subtitleSecondLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 3.0 ..< 4.0:
            subtitleFirstLabel.text = L10n.RateOrder.AverageRate.title
            subtitleSecondLabel.text = L10n.RateOrder.AverageRate.title
            data = arrayStar13
        case 4.0 ..< 5.0:
            subtitleFirstLabel.text = L10n.RateOrder.GoodRate.title
            subtitleSecondLabel.text = L10n.RateOrder.GoodRate.subtitle
            data = arrayStar4
        case 5.0:
            subtitleFirstLabel.text = L10n.RateOrder.ExcellentRate.title
            subtitleSecondLabel.text = L10n.RateOrder.ExcellentRate.subtitle
            data = arrayStar5
        default:
            subtitleFirstLabel.text = nil
            subtitleSecondLabel.text = nil
        }
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }

    @IBAction func backButtonTapped(_: UIButton) {
        dismiss(animated: true)
    }

    @objc func commentaryViewTapped() {
        showCommentarySheet()
    }
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateItemCell", for: indexPath) as! RateItemCell
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

extension RateController: MapDelegate {
    func dissmissView() {}

    func hideCommentarySheet() {}

    func showCommentarySheet() {
        addChild(commentarySheetVC)
        view.addSubview(commentarySheetVC.view)
        commentarySheetVC.commentaryField.attributedPlaceholder = NSAttributedString(
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

        commentarySheetVC.isCommentary = true
        commentarySheetVC.view.frame = height <= 736 ? CGRect(x: 0, y: view.bounds.height - 49 - heightOfSheet, width: width, height: heightOfSheet) : CGRect(x: 0, y: view.bounds.height - 64 - heightOfSheet, width: width, height: heightOfSheet)
    }

    func passCommentary(text: String) {
        commentaryField.text = text
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
