//
//  ChangeNameView.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit

protocol ChangeNameViewDelegate {
    func saveName()
}

class ChangeNameView: UIView {
    
    public var delegate: ChangeNameViewDelegate?
    
    lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.ChangeName.NameField.placeholder
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.ChangeName.SaveButton.title, for: .normal)
        button.addTarget(self, action: #selector(saveName), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .calmGray
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(delegate: ChangeNameViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChangeNameView {
    func setupViews() {
        backgroundColor = .arcticWhite
        
        nameView.addSubview(nameField)
        addSubview(nameView)
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        nameField.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 16).isActive = true
        nameField.rightAnchor.constraint(equalTo: nameView.rightAnchor, constant: -16).isActive = true
        nameField.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        
        nameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        nameView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        saveButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        saveButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 190).isActive = true
        saveButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
    }

    @objc func editingChanged(sender: UITextField) {

        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let name = nameField.text, !name.isEmpty else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .calmGray
            return
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = .kexRed
       }

    
    @objc func saveName() {
        delegate?.saveName()
    }
    
}

