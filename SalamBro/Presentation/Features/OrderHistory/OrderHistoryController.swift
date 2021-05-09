//
//  OrderHistoryController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit
import WebKit

protocol OrderHistoryDelegate {
    func share()
    func rate()
}

class OrderHistoryController: UIViewController {
    lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.OrderHistory.title)

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.register(OrderTestCell.self, forCellReuseIdentifier: "Cell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = 500
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        return view

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidesBottomBarWhenPushed = false
    }

    func setupViews() {
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.addSubview(tableView)
        view.addSubview(navbar)
    }

    func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.snp.bottomMargin)
        }
    }

    @objc func backButtonTapped(_: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OrderTestCell
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

extension OrderHistoryController: OrderHistoryDelegate {
    func share() {
        navigationController?.pushViewController(ShareOrderController(), animated: true)
    }

    func rate() {
        let vc = RateController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}
