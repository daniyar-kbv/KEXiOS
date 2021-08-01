//
//  ModificatorsViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ModifiersViewModel: AnyObject {
    var outputs: ModifiersViewModelImpl.Output { get }
    var modifiers: [Modifier] { get }

    func getCellStatus(at index: Int) -> (Bool, Bool)
    func changeModifierCount(at index: Int, with count: Int)
    func decreaseTotalCount()
    func increaseTotalCount()
    func setSelectedModifiers(with modifiers: [Modifier])
    func updateCurrentDoneButtonStatus()
}

final class ModifiersViewModelImpl: ModifiersViewModel {
    private(set) var outputs: Output
    private(set) var modifiersGroup: ModifierGroup
    private(set) var modifiers: [Modifier]
    private let menuDetailRepository: MenuDetailRepository

    init(modifierGroup: ModifierGroup, menuDetailRepository: MenuDetailRepository) {
        outputs = .init(modifierGroup: modifierGroup)
        modifiersGroup = modifierGroup
        modifiers = modifierGroup.modifiers
        self.menuDetailRepository = menuDetailRepository
    }

    func getCellStatus(at index: Int) -> (Bool, Bool) {
        if modifiers[index].itemCount >= 0,
           modifiersGroup.totalCount < modifiersGroup.maxAmount
        {
            return (true, true)
        } else if modifiers[index].itemCount > 0,
                  modifiersGroup.totalCount == modifiersGroup.maxAmount
        {
            return (true, false)
        } else {
            return (false, false)
        }
    }

    func updateCurrentDoneButtonStatus() {
        if modifiersGroup.totalCount < modifiersGroup.minAmount {
            outputs.hideDoneButton.accept(())
        } else {
            outputs.showDoneButton.accept(())
        }
    }

    func changeModifierCount(at index: Int, with count: Int) {
        modifiers[index].set(itemCount: count)
        outputs.update.accept(())
    }

    func decreaseTotalCount() {
        let count = modifiersGroup.totalCount - 1
        modifiersGroup.totalCount = count

        updateCurrentDoneButtonStatus()
    }

    func increaseTotalCount() {
        let count = modifiersGroup.totalCount + 1
        modifiersGroup.totalCount = count

        updateCurrentDoneButtonStatus()
    }

    func setSelectedModifiers(with selectedModifiers: [Modifier]) {
        menuDetailRepository.setSelectedModifiers(for: modifiers,
                                                  with: selectedModifiers,
                                                  at: modifiersGroup.uuid,
                                                  totalCount: modifiersGroup.totalCount)
    }
}

extension ModifiersViewModelImpl {
    struct Output {
        let groupName: BehaviorRelay<String>
        let update = PublishRelay<Void>()
        let showDoneButton = PublishRelay<Void>()
        let hideDoneButton = PublishRelay<Void>()

        init(modifierGroup: ModifierGroup) {
            groupName = .init(value: modifierGroup.name)
        }
    }
}
