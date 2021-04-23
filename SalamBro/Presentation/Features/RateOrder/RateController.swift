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
    
    var arrayStar13: [String] = ["Работа курьера", "Предлагаемое время", "Курьер не нашел меня", "Отсутствует блюдо", "Еда была холодной"]
    var arrayStar4: [String] = ["Работа курьера", "Предлагаемое время", "Время доставки", "Еда была холодной"]
    var arrayStar5: [String] = ["Работа курьера", "Предлагаемое время", "Время доставки"]
    
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
        
        ratingView.didFinishTouchingCosmos = didFinishTouchRating
        
        let layout = UICollectionViewCenterLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        
//        let tapCommentary = UITapGestureRecognizer(target: self, action: #selector(didTapCommentaryView))
//        commentaryView.addGestureRecognizer(tapCommentary)
        

        
        
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "RatingItemCell", bundle: nil), forCellWithReuseIdentifier: "RatingItemCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews()
        collectionViewHeightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    private func didFinishTouchRating(_ rating: Double) {
        button.isEnabled = true
        button.backgroundColor = .kexRed
        
        infoStack.isHidden = false
        switch rating {
        case 1.0..<2.0:
            subtitleFirstLabel.text = "star 1.0 text"
            subtitleSecondLabel.text = "star 2.0 description"
            data = arrayStar13
        case 2.0..<3.0:
            subtitleFirstLabel.text = "star 2.0 text"
            subtitleSecondLabel.text = "star 2.0 description"
            data = arrayStar13
        case 3.0..<4.0:
            subtitleFirstLabel.text = "star 3.0 text"
            subtitleSecondLabel.text = "star 3.0 description"
            data = arrayStar13
        case 4.0..<5.0:
            subtitleFirstLabel.text = "star 4.0 text"
            subtitleSecondLabel.text = "star 4.0 description"
            data = arrayStar4
        case 5.0:
            subtitleFirstLabel.text = "star 5.0 text star 5.0 textstar 5.0 textstar 5.0 textstar 5.0 textstar 5.0 textstar 5.0 textstar 5.0 textstar 5.0 text"
            subtitleSecondLabel.text = "star 5.0 description star 5.0 descriptionstar 5.0 description star 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 descriptionstar 5.0 description"
            data = arrayStar5
        default:
            subtitleFirstLabel.text = "mismatch"
            subtitleSecondLabel.text = "mismatch"
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

