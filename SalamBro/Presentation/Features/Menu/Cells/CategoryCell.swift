//
//  CategoryCell.swift
//  SalamBro
//
//  Created by Arystan on 4/27/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            selectView.isHidden = isSelected ? false : true
            categoryLabel.textColor = isSelected ? .black : .mildBlue
        }
    }
    
    func bindData(text: String) {
        categoryLabel.text = text
    }
}
