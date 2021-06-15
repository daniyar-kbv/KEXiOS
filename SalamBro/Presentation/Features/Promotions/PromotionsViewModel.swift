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
//    let promotionURL = Be
}

final class PromotionsViewModelImpl: PromotionsViewModel {
    
    init(promotionURL: URL, infoURL: URL) {
        self.promotionURL = promotionURL
        self.infoURL = infoURL
    }
    
    func getPromotionURL() -> URL {
        return promotionURL
    }
    
    func getInfoURL() -> URL {
        return infoURL
    }
}
