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
}

final class ModifiersViewModelImpl: ModifiersViewModel {
    let outputs: Output
    let modifiers: [Modifier]

    init(modifierGroup: ModifierGroup) {
        outputs = .init(modifierGroup: modifierGroup)
        modifiers = modifierGroup.modifiers
    }
}

extension ModifiersViewModelImpl {
    struct Output {
        let groupName: BehaviorRelay<String>
        let update = PublishRelay<Void>()

        init(modifierGroup: ModifierGroup) {
            groupName = .init(value: modifierGroup.name)
        }
    }
}
