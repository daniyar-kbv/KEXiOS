//
//  AddressPickController.swift
//  SalamBro
//
//  Created by Arystan on 5/4/21.
//

import Reusable
import RxCocoa
import RxSwift
import UIKit

public protocol AddressPickControllerDelegate: AnyObject {
    func didSelect(controller: AddressPickController, address: Address)
}

public final class AddressPickController: UIViewController {
    private let viewModel: AddressPickerViewModelProtocol
    private let disposeBag: DisposeBag

    public weak var delegate: AddressPickControllerDelegate?

    private lazy var navbar: CustomNavigationBarView = {
        let navBar = CustomNavigationBarView(navigationTitle: L10n.AddressPicker.title)
        navBar.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return navBar
    }()

    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.text = L10n.AddressPicker.add
        return label
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        return button
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.tableFooterView = .init()
        view.delegate = self
        view.dataSource = self
        view.register(cellType: AddressPickerCell.self)
        view.separatorInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    public init(viewModel: AddressPickerViewModelProtocol) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
        setup()
        bind()
    }

    public required init?(coder _: NSCoder) {
        nil
    }

    private func bind() {}

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [navbar, addLabel, plusButton, tableView].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        addLabel.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
        }

        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(addLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-24)
            $0.left.greaterThanOrEqualTo(addLabel.snp.right).offset(8)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(addLabel.snp.bottom).offset(16)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc
    private func add() {}

    @objc
    private func back() {
        dismiss(animated: true)
    }
}

extension AddressPickController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = viewModel.didSelect(index: indexPath.row)
        delegate?.didSelect(controller: self, address: address)
        dismiss(animated: true)
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.cellViewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressPickerCell.self)
        cell.set(viewModel: viewModel.cellViewModels[indexPath.row])
        return cell
    }
}
