//
//  CustomCell.swift
//  SalamBro
//
//  Created by Arystan on 3/19/21.
//

import UIKit

class CartProductCell: UITableViewCell {
    private var counter: Int = 0
    var item: CartDTO.Item?
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

        increaseCountButton.setImage(UIImage(named: "plus"), for: .normal)
        increaseCountButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        decreaseCountButton.setBackgroundImage(UIImage(named: "minus"), for: .normal)
        decreaseCountButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func bindData(with item: CartDTO.Item) {
        self.item = item
        productTitle.text = item.position.name
        productDescription.text = item.position.description
        productPrice.text = "\(item.position.price * Double(item.count)) ₸"
        productCommentary.text = item.comment

//        Tech debt: add availability
//        if item!.available {
        deleteButton.isHidden = true
        unavailableLabel.isHidden = true
//        } else {
//            deleteButton.isHidden = false
//            unavailableLabel.text = L10n.CartProductCell.Availability.title
//            itemTitle.alpha = 0.5
//            itemDescription.alpha = 0.5
        ////            itemPrice.alpha = 0.5
//            itemPrice.isHidden = true
//            itemLogo.alpha = 0.5
//        }
        counter = item.count
        productCountLabel.text = "\(counter)"
    }

    @IBAction func decreaseItemCount(_: UIButton) {
        counter -= 1
        productPrice.text = "\(Double(counter) * (item?.position.price ?? 0)) ₸"
        productCountLabel.text = "\(counter)"
        delegate.decrement(positionUUID: item?.positionUUID, isAdditional: false)
    }

    @IBAction func increaseItemButton(_: UIButton) {
        counter += 1
        productPrice.text = "\(Double(counter) * (item?.position.price ?? 0)) ₸"
        productCountLabel.text = "\(counter)"
        delegate.increment(positionUUID: item?.positionUUID, isAdditional: false)
    }

    @IBAction func deleteItem(_: UIButton) {
//        delegate.deleteProduct(id: item!.id, isAdditional: false)
    }
}
