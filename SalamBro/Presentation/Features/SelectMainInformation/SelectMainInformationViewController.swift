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
    private var flowType: SelectMainInformationViewModel.FlowType
    private let viewModel: SelectMainInformationViewModelProtocol
    private let disposeBag = DisposeBag()
    
    let outputs = Output()

    private lazy var countryTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.countries)
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.country
        view.currentValue = L10n.CountriesList.Navigation.title
        return view
    }()

    private lazy var citiesTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.cities.map { $0.name })
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.city
        view.currentValue = L10n.CitiesList.Navigation.title
        return view
    }()

    private lazy var addressTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            self?.outputs.toMap.accept({ [weak self] address in
                self?.viewModel.didChange(address: address)
            })
        }
        view.delegate = self
        view.chevronRight = true
        view.placeholderText = L10n.SelectMainInfo.address
//        Tech debt: change currentValue to appropriate text
        view.currentValue = L10n.SelectMainInfo.address
        return view
    }()
    
    private lazy var brandsTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            self?.outputs.toBrands.accept({ [weak self] brand in
                self?.viewModel.didChange(brand: brand)
            })
        }
        view.delegate = self
        view.chevronRight = true
        view.placeholderColor = .darkGray
        view.placeholderText = L10n.SelectMainInfo.brand
        view.descriptionText = L10n.SelectMainInfo.description
        view.currentValue = L10n.Brands.Navigation.title
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

    init(viewModel: SelectMainInformationViewModelProtocol,
         flowType: SelectMainInformationViewModel.FlowType) {
        self.viewModel = viewModel
        self.flowType = flowType
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
        bind()
        
        //    Tech debt: remove after addresses storage change
        switch flowType {
        case .changeBrand:
            viewModel.sendCurrentValues()
        case .changeAddress:
            viewModel.sendAddressValues()
        default:
            break
        }
    }

    public required init?(coder _: NSCoder) {
        nil
    }

    private func bind() {
        viewModel.outputs.didSelectCountry.bind { [unowned self] cityName in
            self.countryTextField.currentValue = cityName
            if self.flowType == .create {
                self.citiesTextField.isActive = true
            }
        }.disposed(by: disposeBag)

        viewModel.outputs.didSelectCity.bind { [unowned self] cityName in
            self.citiesTextField.currentValue = cityName
            if self.flowType == .create {
                self.addressTextField.isActive = true
                self.brandsTextField.isActive = true
            }
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
        if flowType == .changeBrand {
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
        switch self.flowType {
        case .create:
            citiesTextField.isActive = false
            addressTextField.isActive = false
            brandsTextField.isActive = false
        case .changeAddress:
            countryTextField.isActive = false
            citiesTextField.isActive = false
        case .changeBrand:
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
    public func didSelect(dropDown: DropDownTextField, option: String, index: Int) {
        switch dropDown {
        case countryTextField:
            viewModel.didChange(country: index)
        case citiesTextField:
            viewModel.didChange(cityname: option)
        default:
            break
        }
    }
}

extension SelectMainInformationViewController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toMap = PublishRelay<(_ address: Address) -> Void>()
        let toBrands = PublishRelay<(_ brand: Brand) -> Void>()
        let didSave = PublishRelay<Void>()
    }
}
