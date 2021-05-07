//
//  CartView.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class CartView: UIView {
    public var delegate: CartViewDelegate?

    lazy var tableViewFooter: CartFooter = {
        let view = CartFooter()
        return view
    }()

    lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.Cart.title)

    lazy var itemsTableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = false
        table.register(UINib(nibName: "CartProductCell", bundle: nil), forCellReuseIdentifier: "CartProductCell")
        table.register(UINib(nibName: "CartAdditionalProductCell", bundle: nil), forCellReuseIdentifier: "CartAdditionalProductCell")
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
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

    init(delegate: UITableViewDelegate & UITableViewDataSource & CartViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        itemsTableView.dataSource = delegate
        itemsTableView.delegate = delegate
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTableViewFooterUI(cart: Cart) {
        tableViewFooter.productsLabel.text = L10n.CartFooter.productsCount(cart.totalProducts)
        tableViewFooter.productsPriceLabel.text = L10n.CartFooter.productsPrice(cart.totalPrice)
    }
}

extension CartView {
    fileprivate func setupViews() {
        backgroundColor = .white
        footerView.addSubview(divider)
        footerView.addSubview(orderButton)
        addSubview(itemsTableView)
        addSubview(footerView)
        addSubview(navbar)
        navbar.backButton.isHidden = true
        navbar.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func setupConstraints() {
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: footerView.widthAnchor).isActive = true

        navbar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        navbar.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        navbar.heightAnchor.constraint(equalToConstant: 44).isActive = true

        orderButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        orderButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 24).isActive = true
        orderButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -24).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        footerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        itemsTableView.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        itemsTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        itemsTableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        itemsTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
    }

    @objc func buttonAction() {
        delegate?.proceed()
    }
}
