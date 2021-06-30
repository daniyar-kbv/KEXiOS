//
//  ModificatorsViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/17/21.
//

import Foundation

protocol ModifiersViewModel {}

class ModifiersViewModelImpl: ModifiersViewModel {}

extension ModifiersViewModelImpl {
    struct Output {
        let didSelectModifier
    }
}
