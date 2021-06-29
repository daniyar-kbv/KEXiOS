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
}

final class MenuDetailModifierCellViewModelImpl: MenuDetailModifierCellViewModel {
    var outputs: Output

    init(modifierGroup: ModifierGroup) {
        outputs = Output(modifierGroup: modifierGroup)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuDetailModifierCellViewModelImpl {
    struct Output {
        private let modifierGroup: ModifierGroup

        init(modifierGroup: ModifierGroup) {
            self.modifierGroup = modifierGroup
        }

        lazy var name = BehaviorRelay<String>(value: self.modifierGroup.name)
        lazy var value = BehaviorRelay<String?>(value: nil)
    }
}
