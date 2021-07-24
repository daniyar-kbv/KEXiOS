//
//  MenuDetailModifierCellViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/29/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuDetailModifierCellViewModel {
    var outputs: MenuDetailModifierCellViewModelImpl.Output { get set }

    func getModifierGroup() -> ModifierGroup
    func getValue() -> Modifier?
    func makeValueText()
}

final class MenuDetailModifierCellViewModelImpl: MenuDetailModifierCellViewModel {
    private var modifierGroup: ModifierGroup
    private var value: Modifier?

    lazy var outputs = Output(name: makeTitle())

    init(modifierGroup: ModifierGroup) {
        self.modifierGroup = modifierGroup
        makeValueText()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getModifierGroup() -> ModifierGroup {
        return modifierGroup
    }

    func getValue() -> Modifier? {
        return value
    }
}

extension MenuDetailModifierCellViewModelImpl {
    private func makeTitle() -> NSAttributedString {
        var requiredAmountTitle = NSMutableAttributedString(string: "")

        var attributedTitle = NSMutableAttributedString(
            string: modifierGroup.name,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
            ]
        )

        if modifierGroup.isRequired {
            let amountString = modifierGroup.maxAmount == 1 ?
                " (\(modifierGroup.maxAmount) \(SBLocalization.localized(key: MenuText.MenuDetail.position)))" :
                " (\(modifierGroup.maxAmount) \(SBLocalization.localized(key: MenuText.MenuDetail.positions)))"

            requiredAmountTitle = NSMutableAttributedString(
                string: amountString,
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
                ]
            )

            let dotString = NSAttributedString(
                string: " • ",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
                ]
            )

            let requiredString = NSAttributedString(
                string: SBLocalization.localized(key: MenuText.MenuDetail.required),
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                ]
            )

            attributedTitle.append(requiredAmountTitle)
            attributedTitle.append(dotString)
            attributedTitle.append(requiredString)
        } else {
            attributedTitle = NSMutableAttributedString(
                string: SBLocalization.localized(key: MenuText.MenuDetail.additional),
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
                ]
            )

            let amountString = modifierGroup.maxAmount == 1 ?
                " (\(SBLocalization.localized(key: MenuText.MenuDetail.max)) \(modifierGroup.maxAmount) \(SBLocalization.localized(key: MenuText.MenuDetail.position)))" :
                " (\(SBLocalization.localized(key: MenuText.MenuDetail.max)) \(modifierGroup.maxAmount) \(SBLocalization.localized(key: MenuText.MenuDetail.positions)))"

            requiredAmountTitle = NSMutableAttributedString(
                string: amountString,
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
                ]
            )

            attributedTitle.append(requiredAmountTitle)
        }

        return attributedTitle as NSAttributedString
    }

    func makeValueText() {
        let valueText = modifierGroup
            .selectedModifiers
            .map { $0.name }
            .joined(separator: ", ")

        outputs.isRequired.accept(modifierGroup.isRequired)
        outputs.value.accept(valueText)
    }
}

extension MenuDetailModifierCellViewModelImpl {
    struct Output {
        init(name: NSAttributedString) {
            self.name = .init(value: name)
        }

        let name: BehaviorRelay<NSAttributedString>
        let isRequired = BehaviorRelay<Bool?>(value: nil)
        let value = BehaviorRelay<String?>(value: nil)
    }
}
