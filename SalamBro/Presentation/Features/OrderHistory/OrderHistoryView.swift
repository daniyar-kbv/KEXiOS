//
//  OrderHistoryView.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import UIKit

class OrderHistoryView: UIView {
    
    lazy var shareToInstagramButton: UIButton = {
        let button = UIButton()
        button.setTitle("share to instagram", for: .normal)
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var rateOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("rate order", for: .normal)
        button.backgroundColor = .kexRed
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .white
        addSubview(shareToInstagramButton)
        addSubview(rateOrderButton)
    }
    
    func setupConstraints() {
        shareToInstagramButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        shareToInstagramButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        rateOrderButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rateOrderButton.topAnchor.constraint(equalTo: shareToInstagramButton.bottomAnchor, constant: 16).isActive = true
    }
}
