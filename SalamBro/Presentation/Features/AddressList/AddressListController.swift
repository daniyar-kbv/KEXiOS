//
//  AddressListController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import SnapKit
import UIKit

final class AddressListController: ViewController {
    var coordinator: AddressListCoordinator
    private var addresses = ["Алматы, мкр. Орбита 1, 41", "проспект Абылай Хана, 131"]

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
        tv.separatorInsetReference = .fromCellEdges
        tv.separatorStyle = .singleLine
        return tv
    }()
    
    init(coordinator: AddressListCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        coordinator.didFinish()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.AddressPicker.titleMany
    }

    private func layoutUI() {
        view.backgroundColor = .white
        view.addSubview(citiesTableView)
        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressListTableViewCell.reuseIdentifier, for: indexPath) as? AddressListTableViewCell else { fatalError() }
        addressCell.configure(address: addresses[indexPath.row])
        return addressCell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        coordinator.openDetail(address: addresses[indexPath.row])
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }
}
