//
//  AuthorizarionController.swift
//  SalamBro
//
//  Created by Arystan on 3/8/21.
//

import UIKit
import InputMask

class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener {
    
    lazy var maskedDelegate: MaskedTextFieldDelegate = {
       let delegate = MaskedTextFieldDelegate(primaryFormat: "{+7} ([000]) [000] [00] [00]")
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
        field.placeholder = "+7 (000) 000 00 00"
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.placeholder = "Номер телефона"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var confirmationButton: UIButton = {
        let button = UIButton()
        button.setTitle("""
                    Продолжая, вы соглашаетесь со сбором, обработкой персональных данных и Пользовательским соглашением
                    """, for: .normal)

        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proceedToAgreementView), for: .touchUpInside)
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
        

        configUI()
        setupViews()
        setupConstraints()
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
//        delegate?.getSMSCode()
//        let vc = ConfirmationCodeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    func isValidPhone(phone: String) -> Bool {
//            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
//            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//            return phoneTest.evaluate(with: phone)
//        }
    
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
        view.addSubview(confirmationButton)
        view.addSubview(getButton)
    }

    func setupConstraints() {
        mainTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        mainTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        smallTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor).isActive = true
        smallTitle.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        smallTitle.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        numberField.topAnchor.constraint(equalTo: smallTitle.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        numberField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        numberField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        confirmationButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        confirmationButton.bottomAnchor.constraint(equalTo: getButton.topAnchor, constant: -16).isActive = true
        confirmationButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        
        getButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        getButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        getButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }
}
