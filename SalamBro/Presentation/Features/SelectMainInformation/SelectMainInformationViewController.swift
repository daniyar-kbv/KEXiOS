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

public final class SelectMainInformationViewController: UIViewController {
    private let viewModel: SelectMainInformationViewModelProtocol
    private let disposeBag = DisposeBag()

    private lazy var navbar: CustomNavigationBarView = {
        let navBar = CustomNavigationBarView(navigationTitle: L10n.SelectMainInfo.title)
        navBar.backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return navBar
    }()

    private lazy var countryTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.countries)
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.country
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var citiesTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.cities)
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.city
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var brandsTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            let viewModel = BrandViewModel(repository: DIResolver.resolve(BrandRepository.self)!)
            let vc = BrandsController(viewModel: viewModel)
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        view.delegate = self
        view.placeholderColor = .darkGray
        view.placeholderText = L10n.SelectMainInfo.brand
        view.descriptionText = L10n.SelectMainInfo.description
        return view
    }()

    private lazy var addressTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            let viewModel = AddressPickerViewModel(repository: DIResolver.resolve(GeoRepository.self)!)
            let vc = AddressPickController(viewModel: viewModel)
            vc.delegate = self
            self?.present(vc, animated: true)
        }
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.address
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            countryTextField,
            citiesTextField,
            addressTextField,
            brandsTextField,
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
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()

    public init(viewModel: SelectMainInformationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
        bind()
    }

    public required init?(coder _: NSCoder) {
        nil
    }

    private func bind() {
        viewModel.cityName.bind { [unowned self] in
            self.citiesTextField.currentValue = $0
        }.disposed(by: disposeBag)

        viewModel.countryName.bind { [unowned self] in
            self.countryTextField.currentValue = $0
        }.disposed(by: disposeBag)

        viewModel.brandName.bind { [unowned self] in
            self.brandsTextField.currentValue = $0
        }.disposed(by: disposeBag)

        viewModel.address.bind { [unowned self] in
            self.addressTextField.currentValue = $0
        }.disposed(by: disposeBag)
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [navbar, stackView, saveButton].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(24)
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

    @objc
    private func back() {
        dismiss(animated: true)
    }
}

extension SelectMainInformationViewController: BrandsControllerDelegate {
    public func didSelectBrand(controller _: BrandsController, brand: BrandUI) {
        viewModel.didChange(brand: brand)
    }
}

extension SelectMainInformationViewController: DropDownTextFieldDelegate {
    public func didSelect(dropDown: DropDownTextField, option: String, index: Int) {
        switch dropDown {
        case countryTextField:
            viewModel.didChange(country: index)
        case citiesTextField:
            viewModel.didChange(city: option)
        default:
            break
        }
    }
}

extension SelectMainInformationViewController: AddressPickControllerDelegate {
    public func didSelect(controller _: AddressPickController, address: Address) {
        viewModel.didChange(address: address)
    }
}
