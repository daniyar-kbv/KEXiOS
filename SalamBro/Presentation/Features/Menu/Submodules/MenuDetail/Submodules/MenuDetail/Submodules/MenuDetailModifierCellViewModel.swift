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
    func set(value: Modifier)
    func getValue() -> Modifier?
    func didSelect() -> Bool
}

final class MenuDetailModifierCellViewModelImpl: MenuDetailModifierCellViewModel {
    private var modifierGroup: ModifierGroup
    private var value: Modifier?

    lazy var outputs = Output(name: makeTitle())

    init(modifierGroup: ModifierGroup) {
        self.modifierGroup = modifierGroup
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getModifierGroup() -> ModifierGroup {
        return modifierGroup
    }

    func set(value: Modifier) {
        self.value = value
    }

    func getValue() -> Modifier? {
        return value
    }

    func didSelect() -> Bool {
        return value != nil
    }
}

extension MenuDetailModifierCellViewModelImpl {
    private func makeTitle() -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(
            string: modifierGroup.name,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.mildBlue,
            ]
        )

        if modifierGroup.isRequired {
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

            attributedTitle.append(dotString)
            attributedTitle.append(requiredString)
        }

        return attributedTitle as NSAttributedString
    }

    private func makeValueText() {
        let valueText = modifierGroup
            .selectedModifiers
            .map { $0.name }
            .joined(separator: ", ")

        outputs.value.accept(valueText)
    }
}

extension MenuDetailModifierCellViewModelImpl {
    struct Output {
        init(name: NSAttributedString) {
            self.name = .init(value: name)
        }

        let name: BehaviorRelay<NSAttributedString>
        let value = BehaviorRelay<String?>(value: nil)
    }
}
