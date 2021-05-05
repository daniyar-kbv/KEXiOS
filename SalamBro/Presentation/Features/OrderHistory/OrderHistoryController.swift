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
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .systemRed
        button.setImage(UIImage(named: "back"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "История заказов"
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(OrderTestCell.self, forCellReuseIdentifier: "Cell")
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = 500
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return view

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.backgroundColor = .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
    }

    func setupConstraints() {
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true

        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)

            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-32)
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
        navigationController?.pushViewController(RateController(), animated: true)
    }
}
