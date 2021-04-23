//
//  RateController.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import UIKit
import Cosmos

class RateController: UIViewController {

    var data: [String] = []
    
    var arrayStar13: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.CourierNotFoundClient.text, L10n.RateOrder.Cell.FoodIsMissing.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar4: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text, L10n.RateOrder.Cell.FoodIsCold.text]
    var arrayStar5: [String] = [L10n.RateOrder.Cell.CourierWork.text, L10n.RateOrder.Cell.GivenTime.text, L10n.RateOrder.Cell.DeliveryTime.text]
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var subtitleFirstLabel: UILabel!
    @IBOutlet weak var subtitleSecondLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var commentaryField: UITextField!
    @IBOutlet weak var commentaryView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        
        
    }
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func setupViews() {
        button.setTitle(L10n.RateOrder.SubmitButton.title, for: .normal)
        commentaryField.placeholder = L10n.RateOrder.CommentaryField.placeholder
        
        ratingView.didFinishTouchingCosmos = didFinishTouchRating
        
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "RatingItemCell", bundle: nil), forCellWithReuseIdentifier: "RatingItemCell")
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
        
        infoStack.isHidden = false
        switch rating {
        case 1.0..<2.0:
            subtitleFirstLabel.text = L10n.RateOrder.BadRate.title
            subtitleSecondLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 2.0..<3.0:
            subtitleFirstLabel.text = L10n.RateOrder.BadRate.title
            subtitleSecondLabel.text = L10n.RateOrder.BadRate.subtitle
            data = arrayStar13
        case 3.0..<4.0:
            subtitleFirstLabel.text = L10n.RateOrder.AverageRate.title
            subtitleSecondLabel.text = L10n.RateOrder.AverageRate.title
            data = arrayStar13
        case 4.0..<5.0:
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
}

extension RateController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RatingItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingItemCell", for: indexPath) as! RatingItemCell
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RatingItemCell
        cell.toggleSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RatingItemCell
        cell.toggleSelected()
    }
}

