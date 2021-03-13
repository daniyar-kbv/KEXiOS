//
//  AuthorizarionController.swift
//  SalamBro
//
//  Created by Arystan on 3/8/21.
//

import UIKit
import InputMask

class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener {
    
    private var countryViewModel : CountryViewModel!
    
    lazy var maskedDelegate: MaskedTextFieldDelegate = {
        let delegate = MaskedTextFieldDelegate(primaryFormat: "([000]) [000] [00] [00]")
        delegate.listener = self
        return delegate
    }()
    
    lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Введите Ваш номер телефона"
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var smallTitle: UILabel = {
        let label = UILabel()
        label.text = "На этот номер придет подтверждающий СМС код"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var numberField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.placeholder = "Номер телефона"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var aggreementLabel: UILabel = {
        let label = UILabel()
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let linkAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.underlineColor: UIColor.blue]
        let helloString = NSMutableAttributedString(string: " Продолжая, вы соглашаетесь со сбором, обработкой персональных данных и ", attributes: textAttributes)
        let worldString = NSAttributedString(string: "Пользовательским соглашением", attributes: linkAttributes)
        helloString.append(worldString)
        print(helloString)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.attributedText = helloString
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var countryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(chooseCountryCode), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let getButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get code", for: .normal)
        button.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.82, green: 0.216, blue: 0.192, alpha: 1.0)
        button.isEnabled = false
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryViewModel =  CountryViewModel()
        configUI()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let country = countryViewModel.getMarked() else {
            return
        }
        countryCodeButton.setTitle(country.callingCode, for: .normal)
    }
}

extension AuthorizationController {
    func authorize() {
        print("proceed to next view")
        let vc = VerificationController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func proceedToAgreementView() {
        let vc = AgreementController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func chooseCountryCode() {
        let vc = CountryCodePickerViewController()
        vc.countryViewModel = self.countryViewModel
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AuthorizationController: CountryCodePickerDelegate {
    func passCountry(county: Country) {
        countryCodeButton.setTitle(county.callingCode, for: .normal)
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
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        
        guard let text = aggreementLabel.attributedText?.string else {
            return
        }

        if let range = text.range(of: "Пользовательским соглашением"),
            recognizer.didTapAttributedTextInLabel(label: aggreementLabel, inRange: NSRange(range, in: text)) {
            proceedToAgreementView()
        }
    }
    
    func textField(
        _ textField: UITextField,
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
        
        view.addSubview(mainTitle)
        view.addSubview(smallTitle)
        view.addSubview(numberField)
        view.addSubview(countryCodeButton)
        view.addSubview(aggreementLabel)
        view.addSubview(getButton)
    }

    func setupConstraints() {
        mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        mainTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        smallTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor).isActive = true
        smallTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        smallTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
//        numberField.topAnchor.constraint(equalTo: smallTitle.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
//        numberField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
//        numberField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        numberField.leftAnchor.constraint(equalTo: countryCodeButton.safeAreaLayoutGuide.rightAnchor, constant: 24).isActive = true
        numberField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        numberField.centerYAnchor.constraint(equalTo: countryCodeButton.titleLabel!.centerYAnchor).isActive = true
            
        countryCodeButton.topAnchor.constraint(equalTo: smallTitle.safeAreaLayoutGuide.bottomAnchor, constant: 40).isActive = true
        countryCodeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        countryCodeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        aggreementLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        aggreementLabel.bottomAnchor.constraint(equalTo: getButton.topAnchor, constant: -16).isActive = true
        aggreementLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        
        getButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        getButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }
}
