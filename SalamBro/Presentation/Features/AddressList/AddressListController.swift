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

final class AddressListController: ViewController {
    let outputs = Output()

    private var locationRepository: LocationRepository
    private lazy var deliveryAddresses = locationRepository.getDeliveryAddresses()

    private lazy var citiesTableView: UITableView = {
        let tv = UITableView()
        tv.tableFooterView = UIView()
        tv.register(AddressListTableViewCell.self, forCellReuseIdentifier: AddressListTableViewCell.reuseIdentifier)
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
        return tv
    }()

    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.AddressPicker.titleMany
    }

    private func layoutUI() {
        view.backgroundColor = .white
        view.addSubview(citiesTableView)
        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func reload() {
        deliveryAddresses = locationRepository.getDeliveryAddresses()
        citiesTableView.reloadData()
    }

    deinit {
        outputs.didTerminate.accept(())
    }
}

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return deliveryAddresses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressListTableViewCell.reuseIdentifier, for: indexPath) as? AddressListTableViewCell else { fatalError() }
        addressCell.configure(address: deliveryAddresses?[indexPath.row].address?.name ?? "")
        return addressCell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let address = deliveryAddresses?[indexPath.row] else { return }
        outputs.didSelectAddress.accept((address, reload))
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }
}

extension AddressListController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let didSelectAddress = PublishRelay<(DeliveryAddress, () -> Void)>()
    }
}
