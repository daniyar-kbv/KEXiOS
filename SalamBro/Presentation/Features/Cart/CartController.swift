//
//  CartController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class CartController: UIViewController {
    fileprivate lazy var rootView = CartView(delegate: self)
    
    var cart: Cart!
    var apiService = APIService()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cart = apiService.getCart()
        configUI()
        rootView.itemsTableView.reloadData()
    }
    
}

//MARK: - UITableView
extension CartController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let content = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 24))
            label.font = .boldSystemFont(ofSize: 18)
            label.text = "\(cart!.totalProducts) items for \(cart!.totalPrice)"
            content.addSubview(label)
            content.backgroundColor = .arcticWhite
            return content
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 56))
            let label = UILabel(frame: CGRect(x: 16, y: 24, width: tableView.frame.size.width, height: 21))
            label.font = .boldSystemFont(ofSize: 16)
            label.text = "Additional products"
            view.addSubview(label)
            view.backgroundColor = .arcticWhite
            return view
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cart!.products.count
        } else {
            return cart!.productsAdditional.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartProductCell", for: indexPath) as! CartProductCell
            cell.delegate = self
            cell.bindData(with: cart!.products[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartAdditionalProductCell", for: indexPath) as! CartAdditionalProductCell
            cell.delegate = self
            cell.bindData(item: cart!.productsAdditional[indexPath.row])
            return cell
        }
    }
    
}

extension CartController: CellDelegate {
    func deleteProduct(id: Int, isAdditional: Bool) {
        if isAdditional {
            if let index = cart?.productsAdditional.firstIndex(where: {$0.id == id})   {
                cart?.productsAdditional.remove(at: index)
                let path = IndexPath(row: index, section: 1)
                rootView.itemsTableView.deleteRows(at: [path], with: .automatic)
                rootView.itemsTableView.reloadData()
//                itemsInCart.remove(at: index)
//                let indexPath = IndexPath(row: index, section: 0)
//                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else {
            if let index = cart?.products.firstIndex(where: {$0.id == id})   {
                cart?.productsAdditional.remove(at: index)
                let path = IndexPath(row: index, section: 0)
                rootView.itemsTableView.deleteRows(at: [path], with: .automatic)
                rootView.itemsTableView.reloadData()
            }
        }
    }
    
    func changeItemCount(id: Int, isIncrease: Bool, isAdditional: Bool) {
        print("")
//        if isAdditional {
//            DispatchQueue.main.async {
//                if let index = self.cart.productsAdditional.firstIndex(where: {$0.id == id})   {
//                if isIncrease {
//                    self.cart.productsAdditional[index].count += 1
//                    self.cart?.totalPrice += self.cart!.productsAdditional[index].price
//                    self.cart?.totalProducts += 1
//                } else {
//                    self.cart?.productsAdditional[index].count -= 1
//                    self.cart?.totalPrice -= self.cart!.productsAdditional[index].price
//                    self.cart?.totalProducts -= 1
//                }
//                    self.rootView.itemsTableView.reloadData()
//                    self.rootView.itemsTableView.layoutIfNeeded()
//                    print(self.cart?.totalPrice)
//                    print(self.cart?.totalProducts)
////                let indexPath = IndexPath(row: index, section: 0)
////                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        } else {
//            if let index = self.cart?.products.firstIndex(where: {$0.id == id})   {
//                if isIncrease {
//                    self.cart?.products[index].count += 1
//                    self.cart?.totalPrice += self.cart!.products[index].price
//                    self.cart?.totalProducts += 1
//                } else {
//                    self.cart?.products[index].count -= 1
//                    self.cart?.totalPrice -= self.cart!.products[index].price
//                    self.cart?.totalProducts -= 1
//                }
//                print(self.cart?.totalPrice)
//                print(self.cart?.totalProducts)
//                self.rootView.itemsTableView.reloadData()
//                self.rootView.itemsTableView.layoutIfNeeded()
//            }
//        }
//        }
    }
}

extension CartController: CartViewDelegate {
    func updateList() {
        print("update list...")
    }
}

extension CartController {
    private func configUI() {
        navigationItem.title = L10n.CountriesList.Navigation.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
