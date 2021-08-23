//
//  AddressListController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AddressListController: UIViewController, Reloadable {
    let outputs = Output()

    private let viewModel: AddressListViewModel
    private let disposeBag = DisposeBag()

    private lazy var citiesTableView: UITableView = {
        let tv = UITableView()
        tv.tableFooterView = UIView()
        tv.register(AddressListCell.self, forCellReuseIdentifier: AddressListCell.reuseIdentifier)
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = .mildBlue
        tv.delegate = self
        tv.dataSource = self
        tv.allowsMultipleSelection = false
        tv.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tv.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 24, right: 0)
        tv.separatorInsetReference = .fromCellEdges
        tv.separatorStyle = .singleLine
        tv.refreshControl = refreshControll
        return tv
    }()

    private lazy var refreshControll: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(reload), for: .valueChanged)
        return view
    }()

    init(viewModel: AddressListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        bindViewModel()
        reload()
    }

    private func bindViewModel() {
        viewModel.outputs.reload
            .bind(to: citiesTableView.rx.reload)
            .disposed(by: disposeBag)
    }

    @objc func reload() {
        refreshControll.endRefreshing()
        viewModel.getAddresses()
    }

    deinit {
        outputs.didTerminate.accept(())
    }
}

extension AddressListController {
    private func layoutUI() {
        navigationItem.title = SBLocalization.localized(key: ProfileText.AddressList.title)
        view.backgroundColor = .arcticWhite

        view.addSubview(citiesTableView)

        citiesTableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
}

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.userAddreses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressListCell.reuseIdentifier, for: indexPath) as? AddressListCell else { fatalError() }
        addressCell.configure(address: viewModel.userAddreses[indexPath.row].address.getName() ?? "")
        return addressCell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        outputs.didSelectAddress.accept(viewModel.userAddreses[indexPath.row])
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .calmGray
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = .arcticWhite
    }
}

extension AddressListController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let didSelectAddress = PublishRelay<UserAddress>()
    }
}
