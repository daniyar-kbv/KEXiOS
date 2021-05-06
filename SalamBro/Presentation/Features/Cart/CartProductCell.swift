//
//  CustomCell.swift
//  SalamBro
//
//  Created by Arystan on 3/19/21.
//

import UIKit

class CartProductCell: UITableViewCell {
    private var counter: Int = 0
    lazy var product: CartProduct? = nil
    var delegate: CellDelegate!

    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDescription: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productLogo: UIImageView!
    @IBOutlet var productCommentary: UILabel!

    @IBOutlet var productCountLabel: UILabel!
    @IBOutlet var increaseCountButton: UIButton!
    @IBOutlet var decreaseCountButton: UIButton!

    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var unavailableLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureUI() {
        deleteButton.setTitle(L10n.CartProductCell.DeleteButton.title, for: .normal)
    }

    func bindData(with item: CartProduct) {
        product = item
        productTitle.text = product!.name
        productDescription.text = product!.description
        productPrice.text = "\(product!.price * product!.count) ₸"
        productCommentary.text = product!.commentary

        if product!.available {
            deleteButton.isHidden = true
            unavailableLabel.text = ""
        } else {
            deleteButton.isHidden = false
            unavailableLabel.text = L10n.CartProductCell.Availability.title
            productTitle.alpha = 0.5
            productDescription.alpha = 0.5
            productPrice.alpha = 0.5
            productLogo.alpha = 0.5
        }
        counter = product!.count
        productCountLabel.text = "\(counter)"
    }

    @IBAction func decreaseItemCount(_: UIButton) {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product!.id, isIncrease: false, isAdditional: false)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        } else {
            delegate.deleteProduct(id: product!.id, isAdditional: false)
        }
    }

    @IBAction func increaseItemButton(_: UIButton) {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product!.id, isIncrease: true, isAdditional: false)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        }
    }

    @IBAction func deleteItem(_: UIButton) {
        delegate.deleteProduct(id: product!.id, isAdditional: false)
    }
}
