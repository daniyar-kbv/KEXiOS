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

    public func setSelectedUI() {
        cellView.backgroundColor = .kexRed
        titleLabel.textColor = .arcticWhite
    }

    public func setDeselectedUI() {
        cellView.backgroundColor = .arcticWhite
        titleLabel.textColor = .kexRed
    }
}
