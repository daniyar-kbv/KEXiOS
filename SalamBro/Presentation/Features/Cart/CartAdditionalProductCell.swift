//
//  CartAdditionalProductCellTableViewCell.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import UIKit

protocol CellDelegate {
    func deleteProduct(id: Int, isAdditional: Bool)
    func changeItemCount(id: Int, isIncrease: Bool, isAdditional: Bool)
}

class CartAdditionalProductCell: UITableViewCell {
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var decreaseButton: UIButton!
    @IBOutlet var productCountLabel: UILabel!
    @IBOutlet var inscreaseButton: UIButton!
    @IBOutlet var availabilityLabel: UILabel!
    @IBOutlet var productLogo: UIImageView!

    var product: CartAdditionalProduct!
    var counter: Int = 0
    var delegate: CellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func bindData(item: CartAdditionalProduct) {
        product = item
        productTitle.text = product.name
        productPrice.text = "\(product.count * product.price) ₸"
        productCountLabel.text = "\(product.count)"
        counter = product.count

        if product!.available {
            availabilityLabel.text = ""
        } else {
            availabilityLabel.text = L10n.CartAdditionalProductCell.Availability.title
            productTitle.alpha = 0.5
            productPrice.alpha = 0.5
            productLogo.alpha = 0.5
        }
        counter = product!.count
        productCountLabel.text = "\(counter)"
    }

    @IBAction func decreaseItemCount(_: UIButton) {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product.id, isIncrease: false, isAdditional: true)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        } else {}
    }

    @IBAction func increaseItemButton(_: UIButton) {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product.id, isIncrease: true, isAdditional: true)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        }
    }
}
