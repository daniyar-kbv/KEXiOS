//
//  GetNameView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

protocol GetNameViewDelegate {
    func submit()
}

class GetNameView: UIView {
    
    public var delegate: GetNameViewDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.GetName.title
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.GetName.Field.title
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.backgroundColor = UIColor.white.cgColor
        field.layer.borderWidth = 0.0
        field.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        field.layer.shadowOpacity = 0.5
        field.layer.shadowRadius = 0.0
        field.keyboardType = .alphabet
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.GetName.Button.title, for: .normal)
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.82, green: 0.216, blue: 0.192, alpha: 1.0)
        button.isEnabled = false
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(delegate: GetNameViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GetNameView {
    func setupViews() {
        backgroundColor = .arcticWhite
        
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(nameField)
        addSubview(nextButton)
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: nameField.topAnchor, constant: -8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        nameField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150).isActive = true
        nameField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        nextButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        nextButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func editingChanged(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let name = nameField.text, !name.isEmpty else {
            self.nextButton.isEnabled = false
            self.nextButton.alpha = 0.5
            return
        }
        self.nextButton.isEnabled = true
        self.nextButton.alpha = 1.0
       }
    
    @objc func submitAction() {
        delegate?.submit()
    }

}
