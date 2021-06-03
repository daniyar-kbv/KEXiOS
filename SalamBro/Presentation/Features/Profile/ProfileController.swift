//
//  ProfileController.swift
//  SalamBro
//
//  Created by Arystan on 3/18/21.
//

import UIKit

class ProfileController: ViewController {
    var coordinator: ProfileCoordinator
    
    lazy var phoneTitle: UILabel = {
        let label = UILabel()
        label.text = "+7 (702) 000 00 00"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .mildBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = DefaultStorageImpl.sharedStorage.userName
        label.font = .systemFont(ofSize: 32, weight: .semibold)
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
        label.titleLabel?.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeName))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .mildBlue
        table.addTableHeaderViewLine()
        table.tableFooterView = UIView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        return table
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Profile.LogoutButton.title, for: .normal)
        button.setTitleColor(.mildBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        button.borderWidth = 1
        button.borderColor = .mildBlue
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Profile.NavigationBar.title
    }
}

extension ProfileController {
    func setupViews() {
        view.backgroundColor = .arcticWhite
        [phoneTitle, nameLabel, changeNameLabel, tableView, logoutButton, emailLabel].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        phoneTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26).isActive = true
        phoneTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        phoneTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        nameLabel.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true

        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true

        changeNameLabel.lastBaselineAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor).isActive = true
        changeNameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

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
        coordinator.openChangeName()
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
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
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
            coordinator.openOrderHistory()
        } else if indexPath.row == 1 {
            coordinator.openChangeLanguage()
        } else {
            coordinator.openAddressList()
        }
    }
}
