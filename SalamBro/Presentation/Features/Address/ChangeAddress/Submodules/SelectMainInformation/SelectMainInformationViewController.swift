//
//  SelectMainInformationViewController.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SelectMainInformationViewController: UIViewController, LoaderDisplayable, AlertDisplayable {
    private let viewModel: SelectMainInformationViewModelProtocol
    private let disposeBag = DisposeBag()
    private let cellsSequence: [SelectMainInformationCell.InputType] = [.country, .city, .address, .empty, .brand]

    let outputs = Output()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.estimatedRowHeight = UITableView.automaticDimension
        view.tableFooterView = UIView()
        view.rowHeight = 64
        view.separatorColor = .white
        view.isScrollEnabled = false
        view.register(SelectMainInformationCell.self, forCellReuseIdentifier: String(describing: SelectMainInformationCell.self))
        return view
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .kexRed
        button.layer.cornerRadius = 10
        button.setTitle(L10n.SelectMainInfo.save, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()

    init(viewModel: SelectMainInformationViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setup()
        bind()

        if viewModel.flowType == .create {
            viewModel.getCountries()
        }
    }

    public required init?(coder _: NSCoder) {
        nil
    }

    private func bind() {
        viewModel.outputs.didStartRequest.subscribe(onNext: { [weak self] in
            self?.showLoader()
        }).disposed(by: disposeBag)

        viewModel.outputs.didEndRequest.subscribe(onNext: { [weak self] in
            self?.hideLoader()
        }).disposed(by: disposeBag)

        viewModel.outputs.didGetError.subscribe(onNext: { [weak self] error in
            guard let error = error else { return }
            self?.showError(error)
        }).disposed(by: disposeBag)

        viewModel.outputs.updateTableView.bind(to: tableView.rx.reload).disposed(by: disposeBag)

        viewModel.outputs.didGetCountries.subscribe(onNext: { [weak self] countries in
            self?.getCellWith(type: .country)?.setDataSource(values: countries)
        }).disposed(by: disposeBag)

        viewModel.outputs.didGetCities.subscribe(onNext: { [weak self] cities in
            self?.getCellWith(type: .city)?.setDataSource(values: cities)
        }).disposed(by: disposeBag)

        viewModel.outputs.didSelectCountry.bind { [unowned self] countryName in
            self.getCellWith(type: .country)?.set(value: countryName)

            for type in [.city, .address, .brand] as [SelectMainInformationCell.InputType] {
                self.getCellWith(type: type)?.set(value: nil)
            }

            self.getCellWith(type: .city)?.setFieldState(isActive: true)
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectCity.bind { [unowned self] cityName in
            self.getCellWith(type: .city)?.set(value: cityName)

            for type in [.address, .brand] as [SelectMainInformationCell.InputType] {
                self.getCellWith(type: type)?.setFieldState(isActive: cityName != nil)
            }
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectAddress.bind { [unowned self] addressName in
            self.getCellWith(type: .address)?.set(value: addressName)
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectBrand.bind { [unowned self] brandName in
            self.getCellWith(type: .brand)?.set(value: brandName)
        }.disposed(by: disposeBag)

        viewModel.outputs.didSave.subscribe(onNext: { [weak self] in
            self?.outputs.didSave.accept(())
        }).disposed(by: disposeBag)

        viewModel.outputs.checkResult.subscribe(onNext: { [weak self] isComplete in
            self?.changeSaveButtonState(isActive: isComplete)
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.SelectMainInfo.title
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        viewModel.checkValues()
    }

    deinit {
        if viewModel.flowType == .changeBrand {
            outputs.didTerminate.accept(())
        }
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [tableView, saveButton]
            .forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview()
        }

        saveButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(42)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    @objc
    private func save() {
        let firstAction = UIAlertAction(
            title: L10n.SelectMainInfo.Alert.Action.yes,
            style: .default,
            handler: { _ in
                self.viewModel.didSave()
            }
        )

        let secondAction = UIAlertAction(
            title: L10n.SelectMainInfo.Alert.Action.no,
            style: .default,
            handler: nil
        )

        switch viewModel.flowType {
        case .create:
            showAlert(title: L10n.SelectMainInfo.Alert.title,
                      message: L10n.SelectMainInfo.Alert.Body.address,
                      actions: [firstAction, secondAction])
        case .changeAddress, .changeBrand:
            showAlert(title: L10n.SelectMainInfo.Alert.title,
                      message: L10n.SelectMainInfo.Alert.Body.address,
                      actions: [firstAction, secondAction])
        }
    }

//    Tech debt: create button class with states
    private func changeSaveButtonState(isActive: Bool) {
        saveButton.isUserInteractionEnabled = isActive
        saveButton.backgroundColor = isActive ? .kexRed : .calmGray
    }

    private func didSelectItem(type: SelectMainInformationCell.InputType, with index: Int) {
        switch type {
        case .country:
            viewModel.didChange(country: index)
        case .city:
            viewModel.didChange(city: index)
        default:
            break
        }
    }
}

extension SelectMainInformationViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return cellsSequence.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SelectMainInformationCell.self), for: indexPath) as! SelectMainInformationCell
        configureCell(cell: cell, indexPath: indexPath)
        cell.outputs.didSelect
            .subscribe(onNext: { [weak self] params in
                self?.didSelectItem(type: params.0, with: params.1)
            }).disposed(by: disposeBag)
        return cell
    }

    private func getCellWith(type: SelectMainInformationCell.InputType) -> SelectMainInformationCell? {
        guard let index = cellsSequence.firstIndex(of: type) else { return nil }
        return tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SelectMainInformationCell
    }
}

extension SelectMainInformationViewController {
    private func configureCell(cell: SelectMainInformationCell, indexPath: IndexPath) {
        configureCellSetup(cell: cell, indexPath: indexPath)
        configureCellFlow(cell: cell)
    }

    private func configureCellSetup(cell: SelectMainInformationCell, indexPath: IndexPath) {
        switch cellsSequence[indexPath.row] {
        case .country:
            cell.setupCell(type: cellsSequence[indexPath.row],
                           currentValue: viewModel.deliveryAddress?.country?.name)
        case .city:
            cell.setupCell(type: cellsSequence[indexPath.row],
                           currentValue: viewModel.deliveryAddress?.city?.name)
        case .address:
            cell.setupCell(type: cellsSequence[indexPath.row],
                           currentValue: viewModel.deliveryAddress?.address?.name) { [weak self] in
                self?.outputs.toMap
                    .accept((self?.viewModel.deliveryAddress?.address,
                             {
                                 [weak self] address in
                                 self?.viewModel.didChange(address: address)
                             }))
            }
        case .brand:
            cell.setupCell(type: cellsSequence[indexPath.row],
                           currentValue: viewModel.flowType == .create ? nil : viewModel.brand?.name) { [weak self] in
                guard let cityid = self?.viewModel.deliveryAddress?.city?.id else { return }
                self?.outputs.toBrands
                    .accept((cityid,
                             {
                                 [weak self] brand in
                                 self?.viewModel.didChange(brand: brand)
                             }))
            }
        case .empty:
            cell.setupCell(type: cellsSequence[indexPath.row], currentValue: nil)
        }
    }

    private func configureCellFlow(cell: SelectMainInformationCell) {
        switch viewModel.flowType {
        case .create:
            if [.city, .address, .brand].contains(cell.type) {
                cell.setFieldState(isActive: false)
            }
        case .changeAddress, .changeBrand:
            if [.country, .city, .address].contains(cell.type) {
                cell.setFieldState(isActive: false)
            }
        }
    }
}

extension SelectMainInformationViewController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toMap = PublishRelay<(Address?, (_ address: Address) -> Void)>()
        let toBrands = PublishRelay<(Int, (_ brand: Brand) -> Void)>()
        let didSave = PublishRelay<Void>()
        let close = PublishRelay<Void>()
    }
}
