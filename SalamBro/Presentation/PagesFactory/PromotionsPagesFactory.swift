//
//  PromotionsPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol PromotionsPagesFactory {
    func makePromotionsPage(promotionURL: URL, infoURL: URL?) -> PromotionsController
    func makePromotionsInfoPage(url: URL) -> AgreementController
}
 
class PromotionsPagesFactoryImpl: PromotionsPagesFactory {
    func makePromotionsPage(promotionURL: URL, infoURL: URL?) -> PromotionsController {
        return .init(viewModel: makePromotionsViewModel(promotionURL: promotionURL, infoURL: infoURL))
    }
    
    private func makePromotionsViewModel(promotionURL: URL, infoURL: URL?) -> PromotionsViewModel {
        return PromotionsViewModelImpl(promotionURL: promotionURL, infoURL: infoURL)
    }
    
    func makePromotionsInfoPage(url: URL) -> AgreementController {
        return .init(viewModel: makePromotionsInfoViewModel(url: url))
    }
    
    func makePromotionsInfoViewModel(url: URL) -> AgreementViewModel {
        return AgreementViewModelImpl(url: url)
    }
}
