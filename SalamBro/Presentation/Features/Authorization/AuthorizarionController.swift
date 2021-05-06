//
//  AuthorizarionController.swift
//  SalamBro
//
//  Created by Arystan on 3/8/21.
//

import InputMask
import UIKit

class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener {
    lazy var maskedDelegate: MaskedTextFieldDelegate = {
        let delegate = MaskedTextFieldDelegate(primaryFormat: "([000]) [000] [00] [00]")
        delegate.listener = self
        return delegate
    }()

    lazy var navbar = CustomNavigationBarView(navigationTitle: " ")

    lazy var maintitle: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.title
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.subtitle
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var numberField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.placeholder = L10n.Authorization.NumberField.Placeholder.title
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var aggreementLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.Agreement.Inactive.title + L10n.Authorization.Agreement.Active.title
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel)))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var countryCodeButton: UIButton = {
        let button = UIButton()
//        button.setTitle("X", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(chooseCountryCode), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var chevronView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron.bottom")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Authorization.Button.title, for: .normal)
        button.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        button.backgroundColor = .calmGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_: Bool) {
        countryCodeButton.setTitle("+7", for: .normal)
    }
}

extension AuthorizationController {
    func authorize() {
        let vc = VerificationController()
        vc.number = countryCodeButton.title(for: .normal)! + numberField.text!
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func proceedToAgreementView() {
        let vc = AgreementController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func chooseCountryCode() {
        let viewModel = CountryCodePickerViewModel(repository: DIResolver.resolve(GeoRepository.self)!)
        let vc = CountryCodePickerViewController(viewModel: viewModel)
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
}

extension AuthorizationController: CountryCodePickerDelegate {
    func passCountry(country: CountryUI) {
        countryCodeButton.setTitle(country.callingCode, for: .normal)
    }
}

extension AuthorizationController {
    private func configUI() {
        navigationItem.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension AuthorizationController {
    @objc func getCode() {
        authorize()
    }

    @objc func handleTapOnLabel() {
        proceedToAgreementView()
    }

    func textField(
        _: UITextField,
        didFillMandatoryCharacters complete: Bool,
        didExtractValue value: String
    ) {
        if complete {
            getButton.isEnabled = true
            getButton.alpha = 1.0
        } else {
            getButton.isEnabled = false
            getButton.alpha = 0.5
        }
        print(value)
    }

    func setupViews() {
        maskedDelegate.listener = self
        numberField.delegate = maskedDelegate
        view.backgroundColor = .white
        navbar.translatesAutoresizingMaskIntoConstraints = false
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(navbar)
        view.addSubview(maintitle)
        view.addSubview(subtitle)
        view.addSubview(numberField)
        view.addSubview(chevronView)
        view.addSubview(countryCodeButton)
        view.addSubview(aggreementLabel)
        view.addSubview(getButton)
    }

    func setupConstraints() {
        navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navbar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navbar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navbar.heightAnchor.constraint(equalToConstant: 50).isActive = true

        maintitle.topAnchor.constraint(equalTo: navbar.bottomAnchor).isActive = true
        maintitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        maintitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        subtitle.topAnchor.constraint(equalTo: maintitle.bottomAnchor).isActive = true
        subtitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        subtitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        numberField.leftAnchor.constraint(equalTo: chevronView.rightAnchor, constant: 8).isActive = true
        numberField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        numberField.centerYAnchor.constraint(equalTo: countryCodeButton.titleLabel!.centerYAnchor).isActive = true

        chevronView.leftAnchor.constraint(equalTo: countryCodeButton.rightAnchor).isActive = true
        chevronView.centerYAnchor.constraint(equalTo: countryCodeButton.centerYAnchor).isActive = true
        chevronView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        chevronView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        countryCodeButton.topAnchor.constraint(equalTo: subtitle.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
        countryCodeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        countryCodeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

        aggreementLabel.topAnchor.constraint(equalTo: countryCodeButton.bottomAnchor, constant: 72).isActive = true
        aggreementLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        aggreementLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true

        getButton.topAnchor.constraint(equalTo: aggreementLabel.bottomAnchor, constant: 16).isActive = true
        getButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        getButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
