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
    
    lazy var nameField: UITextField = {
        let field = UITextField()
        field.placeholder = L10n.ChangeName.NameField.placeholder
        field.backgroundColor = .lightGray
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.ChangeName.SaveButton.title, for: .normal)
        button.addTarget(self, action: #selector(saveName), for: .touchUpInside)
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
        
        addSubview(nameField)
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        nameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        nameField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        saveButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        saveButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -65).isActive = true
    }
    
    @objc func saveName() {
        delegate?.saveName()
    }
}

