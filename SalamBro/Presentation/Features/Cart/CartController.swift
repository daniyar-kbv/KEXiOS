//
//  CartController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

protocol CartViewDelegate {
    func proceed()
}

class CartController: UIViewController {
    var mainTabDelegate: MainTabDelegate?
    var cartViewModel = CartViewModel(cartRepository: CartRepositoryMockImpl())

    lazy var rootView = CartView(delegate: self)
    lazy var emptyCartView = AdditionalView(delegate: self, descriptionTitle: L10n.Cart.EmptyCart.description, buttonTitle: L10n.Cart.EmptyCart.Button.title, image: UIImage(named: "emptyCart")!)

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        cartViewModel = CartViewModel(cartRepository: CartRepositoryMockImpl())

        configUI()
        rootView.itemsTableView.reloadData()
        rootView.updateTableViewFooterUI(cart: cartViewModel.cart)
        rootView.orderButton.setTitle(L10n.Cart.OrderButton.title(cartViewModel.cart.totalPrice) + " ₸", for: .normal)
        mainTabDelegate?.setCount(count: cartViewModel.cart.totalProducts)
    }
}

extension CartController {
    private func configUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - UITableView

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let content = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 24))
            label.font = .boldSystemFont(ofSize: 18)
            label.text = L10n.Cart.Section0.title(cartViewModel.cart.totalProducts, cartViewModel.cart.totalPrice)
            content.addSubview(label)
            content.backgroundColor = .arcticWhite
            return content
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 21))
            label.font = .boldSystemFont(ofSize: 16)
            label.text = L10n.Cart.Section1.title
            view.addSubview(label)
            view.backgroundColor = .arcticWhite
            return view
        }
    }

    func numberOfSections(in _: UITableView) -> Int {
        2
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cartViewModel.cart.products.count
        } else {
            return cartViewModel.cart.productsAdditional.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductCell", for: indexPath) as! CartProductCell
            cell.delegate = self
            cell.bindData(with: cartViewModel.cart.products[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartAdditionalProductCell", for: indexPath) as! CartAdditionalProductCell
            cell.delegate = self
            cell.bindData(item: cartViewModel.cart.productsAdditional[indexPath.row])
            return cell
        }
    }
}

// MARK: - Cell Actions

extension CartController: CellDelegate {
    func deleteProduct(id: Int, isAdditional: Bool) {
        if isAdditional {
            if let index = cartViewModel.cart.productsAdditional.firstIndex(where: { $0.id == id }) {
                cartViewModel.cart.productsAdditional.remove(at: index)
                let path = IndexPath(row: index, section: 1)
                rootView.itemsTableView.deleteRows(at: [path], with: .automatic)
            }
        } else {
            if let index = cartViewModel.cart.products.firstIndex(where: { $0.id == id }) {
                cartViewModel.cart.products.remove(at: index)
                let path = IndexPath(row: index, section: 0)
                rootView.itemsTableView.deleteRows(at: [path], with: .automatic)
            }
        }
        rootView.updateTableViewFooterUI(cart: cartViewModel.cart)
    }

    func changeItemCount(id: Int, isIncrease: Bool, isAdditional: Bool) {
        if isAdditional {
            if let index = cartViewModel.cart
                .productsAdditional.firstIndex(where: { $0.id == id })
            {
                let price = cartViewModel.cart.productsAdditional[index].price
                if isIncrease {
                    cartViewModel.cart.productsAdditional[index].count += 1
                    cartViewModel.cart.totalPrice += price
                    cartViewModel.cart.totalProducts += 1
                } else {
                    cartViewModel.cart.productsAdditional[index].count -= 1
                    cartViewModel.cart.totalPrice -= price
                    cartViewModel.cart.totalProducts -= 1
                }
                rootView.itemsTableView.reloadData()
            }
        } else {
            if let index = cartViewModel.cart.products.firstIndex(where: { $0.id == id }) {
                let price = cartViewModel.cart.products[index].price
                if isIncrease {
                    cartViewModel.cart.products[index].count += 1
                    cartViewModel.cart.totalPrice += price
                    cartViewModel.cart.totalProducts += 1
                } else {
                    cartViewModel.cart.products[index].count -= 1
                    cartViewModel.cart.totalPrice -= price
                    cartViewModel.cart.totalProducts -= 1
                }
                rootView.itemsTableView.reloadData()
            }
        }
        if cartViewModel.cart.totalProducts <= 0 {
            view = emptyCartView
        }
        rootView.updateTableViewFooterUI(cart: cartViewModel.cart)
        rootView.orderButton.setTitle(L10n.Cart.OrderButton.title(cartViewModel.cart.totalPrice), for: .normal)
        mainTabDelegate?.updateCounter(isIncrease: isIncrease)
    }
}

extension CartController: CartViewDelegate {
    func proceed() {
        navigationController?.pushViewController(AuthorizationController(), animated: true)
    }
}

extension CartController: AdditionalViewDelegate {
    func action() {
        mainTabDelegate?.changeController(id: 0)
    }
}
