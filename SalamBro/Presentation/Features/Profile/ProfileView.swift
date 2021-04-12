//
//  ProfileView.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit

protocol ProfileViewDelegate {
    func changeName()
    func logout()
}

class ProfileView: UIView {
    
    public var delegate: ProfileViewDelegate?
    
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
        // Top separator
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: table.frame.size.width, height: px)
        let line = UIView(frame: frame)
        table.tableHeaderView = line
        line.backgroundColor = table.separatorColor
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
    
    init(delegate: (UITableViewDelegate & UITableViewDataSource & ProfileViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        tableView.delegate = delegate
        tableView.dataSource = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ProfileView {
    func setupViews() {
        backgroundColor = .arcticWhite
        
        addSubview(phoneTitle)
        addSubview(nameLabel)
        addSubview(changeNameLabel)
        addSubview(tableView)
        addSubview(logoutButton)
    }
    
    func setupConstraints() {
        phoneTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        phoneTitle.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        phoneTitle.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: phoneTitle.bottomAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        
        changeNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        changeNameLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 22).isActive = true
        tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -8).isActive = true
        
        logoutButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 54).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -54).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
    }
    
    @objc func logout() {
        delegate?.logout()
    }

    @objc
    func changeName(sender:UITapGestureRecognizer) {
//        delegate?.changeName()
    }
}

