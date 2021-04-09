//
//  CitiesListView.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

protocol CitiesListViewDelegate {
    func test()
}

class CitiesListView: UIView {
    public var delegate: CitiesListViewDelegate?
    
    lazy var citiesTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.separatorInset.right = table.separatorInset.left + table.separatorInset.left
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(delegate: (UITableViewDelegate & UITableViewDataSource & CitiesListViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.citiesTableView.dataSource = delegate
        self.citiesTableView.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        citiesTableView.reloadData()
    }
}

extension CitiesListView {
    func setupViews() {
        backgroundColor = .white
        addSubview(citiesTableView)
    }
    
    func setupConstraints() {
        citiesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        citiesTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        citiesTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        citiesTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
