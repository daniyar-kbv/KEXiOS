//
//  AuthorizationView.swift
//  SalamBro
//
//  Created by Arystan on 3/8/21.
//

//import UIKit
//import InputMask
//
//protocol AuthorizationViewDelegate {
//    func getSMSCode()
//}
//
//class AuthorizationView: UIView {
//
//    public var delegate: AuthorizationViewDelegate!
//
//    lazy var numberField: UITextField = {
//        let field = UITextField()
//        field.placeholder = "+7 (000) 000 00 00"
//        field.keyboardType = .numberPad
//        field.text = "123"
////        field.becomeFirstResponder()
//        field.translatesAutoresizingMaskIntoConstraints = false
//        return field
//    }()
//
//    let getButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Save delivery address", for: .normal)
//        button.addTarget(self, action: #selector(getCode), for: .touchUpInside)
//        button.backgroundColor = UIColor(red: 0.82, green: 0.216, blue: 0.192, alpha: 1.0)
//        button.isEnabled = false
//        button.alpha = 0.5
//        button.layer.cornerRadius = 10
//        button.layer.masksToBounds = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    init(delegate: AuthorizationViewDelegate, second: MaskedTextFieldDelegate) {
////        self.delegate = delegate
//        super.init(frame: .zero)
//        backgroundColor = .white
//
//        numberField.delegate = second
//        print(second.description)
//        print(second.debugDescription)
//        print(second.listener?.description)
//        print(second.listener?.debugDescription)
//        setupViews()
//        setupConstraints()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//extension AuthorizationView {
//    @objc func getCode() {
//        delegate?.getSMSCode()
////        let vc = ConfirmationCodeViewController()
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
////    func textField(
////        _ textField: UITextField,
////        didFillMandatoryCharacters complete: Bool,
////        didExtractValue value: String
////    ) {
////        if complete {
////            getButton.isEnabled = true
////            getButton.alpha = 1.0
////        }
////        print(value)
////    }
//
//    func setupViews() {
//        addSubview(numberField)
//        addSubview(getButton)
//    }
//
//    func setupConstraints() {
//        numberField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        numberField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
////        numberField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 300).isActive = true
////        numberField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
//        numberField.widthAnchor.constraint(equalToConstant: frame.width / 2).isActive = true
//
//        getButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
//        getButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
//        getButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
//        getButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//    }
//}

