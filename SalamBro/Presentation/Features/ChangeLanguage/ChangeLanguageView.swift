//
//  ChangeLanguageView.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit

protocol ChangeLanguaeViewDelegate {
    func updateList()
}

class ChangeLanguageView: UIView {
    lazy var countriesTableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.separatorInset.right = table.separatorInset.left + table.separatorInset.left
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    public var delegate: ChangeLanguaeViewDelegate?
    
    init(delegate: (UITableViewDelegate & UITableViewDataSource & ChangeLanguaeViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.countriesTableView.dataSource = delegate
        self.countriesTableView.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        countriesTableView.reloadData()
    }
}

extension ChangeLanguageView {
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(countriesTableView)

    }

    fileprivate func setupConstraints() {
        countriesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        countriesTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        countriesTableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        countriesTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
