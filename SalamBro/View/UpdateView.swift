//
//  UpdateView.swift
//  SalamBro
//
//  Created by Arystan on 3/7/21.
//

import UIKit

protocol UpdateViewDelegate {
    func update()
}

class UpdateView: UIView {
    
    public var delegate: UpdateViewDelegate?
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "It's time to update"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Мы добавили много новых функций и
        исправили некоторые баги, чтобы вам
        было удобнее пользоваться приложением
        """
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update app", for: .normal)
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(update), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(delegate: (UpdateViewDelegate)) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func update() {
        delegate?.update()
    }
}

extension UpdateView {
    fileprivate func setupViews() {
        backgroundColor = .arcticWhite
        [logo, titleLabel, descriptionLabel, updateButton].forEach { addSubview($0) }
        
    }

    fileprivate func setupConstraints() {
        logo.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 16).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        updateButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        updateButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }

}
