//
//  OrderHistoryController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import SnapKit
import UIKit

final class OrderHistoryController: UIViewController {
    var onRateTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    var onTerminate: (() -> Void)?

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.register(cellType: OrderTestCell.self)
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

    private let viewModel: OrderHistoryViewModel

    init(viewModel: OrderHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        onTerminate?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
}

extension OrderHistoryController {
    private func layoutUI() {
        navigationItem.title = L10n.OrderHistory.title
        view.backgroundColor = .arcticWhite

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: OrderTestCell.self)
        cell.delegate = self
        return cell
    }
}

extension OrderHistoryController: OrderTestCellDelegate {
    func share() {
        onShareTapped?()
    }

    func rate() {
        onRateTapped?()
    }
}
