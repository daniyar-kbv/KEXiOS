//
//  CountryCodePickerViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

public final class CountryCodePickerViewController: UIViewController {
    private let viewModel: CountryCodePickerViewModelProtocol
    private let disposeBag: DisposeBag

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = L10n.CountryCodePicker.Navigation.title
        return label
    }()

    private lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.addTableHeaderViewLine()
        view.register(cellType: CountryCodeCell.self)
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
        view.addTarget(self, action: #selector(update), for: .valueChanged)
        return view
    }()

    public init(viewModel: CountryCodePickerViewModelProtocol) {
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
            .bind(to: citiesTableView.rx.reload)
            .disposed(by: disposeBag)

        viewModel.isAnimating
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        navigationItem.title = L10n.CountryCodePicker.Navigation.title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [titleLabel, citiesTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }

        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }
    }

    @objc
    private func update() {
        viewModel.update()
    }
}

extension CountryCodePickerViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        50
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CountryCodeCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}
