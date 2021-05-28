//
//  AddressListController.swift
//  SalamBro
//
//  Created by Arystan on 5/7/21.
//

import SnapKit
import UIKit

class AddressListController: ViewController {
    var addresses = ["Алматы, мкр. Орбита 1, 41", "проспект Абылай Хана, 131"]

    lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorColor = .mildBlue
        view.delegate = self
        view.dataSource = self
        view.allowsMultipleSelection = false
        view.addTableHeaderViewLine()
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.AddressPicker.titleMany
    }

    func setupViews() {
        view.backgroundColor = .white
        [citiesTableView].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(24)
            $0.left.right.bottom.equalToSuperview()
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

        let cellChevronButton = UIButton(type: .custom)
        cellChevronButton.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
        cellChevronButton.isUserInteractionEnabled = false
        cellChevronButton.setImage(UIImage(named: "chevron.right"), for: .normal)
        cellChevronButton.tintColor = .mildBlue
        cellChevronButton.contentMode = .scaleAspectFit
        cell.accessoryView = cellChevronButton

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
