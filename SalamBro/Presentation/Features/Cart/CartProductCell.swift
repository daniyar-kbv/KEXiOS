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
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productLogo: UIImageView!
    @IBOutlet weak var productCommentary: UILabel!
    
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var increaseCountButton: UIButton!
    @IBOutlet weak var decreaseCountButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var unavailableLabel: UILabel!
    

    
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
        productPrice.text = "\(product!.price * product!.count) T"
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
    
    @IBAction func decreaseItemCount(_ sender: UIButton) {
        if counter > 0 {
            counter -= 1
            delegate.changeItemCount(id: product!.id, isIncrease: false, isAdditional: false)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        } else {
            delegate.deleteProduct(id: product!.id, isAdditional: false)
        }
    }
    
    @IBAction func increaseItemButton(_ sender: UIButton) {
        if counter < 999 {
            counter += 1
            delegate.changeItemCount(id: product!.id, isIncrease: true, isAdditional: false)
            productPrice.text = "\(counter * product!.price) T"
            productCountLabel.text = "\(counter)"
        }
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
        delegate.deleteProduct(id: product!.id, isAdditional: false)
    }
}
