//
//  AdditionalView.swift
//  SalamBro
//
//  Created by Arystan on 3/11/21.
//

import UIKit

protocol AdditionalViewDelegate {
    func action()
}

class AdditionalView: UIView {
    
    public var delegate: AdditionalViewDelegate?
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "template text"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .mildBlue
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("template", for: .normal)
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
    
    init(delegate: (AdditionalViewDelegate), descriptionTitle: String, buttonTitle: String) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews(descriptionTitle, buttonTitle)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonAction() {
        delegate?.action()
    }
}


extension AdditionalView {
    func setupViews(_ descriptionText: String, _ buttonText: String) {
        
        descriptionLabel.text = descriptionText
        button.setTitle(buttonText, for: .normal)
        backgroundColor = .arcticWhite
        addSubview(logo)
        addSubview(descriptionLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        
        descriptionLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        
        button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32).isActive = true
        button.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 54).isActive = true
        button.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -54).isActive = true
        button.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        logo.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

}
