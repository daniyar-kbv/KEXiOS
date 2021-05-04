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

public final class CountriesListController: UIViewController {
    private let viewModel: CountriesListViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var countriesTableView: UITableView = {
        let view = UITableView()
        view.allowsMultipleSelection = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        view.separatorInset.right = view.separatorInset.left + view.separatorInset.left
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(update), for: .valueChanged)
        return view
    }()

    public init(viewModel: CountriesListViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func bind() {
        viewModel.updateTableView
            .bind(to: countriesTableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.isAnimating
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        navigationItem.title = L10n.CountriesList.Navigation.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc
    private func update() {
        viewModel.update()
    }
}

// MARK: - UITableView

extension CountriesListController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.countries.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.countries[indexPath.row].name
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
        let viewModel = CitiesListViewModel(country: self.viewModel.countries[indexPath.row].id,
                                            repository: DIResolver.resolve(GeoRepository.self)!)
        let vc = CitiesListController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
