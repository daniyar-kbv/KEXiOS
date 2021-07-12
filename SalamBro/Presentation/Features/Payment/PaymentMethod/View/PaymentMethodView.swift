//
//  PaymentMethodView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentMethodView: UIView {
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .arcticWhite
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        view.rowHeight = 50
        view.separatorColor = .mildBlue
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTableViewDelegate(_ delegate: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = delegate
    }
}

extension PaymentMethodView {
    private func configure() {
        backgroundColor = .arcticWhite

        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
