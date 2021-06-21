//
//  PromotionsViewModel.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol PromotionsViewModel {
    var promotionURL: BehaviorRelay<URL> { get }
    var infoURL: BehaviorRelay<URL?> { get }
}

final class PromotionsViewModelImpl: PromotionsViewModel {
    let promotionURL: BehaviorRelay<URL>
    let infoURL: BehaviorRelay<URL?>
    
    init(promotionURL: URL, infoURL: URL?) {
        self.promotionURL = BehaviorRelay<URL>(value: promotionURL)
        self.infoURL = BehaviorRelay<URL?>(value: infoURL)
    }
}
