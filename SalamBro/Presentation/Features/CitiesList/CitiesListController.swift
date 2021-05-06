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

public final class CitiesListController: UIViewController {
    private let viewModel: CitiesListViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.CitiesList.Navigation.title)

    private lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.tableFooterView = UIView()
        view.allowsMultipleSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.refreshControl = refreshControl
        return view
    }()

    private lazy var separator = SeparatorView()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(update), for: .valueChanged)
        return view
    }()

    public init(viewModel: CitiesListViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }

    private func bind() {
        viewModel.isAnimating
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.updateTableView
            .bind(to: citiesTableView.rx.reload)
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [navbar, separator, citiesTableView].forEach { view.addSubview($0) }
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navbar.titleLabel.font = .systemFont(ofSize: 26, weight: .regular)
    }

    private func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }

        separator.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalTo(citiesTableView.snp.top)
            $0.height.equalTo(0.30)
        }
    }

    @objc private func update() {
        viewModel.update()
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        cell.textLabel?.text = viewModel.cities[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .white
        cell.tintColor = .kexRed
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        let vc = BrandsController(viewModel: BrandViewModel(repository: DIResolver.resolve(BrandRepository.self)!)) // TODO:
        navigationController?.pushViewController(vc, animated: true)
    }
}
