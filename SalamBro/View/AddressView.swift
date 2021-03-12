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

    lazy var formView: UIStackView = {
        let view = UIStackView()
        view.alignment                                  = .fill
        view.axis                                       = .vertical
        view.distribution                               = .fill
        view.spacing                                    = 10
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    
    lazy var streetForm = FormView(labelText: "Улица*")
    lazy var buildingForm = FormView(labelText: "Дом*")
    lazy var apartmentForm = FormView(labelText: "Квартира")
    lazy var entranceForm = FormView(labelText: "Подъезд")
    lazy var floorForm = FormView(labelText: "Этаж")
    lazy var commentaryForm = FormView(labelText: "Комментарий к адресу")
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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

    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isScrollEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init(delegate: (AddressViewDelegate & UIScrollViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        scrollView.delegate = delegate
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
        let forms = [streetForm, buildingForm, apartmentForm, entranceForm, floorForm, commentaryForm]
        for i in forms {
            formView.addArrangedSubview(i)
        }
        formView.addArrangedSubview(emptyView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formView)
        contentView.addSubview(saveButton)

        addSubview(scrollView)
    }
    
    func setupConstraints() {

        formView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        formView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 6).isActive = true
        formView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -6).isActive = true
        formView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -32).isActive = true

        saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -18).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func setupAddTargetIsNotEmptyTextFields() {
        [streetForm.formField, buildingForm.formField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }

    @objc func editingChanged(sender: UITextField) {

        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)

        guard let street = streetForm.formField.text, !street.isEmpty ,
              let building = buildingForm.formField.text, !building.isEmpty
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
