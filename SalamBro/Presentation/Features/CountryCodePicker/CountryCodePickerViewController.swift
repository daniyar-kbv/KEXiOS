//
//  CountryCodePickerViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import RxCocoa
import RxSwift
import UIKit

final class CountryCodePickerViewController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.addTableHeaderViewLine()
        view.register(CountryCodeCell.self, forCellReuseIdentifier: CountryCodeCell.reuseIdentifier)
        view.tableFooterView = UIView()
        view.allowsMultipleSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.refreshControl = refreshControl
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()

    private let viewModel: CountryCodePickerViewModel

    init(viewModel: CountryCodePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { nil }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setup()
        viewModel.getCountries()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

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

        viewModel.outputs.didGetCountries
            .subscribe(onNext: { [weak self] in
                self?.citiesTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        navigationItem.title = L10n.CountryCodePicker.Navigation.title
        view.backgroundColor = .white
        [citiesTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(22)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func refresh() {
        viewModel.refresh()
        refreshControl.endRefreshing()
    }
}

extension CountryCodePickerViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.countries.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCodeCell.reuseIdentifier, for: indexPath) as? CountryCodeCell else {
            fatalError()
        }
        cell.configure(model: viewModel.countries[indexPath.row])
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let codeCountry = viewModel.selectCodeCountry(at: indexPath)
        outputs.didSelectCountryCode.accept(codeCountry.country)
    }
}

extension CountryCodePickerViewController {
    struct Output {
        let didSelectCountryCode = PublishRelay<Country>()
    }
}
