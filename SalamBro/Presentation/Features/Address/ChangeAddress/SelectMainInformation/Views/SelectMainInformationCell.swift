//
//  SelectMainInformationCell.swift
//  SalamBro
//
//  Created by Dan on 6/21/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class SelectMainInformationCell: UITableViewCell {
    var type: InputType!

    let outputs = Output()

    private lazy var field: DropDownTextField = {
        let view = DropDownTextField()
        view.delegate = self
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(type: InputType, currentValue: String?, _ onSelect: (() -> Void)? = nil) {
        self.type = type

        field.selectionAction = onSelect
        field.title = type.title
        field.placeholder = type.placeholder
        field.currentValue = currentValue

        switch type {
        case .address:
            field.chevronRight = true
        case .brand:
            field.chevronRight = true
            field.descriptionText = SBLocalization.localized(key: AddressText.SelectMainInfo.description)
        case .empty:
            field.isHidden = true
        default:
            break
        }
    }

    func setupView() {
        contentView.addSubview(field)

        field.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setFieldState(isActive: Bool) {
        field.isActive = isActive
    }

    func setDataSource(values: [String]) {
        field.dataSource = values
    }

    func set(value: String?) {
        field.currentValue = value
    }
}

extension SelectMainInformationCell: DropDownTextFieldDelegate {
    internal func didSelect(dropDown _: DropDownTextField, option _: String, index: Int) {
        outputs.didSelect.accept((type, index))
    }
}

extension SelectMainInformationCell {
    struct Output {
        let didSelect = PublishRelay<(InputType, Int)>()
    }

    enum InputType {
        case country
        case city
        case address
        case brand
        case empty

        var title: String {
            switch self {
            case .country:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.countryTitle)
            case .city:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.cityTitle)
            case .address:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.addressTitle)
            case .brand:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.brandTitle)
            case .empty:
                return ""
            }
        }

        var placeholder: String {
            switch self {
            case .country:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.countryPlaceholder)
            case .city:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.cityPlaceholder)
            case .address:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.addressPlaceholder)
            case .brand:
                return SBLocalization.localized(key: AddressText.SelectMainInfo.brandPlaceholder)
            case .empty:
                return ""
            }
        }
    }
}
