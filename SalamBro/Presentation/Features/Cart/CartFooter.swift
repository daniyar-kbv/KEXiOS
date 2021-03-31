//
//  CartFooter.swift
//  SalamBro
//
//  Created by Arystan on 3/20/21.
//

import UIKit

protocol CartFooterDelegate {
    func action()
}

class CartFooter: UIView {
    
//    public var delegate: CartFooterDelegate?

    lazy var productsLabel: UILabel = {
        let label = UILabel()
        label.text = "7 товаров"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var productsPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "5 160 ₸"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var productsStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Доставка"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deliveryPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "500 ₸"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deliveryStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var promocodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ввести промокод", for: .normal)
        button.backgroundColor = .arcticWhite
        button.setTitleColor(.kexRed, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.kexRed.cgColor
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    init(delegate: (CartFooterDelegate)) {
//        self.delegate = delegate
//        super.init(frame: .zero)
//        setupViews()
//        setupConstraints()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonAction() {
//        delegate?.action()
    }
}


extension CartFooter {
    func setupViews() {
        backgroundColor = .arcticWhite
        productsStack.addArrangedSubview(productsLabel)
        productsStack.addArrangedSubview(productsPriceLabel)
        
        deliveryStack.addArrangedSubview(deliveryLabel)
        deliveryStack.addArrangedSubview(deliveryPriceLabel)
        
        addSubview(separator)
        addSubview(promocodeButton)
        addSubview(productsStack)
        addSubview(deliveryStack)
    }
    
    func setupConstraints() {
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        promocodeButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        promocodeButton.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        promocodeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 54).isActive = true
        promocodeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -54).isActive = true
        
        productsStack.topAnchor.constraint(equalTo: promocodeButton.bottomAnchor, constant: 32).isActive = true
        productsStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        productsStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        
        deliveryStack.topAnchor.constraint(equalTo: productsStack.bottomAnchor, constant: 8).isActive = true
        deliveryStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        deliveryStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        deliveryStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }

}
