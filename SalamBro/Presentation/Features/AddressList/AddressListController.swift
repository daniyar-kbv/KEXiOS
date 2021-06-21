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

final class AddressListController: UIViewController {
    let outputs = Output()

    private var locationRepository: LocationRepository
    private lazy var deliveryAddresses = locationRepository.getDeliveryAddresses()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.title = L10n.AddressPicker.titleMany
    }

    func reload() {
        deliveryAddresses = locationRepository.getDeliveryAddresses()
        citiesTableView.reloadData()
    }

    deinit {
        outputs.didTerminate.accept(())
    }
}

extension AddressListController {
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
}

extension AddressListController {
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return deliveryAddresses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressListCell.reuseIdentifier, for: indexPath) as? AddressListCell else { fatalError() }
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
