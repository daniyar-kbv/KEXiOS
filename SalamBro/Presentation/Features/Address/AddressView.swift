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
        view.distribution                               = .equalSpacing
        view.spacing                                    = 10
        view.translatesAutoresizingMaskIntoConstraints  = false
        return view
    }()
    lazy var countryForm = FormView(labelText: "Страна*", tag: 0)
    lazy var cityForm = FormView(labelText: "Город*", tag: 1)
    lazy var streetForm = FormView(labelText: "Улица*", tag: 2)
    lazy var buildingForm = FormView(labelText: "Дом*", tag: 3)
    lazy var apartmentForm = FormView(labelText: "Квартира", tag: 4)
    lazy var entranceForm = FormView(labelText: "Подъезд", tag: 5)
    lazy var floorForm = FormView(labelText: "Этаж", tag: 6)
    lazy var commentaryForm = FormView(labelText: "Комментарий к адресу", tag: 7)
    
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

extension AddressView: UITextFieldDelegate {
    
    func setupViews() {
        backgroundColor = .white
        
        let forms = [countryForm, cityForm, streetForm, buildingForm, apartmentForm, entranceForm, floorForm, commentaryForm]
        
        for i in forms {
            i.formField.delegate = self
            formView.addArrangedSubview(i)
        }
        
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
        saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: -18).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
        if let nextForm = self.viewWithTag(textField.superview!.tag + 1) as? FormView {
            nextForm.formField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            scrollView.setContentOffset(CGPoint(x: 0, y: (textField.superview?.frame.origin.y)!), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
