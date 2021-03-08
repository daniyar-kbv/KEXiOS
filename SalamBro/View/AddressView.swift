//
//  AddressView.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

protocol AddressViewDelegate {
    func submit()
}

class AddressView: UIView {
    
    public var delegate: AddressViewDelegate?
    
    lazy var streetLabel: UILabel = {
        let label = UILabel()
        label.text = "Street"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var streetField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var buildingLabel: UILabel = {
        let label = UILabel()
        label.text = "Building number"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buildingField: UITextField = {
        let field = UITextField()
        return field
    }()

    lazy var apartmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Apartment N"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var apartmentField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var entranceLabel: UILabel = {
        let label = UILabel()
        label.text = "Entrance N"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var entranceField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var floorLabel: UILabel = {
        let label = UILabel()
        label.text = "Floor N"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var floorField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var codeField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var commentaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Commentary"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentaryField: UITextField = {
        let field = UITextField()
        return field
    }()
    
    lazy var formView: UIStackView = {
        let view = UIStackView()
        view.alignment                                  = .fill
        view.axis                                       = .vertical
        view.distribution                               = .fillEqually
        view.spacing                                    = 10
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save delivery address", for: .normal)
        button.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.82, green: 0.216, blue: 0.192, alpha: 1.0)
        button.isEnabled = false
        button.alpha = 0.5
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(delegate: (AddressViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupAddTargetIsNotEmptyTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddressView {
    func setupViews() {
        backgroundColor = .white
        
        let forms = [streetLabel, buildingLabel, apartmentLabel, entranceLabel, floorLabel, codeLabel, commentaryLabel]
        let fields = [streetField, buildingField, apartmentField, entranceField, floorField, codeField, commentaryField]
        
        zip(forms, fields).forEach {
            $1.clearButtonMode = .whileEditing
            $1.layer.borderColor = UIColor.gray.cgColor
            $1.layer.backgroundColor = UIColor.white.cgColor
            $1.layer.borderWidth = 0.0
            $1.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            $1.layer.shadowOpacity = 0.5
            $1.layer.shadowRadius = 0.0
            $1.translatesAutoresizingMaskIntoConstraints = false
            
            formView.addArrangedSubview($0)
            formView.addArrangedSubview($1)
        }
        
        addSubview(formView)
        addSubview(saveButton)
    }
    
    func setupConstraints() {
        formView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        formView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        formView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -94).isActive = true
        formView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        
        saveButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        saveButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        [streetField, buildingField, apartmentField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @objc func editingChanged(sender: UITextField) {

        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let street = streetField.text, !street.isEmpty ,
              let building = buildingField.text, !building.isEmpty
              // let apartment = apartmentField.text, !apartment.isEmpty
        else {
            self.saveButton.isEnabled = false
            self.saveButton.alpha = 0.5
            return
        }
        // enable saveButton if all conditions are met
        self.saveButton.isEnabled = true
        self.saveButton.alpha = 1.0
       }
    
    @objc func submitAction() {
        delegate?.submit()
    }
}
