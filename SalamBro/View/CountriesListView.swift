//
//  CountriesListView.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

protocol CountriesListViewDelegate {
    func updateList()
}

class CountriesListView: UIView {
    
    lazy var countriesTableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
        table.separatorInset.right = table.separatorInset.left + table.separatorInset.left
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    public var delegate: CountriesListViewDelegate?
    
    init(delegate: (UITableViewDelegate & UITableViewDataSource & CountriesListViewDelegate)) {
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

extension CountriesListView {
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(countriesTableView)

    }

    fileprivate func setupConstraints() {
        countriesTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        countriesTableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        countriesTableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        countriesTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
