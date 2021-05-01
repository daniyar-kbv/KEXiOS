//
//  MenuCell.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(item: Food) {
        itemTitleLabel.text = item.title
        itemDescriptionLabel.text = item.description
        itemPriceButton.setTitle("\(item.price) T", for: .normal)
    }
}
