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

final class SelectMainInformationViewController: ViewController {
    private let viewModel: SelectMainInformationViewModelProtocol
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private lazy var countryTextField: DropDownTextField = {
        let view = DropDownTextField(type: .country)
        view.delegate = self
        view.currentValue = viewModel.deliveryAddress?.country?.name
        return view
    }()

    private lazy var citiesTextField: DropDownTextField = {
        let view = DropDownTextField(type: .city)
        view.delegate = self
        view.currentValue = viewModel.deliveryAddress?.city?.name
        return view
    }()

    private lazy var addressTextField: DropDownTextField = {
        let view = DropDownTextField(type: .address)
        view.selectionAction = { [weak self] in
            self?.outputs.toMap.accept((self?.viewModel.deliveryAddress?.address,
                                        { [weak self] address in
                                            self?.viewModel.didChange(address: address)
                                        }))
        }
        view.delegate = self
        view.chevronRight = true
        view.currentValue = viewModel.deliveryAddress?.address?.name
        return view
    }()

    private lazy var brandsTextField: DropDownTextField = {
        let view = DropDownTextField(type: .brand)
        view.selectionAction = { [weak self] in
            guard let cityid = self?.viewModel.deliveryAddress?.city?.id else { return }
            self?.outputs.toBrands.accept((cityid,
                                           { [weak self] brand in
                                               self?.viewModel.didChange(brand: brand)
                                           }))
        }
        view.delegate = self
        view.chevronRight = true
        view.titleColor = .darkGray
        view.descriptionText = L10n.SelectMainInfo.description
        view.currentValue = viewModel.flowType == .create ? nil : viewModel.brand?.name
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            countryTextField,
            citiesTextField,
            addressTextField,
        ])
        view.axis = .vertical
        view.spacing = 16
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
        viewModel.outputs.didGetCountries.subscribe(onNext: { [weak self] in
            self?.countryTextField.dataSource = self?.viewModel.countries.map { $0.name } ?? []
        }).disposed(by: disposeBag)

        viewModel.outputs.didGetCities.subscribe(onNext: { [weak self] in
            self?.citiesTextField.dataSource = self?.viewModel.cities.map { $0.name } ?? []
        }).disposed(by: disposeBag)

        viewModel.outputs.didSelectCountry.bind { [unowned self] cityName in
            self.countryTextField.currentValue = cityName
            self.citiesTextField.currentValue = nil
            self.addressTextField.currentValue = nil
            self.brandsTextField.currentValue = nil

            self.citiesTextField.isActive = true
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectCity.bind { [unowned self] cityName in
            self.citiesTextField.currentValue = cityName

            self.addressTextField.isActive = cityName != nil
            self.brandsTextField.isActive = cityName != nil
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectAddress.bind { [unowned self] addressName in
            self.addressTextField.currentValue = addressName
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectBrand.bind { [unowned self] brandName in
            self.brandsTextField.currentValue = brandName
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(back))

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
        setupFlow()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [stackView, brandsTextField, saveButton].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        brandsTextField.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottomMargin).offset(40)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
        }

        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }
    }

    func setupFlow() {
        switch viewModel.flowType {
        case .create:
            citiesTextField.isActive = false
            addressTextField.isActive = false
            brandsTextField.isActive = false
        case .changeAddress, .changeBrand:
            countryTextField.isActive = false
            citiesTextField.isActive = false
            addressTextField.isActive = false
        }
    }

    @objc
    private func back() {
        dismiss(animated: true)
    }

    @objc
    private func save() {
        viewModel.didSave()
    }

//    Tech debt: create button class with states
    func changeSaveButtonState(isActive: Bool) {
        saveButton.isUserInteractionEnabled = isActive
        saveButton.backgroundColor = isActive ? .kexRed : .calmGray
    }
}

extension SelectMainInformationViewController: DropDownTextFieldDelegate {
    public func didSelect(dropDown: DropDownTextField, option _: String, index: Int) {
        switch dropDown {
        case countryTextField:
            viewModel.didChange(country: index)
        case citiesTextField:
            viewModel.didChange(city: index)
        default:
            break
        }
    }
}

extension SelectMainInformationViewController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toMap = PublishRelay<(Address?, (_ address: Address) -> Void)>()
        let toBrands = PublishRelay<(Int, (_ brand: Brand) -> Void)>()
        let didSave = PublishRelay<Void>()
    }
}
