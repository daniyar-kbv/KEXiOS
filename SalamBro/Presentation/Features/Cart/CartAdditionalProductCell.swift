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

    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var inscreaseButton: UIButton!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var productLogo: UIImageView!
    
    var product: CartAdditionalProduct!
    var counter: Int = 0
    var delegate: CellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(item: CartAdditionalProduct) {
        product = item
        productTitle.text = product.name
        productPrice.text = "\(product.count * product.price)"
        productCountLabel.text = "\(product.count)"
        counter = product.count
        
        if product!.available {
            deleteButton.isHidden = true
            availabilityLabel.text = ""
        } else {
            deleteButton.isHidden = false
            availabilityLabel.text = L10n.CartAdditionalProductCell.Availability.title
            productTitle.alpha = 0.5
            productPrice.alpha = 0.5
            productLogo.alpha = 0.5
        }
        counter = product!.count
        productCountLabel.text = "\(counter)"
    }
    
    func configureUI() {
        deleteButton.setTitle(L10n.CartAdditionalProductCell.DeleteButton.title, for: .normal)
    }
    
    @IBAction func decreaseItemCount(_ sender: UIButton) {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product.id, isIncrease: false, isAdditional: true)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        } else {
            deleteAction(sender)
        }
    }
    
    @IBAction func increaseItemButton(_ sender: UIButton) {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product.id, isIncrease: true, isAdditional: true)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate.deleteProduct(id: product.id, isAdditional: true)
    }
}
