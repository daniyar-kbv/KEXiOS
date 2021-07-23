////
////  ApplePayButton.swift
////  SalamBro
////
////  Created by Dan on 7/23/21.
////
//
// import Foundation
// import UIKit
// import PassKit
//
// class PaymentApplePayButton: UIButton {
//    private lazy var titleLabel: UILabel = {
//        let view = UILabel()
//        view.text = SBLocalization.localized(key: PaymentText.PaymentSelection.applePay)
//        view.textColor = .white
//        view.font = .systemFont(ofSize: 16, weight: .medium)
//        return view
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func layoutUI() {
//        backgroundColor = .calmGray
//        layer.cornerRadius = 10
//        layer.masksToBounds = true
//    }
// }
