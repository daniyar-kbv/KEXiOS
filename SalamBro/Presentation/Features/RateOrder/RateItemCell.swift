//
//  RatingItemCell.swift
//  rate-view
//
//  Created by Arystan on 4/21/21.
//

import UIKit

class RateItemCell: UICollectionViewCell {
    @IBOutlet var cellView: UIView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindData(text: String) {
        titleLabel.text = text
    }

    func toggleSelected() {
        if isSelected {
            cellView.backgroundColor = .kexRed
            titleLabel.textColor = .arcticWhite
        } else {
            cellView.backgroundColor = .arcticWhite
            titleLabel.textColor = .kexRed
        }
    }
}
