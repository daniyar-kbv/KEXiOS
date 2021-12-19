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

    let addressTextField = MapTextField(image: SBImageResource.getIcon(for: AddressIcons.Map.arrow))
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

    func changeButtonAppearance(isEmpty: Bool) {
        actionButton.isEnabled = !isEmpty
        actionButton.backgroundColor = isEmpty ? .calmGray : .kexRed
    }
}

// MARK: Layout & Configuration UI

extension MapAddressView {
    private func configureViews() {
        layer.cornerRadius = 18
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        addressTextField.placeholder = SBLocalization.localized(key: AddressText.Map.addressField)
        commentaryTextField.placeholder = SBLocalization.localized(key: AddressText.Map.commentaryField)

        actionButton.setTitle(SBLocalization.localized(key: AddressText.Map.proceedButton), for: .normal)
    }

    private func layoutUI() {
        backgroundColor = .white
        addSubview(addressTextField)
        addressTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(50)
        }

        addSubview(commentaryTextField)
        commentaryTextField.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.greaterThanOrEqualTo(50)
        }

        addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.top.equalTo(commentaryTextField.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
