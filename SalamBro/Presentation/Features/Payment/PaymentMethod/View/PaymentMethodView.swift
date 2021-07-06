//
//  PaymentMethodView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentMethodView: UIView {
    private let tableView = UITableView()

    private let viewModel: PaymentMethodViewModel

    init(viewModel: PaymentMethodViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentMethodView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.getCountOfPaymentMethods()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.text = viewModel.getPaymentMethod(for: indexPath).paymentType.title
        return cell
    }
}

extension PaymentMethodView {
    private func configure() {
        backgroundColor = .arcticWhite
        tableView.backgroundColor = .arcticWhite
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 50
        tableView.separatorColor = .mildBlue

        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
