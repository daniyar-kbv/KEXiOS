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

    private lazy var countryTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.countries)
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.country
        return view
    }()

    private lazy var citiesTextField: DropDownTextField = {
        let view = DropDownTextField(options: viewModel.cities.map { $0.name })
        view.delegate = self
        view.placeholderText = L10n.SelectMainInfo.city
        return view
    }()

    private lazy var brandsTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            self?.viewModel.selectBrand()
        }
        view.delegate = self
        view.chevronRight = true
        view.placeholderColor = .darkGray
        view.placeholderText = L10n.SelectMainInfo.brand
        view.descriptionText = L10n.SelectMainInfo.description
        return view
    }()

    private lazy var addressTextField: DropDownTextField = {
        let view = DropDownTextField(options: nil)
        view.selectionAction = { [weak self] in
            self?.viewModel.selectAddress()
        }
        view.delegate = self
        view.chevronRight = true
        view.placeholderText = L10n.SelectMainInfo.address
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
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        return button
    }()

    init(viewModel: SelectMainInformationViewModelProtocol) {
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

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.SelectMainInfo.title
    }

    private func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .white
        [stackView, saveButton].forEach { view.addSubview($0) }
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(24)
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

    @objc
    private func save() {
        viewModel.save()
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
