//
//  MapAddressView.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 03.06.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class MapAddressView: UIView {
    private let disposeBag = DisposeBag()

    let addressTextField = MapTextField(image: UIImage(named: "map_right_icon"))
    let commentaryTextField = MapTextField()
    let actionButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .calmGray
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        return btn
    }()

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func changeButtonAppearance(based text: String) {
        if text != "" {
            actionButton.isEnabled = true
            actionButton.backgroundColor = .kexRed
            return
        }
        actionButton.isEnabled = false
        actionButton.backgroundColor = .calmGray
    }
}

// MARK: Layout & Configuration UI

extension MapAddressView {
    private func configureViews() {
        layer.cornerRadius = 18
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        addressTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.MapView.AddressField.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        commentaryTextField.attributedPlaceholder = NSAttributedString(
            string: L10n.MapView.CommentaryLabel.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        )

        actionButton.setTitle(L10n.MapView.ProceedButton.title, for: .normal)
    }

    private func layoutUI() {
        backgroundColor = .white
        addSubview(addressTextField)
        addressTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        addSubview(commentaryTextField)
        commentaryTextField.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
        }

        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.top.equalTo(commentaryTextField.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }
    }
}
