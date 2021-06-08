//
//  CountriesViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class CountriesListController: ViewController {
    private let viewModel: CountriesListViewModelProtocol
    private let disposeBag = DisposeBag()

    private lazy var countriesTableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.allowsMultipleSelection = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        view.addTableHeaderViewLine()
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefreshControlAction), for: .valueChanged)
        return view
    }()

    init(viewModel: CountriesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCountries()
        setup()
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.coordinator.didFinish()
    }

    private func bind() {
        viewModel.updateTableView
            .bind(to: countriesTableView.rx.reload)
            .disposed(by: disposeBag)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.CountriesList.Navigation.title
        navigationController?.navigationBar.layoutIfNeeded()
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(countriesTableView)
    }

    private func setupConstraints() {
        countriesTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    @objc
    private func handleRefreshControlAction() {
        viewModel.refresh()
        refreshControl.endRefreshing()
    }
}

extension CountriesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.countries[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}
