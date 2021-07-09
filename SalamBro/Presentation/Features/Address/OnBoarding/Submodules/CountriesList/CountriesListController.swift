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

final class CountriesListController: UIViewController, AlertDisplayable, LoaderDisplayable {
    let outputs = Output()
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
        view.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 24, right: 0)
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
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 26, weight: .regular),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.title = SBLocalization.localized(key: AddressText.Countries.title)
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetCountries
            .bind(to: countriesTableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.outputs.didSelectCountry.subscribe(onNext: { [weak self] countryId in
            self?.outputs.didSelectCountry.accept(countryId)
        }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)
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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    @objc
    private func handleRefreshControlAction() {
        viewModel.getCountries()
        refreshControl.endRefreshing()
    }
}

extension CountriesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.getCountriesCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.getCountryName(at: indexPath.row)
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

extension CountriesListController {
    struct Output {
        let didSelectCountry = PublishRelay<Int>()
    }
}
