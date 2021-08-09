//
//  CartPromocodeViewModel.swift
//  SalamBro
//
//  Created by Dan on 8/6/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CartPromocodeViewModel: CartCellViewModel {
    var outputs: CartPromocodeViewModelImpl.Output { get }

    func set(state: CartPromocodeViewModelImpl.State)
}

final class CartPromocodeViewModelImpl: CartPromocodeViewModel {
    let outputs: Output

    init(promocode: Promocode?) {
        guard let promocode = promocode else {
            outputs = .init(state: .init(value: .notSet))
            return
        }
        outputs = .init(state: .init(value: .set(description: promocode.description)))
    }

    func set(state: State) {
        outputs.state.accept(state)
    }
}

extension CartPromocodeViewModelImpl {
    enum State {
        case set(description: String)
        case notSet
    }

    struct Output {
        let state: BehaviorRelay<State>
    }
}
