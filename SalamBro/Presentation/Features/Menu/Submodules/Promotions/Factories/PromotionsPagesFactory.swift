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

class PromotionsPagesFactoryImpl: DependencyFactory, PromotionsPagesFactory {
    func makePromotionsPage(promotionURL: URL, infoURL: URL?) -> PromotionsController {
        return scoped(.init(viewModel: makePromotionsViewModel(promotionURL: promotionURL, infoURL: infoURL)))
    }

    private func makePromotionsViewModel(promotionURL: URL, infoURL: URL?) -> PromotionsViewModel {
        return scoped(PromotionsViewModelImpl(promotionURL: promotionURL, infoURL: infoURL))
    }

    func makePromotionsInfoPage(url: URL) -> AgreementController {
        return scoped(.init(viewModel: makePromotionsInfoViewModel(url: url)))
    }

    func makePromotionsInfoViewModel(url: URL) -> AgreementViewModel {
        return scoped(AgreementViewModelImpl(input: .init(url: url, name: nil)))
    }
}
