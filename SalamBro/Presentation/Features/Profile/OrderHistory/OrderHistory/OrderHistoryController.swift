//
//  OrderHistoryController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class OrderHistoryController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: OrderHistoryViewModel

    var onRateTapped: ((Int) -> Void)?
    var onShareTapped: ((String) -> Void)?
    var onTerminate: (() -> Void)?
    var toMenu: (() -> Void)?
    var finishFlow: (() -> Void)?

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.register(cellType: OrderTestCell.self)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.tableFooterView = UIView()
        view.delegate = self
        view.dataSource = self
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        view.refreshControl = refreshControl
        view.delaysContentTouches = false
        view.estimatedRowHeight = 400
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefreshControlAction), for: .valueChanged)
        return view
    }()

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
        bindViewModel()
        viewModel.update()
    }
}

extension OrderHistoryController {
    private func layoutUI() {
        navigationItem.title = SBLocalization.localized(key: ProfileText.OrderHistory.title)
        view.backgroundColor = .arcticWhite

        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            }).disposed(by: disposeBag)

        viewModel.outputs.didGetAuthError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error) {
                    self?.finishFlow?()
                }
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetOrders
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
                self?.configureAnimationView()
            }).disposed(by: disposeBag)
    }

    private func configureAnimationView() {
        guard viewModel.ordersEmpty() else {
            hideAnimationView(completionHandler: nil)
            return
        }

        showAnimationView(animationType: .orderHistory) { [weak self] in
            self?.toMenu?()
        }
    }

    @objc private func handleRefreshControlAction() {
        viewModel.update()
        refreshControl.endRefreshing()
    }
}

extension OrderHistoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: OrderTestCell.self)
        cell.delegate = self
        cell.configure(with: viewModel.orders[indexPath.row])
        return cell
    }

    func tableView(_: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadMoreDataIfNeeded(for: indexPath.row)
    }
}

extension OrderHistoryController: Reloadable {
    func reload() {
        viewModel.update()
    }
}

extension OrderHistoryController: OrderTestCellDelegate {
    func share(with url: String) {
        onShareTapped?(url)
    }

    func rate(at orderNumber: Int) {
        onRateTapped?(orderNumber)
    }

    func cancel() {
        showAlert(title: SBLocalization.localized(key: ProfileText.OrderHistory.Error.title),
                  message: SBLocalization.localized(key: ProfileText.OrderHistory.Error.message)) {
            guard let url = self.viewModel.getContact()?.getURL(),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
    }
}
