//
//  FormView.swift
//  SalamBro
//
//  Created by Arystan on 3/12/21.
//

import UIKit

class FormView: UIView {
    
    lazy var formLabel: UILabel = {
        let label = UILabel()
        label.text = "template"
        label.textColor = .mildBlue
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var formField: UITextField = {
        let field = UITextField()
        field.clearButtonMode = .whileEditing
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.backgroundColor = UIColor.white.cgColor
        field.layer.borderWidth = 0.0
        field.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        field.layer.shadowOpacity = 0.5
        field.layer.shadowRadius = 0.0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    init(labelText: String, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        formLabel.text = labelText
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FormView {
    fileprivate func setupViews() {
        backgroundColor = .arcticWhite
        addSubview(formLabel)
        addSubview(formField)
    }

    fileprivate func setupConstraints() {
        formLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        formLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        formLabel.bottomAnchor.constraint(equalTo: formField.topAnchor, constant: -6).isActive = true
        formLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        formField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
        formField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        formField.heightAnchor.constraint(equalToConstant: 26).isActive = true
        formField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }

}

