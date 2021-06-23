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

// FIXME: Refactor
class CartController: ViewController {
    var openAuth: (() -> Void)?

    var mainTabDelegate: MainTabDelegate?

    private var commentaryPage: MapCommentaryPage?

    // private lazy var emptyCartView = AnimationContainerView(delegate: self, animationType: .emptyBasket)

    lazy var tableViewFooter: CartFooter = {
        let view = CartFooter()
        view.delegate = self
        return view
    }()

    lazy var itemsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.separatorColor = .mildBlue
        table.register(cellType: CartProductCell.self)
        table.register(cellType: CartAdditionalProductCell.self)
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        table.dataSource = self
        table.delegate = self
        // hidden header fix, usually default headers of section in tableview is sticky
        let dummyViewHeight = CGFloat(56)
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: table.bounds.size.width, height: dummyViewHeight))
        table.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        tableViewFooter.frame = CGRect(x: 0, y: 0, width: table.frame.width, height: 160)
        table.tableFooterView = tableViewFooter
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var shadow: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.opacity = 0.7
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let cartViewModel: CartViewModel
    init(viewModel: CartViewModel) {
        cartViewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

        itemsTableView.reloadData()
        updateTableViewFooterUI(cart: cartViewModel.cart)
        orderButton.setTitle(L10n.Cart.OrderButton.title(cartViewModel.cart.totalPrice), for: .normal)
        mainTabDelegate?.setCount(count: cartViewModel.cart.totalProducts)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Cart.title
    }
}

extension CartController {
    fileprivate func setupViews() {
        view.backgroundColor = .white
        footerView.addSubview(divider)
        footerView.addSubview(orderButton)
        view.addSubview(itemsTableView)
        view.addSubview(footerView)
        view.addSubview(shadow)
    }

    fileprivate func setupConstraints() {
        shadow.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        shadow.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        shadow.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        shadow.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true

        orderButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        orderButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 24).isActive = true
        orderButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -24).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        footerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        itemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        itemsTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        itemsTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        itemsTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
    }

    func updateTableViewFooterUI(cart: Cart) {
        tableViewFooter.productsLabel.text = L10n.CartFooter.productsCount(cart.totalProducts)
        tableViewFooter.productsPriceLabel.text = L10n.CartFooter.productsPrice(cart.totalPrice)
    }

    @objc func buttonAction() {
        openAuth?()
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
            let separator = UIView(frame: CGRect(x: 24, y: 0, width: tableView.frame.width - 48, height: 0.5))
            separator.backgroundColor = .mildBlue
            label.font = .boldSystemFont(ofSize: 16)
            label.text = L10n.Cart.Section1.title
            view.addSubview(label)
            view.addSubview(separator)
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
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CartProductCell.self)
            cell.delegate = self
            cell.configure(with: cartViewModel.cart.products[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CartAdditionalProductCell.self)
            cell.delegate = self
            cell.configure(item: cartViewModel.cart.productsAdditional[indexPath.row])
            cell.configureIncreaseButton()
            return cell
        }
    }
}

// MARK: - Cell Actions

extension CartController: CartAdditinalProductCellDelegate {
    func deleteProduct(id: Int, isAdditional: Bool) {
        if !isAdditional {
            if let index = cartViewModel.cart.products.firstIndex(where: { $0.id == id }) {
                cartViewModel.cart.products.remove(at: index)
                let path = IndexPath(row: index, section: 0)
                itemsTableView.deleteRows(at: [path], with: .automatic)
            }
        }
        updateTableViewFooterUI(cart: cartViewModel.cart)
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
                itemsTableView.reloadData()
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
                itemsTableView.reloadData()
            }
        }
        if cartViewModel.cart.totalProducts <= 0 {
            // view = emptyCartView
        }
        updateTableViewFooterUI(cart: cartViewModel.cart)
        orderButton.setTitle(L10n.Cart.OrderButton.title(cartViewModel.cart.totalPrice), for: .normal)
        mainTabDelegate?.updateCounter(isIncrease: isIncrease)
    }
}

// extension CartController: AnimationContainerViewDelegate {
//    func performAction() {}
// }

extension CartController: CartFooterDelegate {
    func openPromocode() {
        commentaryPage = MapCommentaryPage()
        guard let page = commentaryPage else { return }
        page.delegate = self
        page.configureTextField(placeholder: L10n.Promocode.field)
        page.configureButton(title: L10n.Promocode.button)
        present(page, animated: true, completion: nil)
    }
}

extension CartController: MapCommentaryPageDelegate {
    func onDoneButtonTapped(commentary _: String) {}
}
