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

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var infoStack: UIStackView!
    @IBOutlet var subtitleFirstLabel: UILabel!
    @IBOutlet var subtitleSecondLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var commentaryField: UITextField!
    @IBOutlet var commentaryView: UIView!
    @IBOutlet var button: UIButton!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    private func setupViews() {
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

        // future commentary functional
//        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(didTapCommentaryView))
//        commentaryView.addGestureRecognizer(tapCommentary)
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
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RateItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateItemCell", for: indexPath) as! RateItemCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        cell.toggleSelected()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RateItemCell
        cell.toggleSelected()
    }
}
