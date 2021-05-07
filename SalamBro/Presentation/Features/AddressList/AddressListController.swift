//
//  AddressListController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import SnapKit
import UIKit

class AddressListController: UIViewController {
    private lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.AddressPicker.title)

    var addresses = ["Алматы, мкр. Орбита 1, 41", "проспект Абылай Хана, 131"]

    lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = false
        view.delegate = self
        view.dataSource = self
        view.allowsMultipleSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    private lazy var separator = SeparatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    func setupViews() {
        view.backgroundColor = .white
        [navbar, separator, citiesTableView].forEach { view.addSubview($0) }
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navbar.titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
    }

    func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(citiesTableView.snp.top)
            $0.height.equalTo(0.30)
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AddressListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = addresses[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .white
//        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: UIImage(named: "chevron.right"))
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = AddressDetailController()
        vc.addressLabel.text = addresses[indexPath.row]
        vc.commentaryLabel.text = "Квартира, подъезд, домофон, этаж, и очень длинный комментарий примерно в две"
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//        let vc = AddressDetailController()
//        vc.addressLabel.text = addresses[indexPath.row]
//        vc.commentaryLabel.text = "Квартира, подъезд, домофон, этаж, и очень длинный комментарий примерно в две"
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return addresses.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = addresses[indexPath.row]
//        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
//        cell.textLabel?.textColor = .darkGray
//        cell.backgroundColor = .white
    ////        cell.accessoryType = .disclosureIndicator
//        cell.accessoryView = UIImageView(image: UIImage(named: "chevron.right"))
//        cell.selectionStyle = .none
//        return cell
//    }
}
