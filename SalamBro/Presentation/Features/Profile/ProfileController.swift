//
//  ProfileController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class ProfileController: UIViewController {
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Profile.NavigationBar.title
        view.font = .systemFont(ofSize: 18, weight: .semibold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var phoneTitle: UILabel = {
        let label = UILabel()
        label.text = "+7 (702) 000 00 00"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .mildBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Alibek"
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "alibek_777@gmail.com"
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var changeNameLabel: UIButton = {
        let label = UIButton()
        label.setTitle(L10n.Profile.EditButton.title, for: .normal)
        label.setTitleColor(.kexRed, for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeName))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.bounces = false
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return table
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.LogoutButton.title, for: .normal)
        button.setTitleColor(.mildBlue, for: .normal)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var separator = SeparatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

extension ProfileController {
    func setupViews() {
        view.backgroundColor = .arcticWhite
        [titleLabel, phoneTitle, nameLabel, changeNameLabel, tableView, logoutButton, emailLabel, separator].forEach { view.addSubview($0) }
        separator.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        phoneTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 26).isActive = true
        phoneTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        phoneTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        nameLabel.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true

        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true

        changeNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        changeNameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        separator.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        separator.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.3).isActive = true

        tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 19).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -8).isActive = true

        logoutButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
    }

    @objc func logout() {
        print("logout action")
    }

    @objc func changeName(sender _: UITapGestureRecognizer) {
        navigationController?.pushViewController(ChangeNameController(), animated: true)
    }
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        3
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = profileItems[indexPath.row]
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "history")
        case 1:
            cell.imageView?.image = UIImage(named: "language")
        case 2:
            cell.imageView?.image = UIImage(named: "address")
        default:
            break
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = OrderHistoryController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            navigationController?.pushViewController(ChangeLanguageController(), animated: true)
        }
    }
}
