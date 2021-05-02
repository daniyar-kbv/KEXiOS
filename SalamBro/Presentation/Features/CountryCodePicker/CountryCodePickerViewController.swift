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

public protocol CountryCodePickerDelegate: AnyObject {
    func passCountry(country: CountryUI)
}

public final class CountryCodePickerViewController: UIViewController {
    private let viewModel: CountryCodePickerViewModelProtocol
    private let disposeBag: DisposeBag

    public weak var delegate: CountryCodePickerDelegate?

    private lazy var lineImage: UIImageView = {
        let view = UIImageView()
        view.image = Asset.line.image
        view.tintColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.text = L10n.CountryCodePicker.Navigation.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var citiesTableView: UITableView = {
        let view = UITableView()
        view.register(cellType: CountryCodeCell.self)
        view.tableFooterView = UIView()
        view.allowsMultipleSelection = false
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
        [lineImage, titleLabel, citiesTableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        lineImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 36, height: 6))
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(lineImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        citiesTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc
    private func update() {
        viewModel.update()
    }
}

extension CountryCodePickerViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CountryCodeCell.self)
        cell.set(viewModel.cellViewModels[indexPath.row])
        return cell
    }

    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [unowned self] in
            self.delegate?.passCountry(country: self.viewModel.country(by: indexPath.row))
        }
    }
}
