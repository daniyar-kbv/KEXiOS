//
//  CitiesListController.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class CitiesListController: UIViewController, AlertDisplayable {
    let outputs = Output()
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.addTableHeaderViewLine()
        view.separatorColor = .mildBlue
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        view.allowsMultipleSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        view.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 24, right: 0)
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefreshControlAction), for: .valueChanged)
        return view
    }()

    private let viewModel: CitiesListViewModelProtocol

    init(viewModel: CitiesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCities()
        setup()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.CitiesList.Navigation.title
    }
}

extension CitiesListController {
    private func bind() {
        viewModel.outputs.didGetCities
            .bind(to: tableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError.subscribe(onNext: { [weak self] error in
            guard let error = error else { return }
            self?.showError(error)
        }).disposed(by: disposeBag)

        viewModel.outputs.didSelectCity.subscribe(onNext: { [weak self] cityId in
            self?.outputs.didSelectCity.accept(cityId)
        }).disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [tableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func handleRefreshControlAction() {
        viewModel.refreshCities()
        refreshControl.endRefreshing()
    }
}

extension CitiesListController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.cities.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.cities[indexPath.row].name
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}

extension CitiesListController {
    struct Output {
        let didSelectCity = PublishRelay<Int>()
        let close = PublishRelay<Void>()
    }
}
