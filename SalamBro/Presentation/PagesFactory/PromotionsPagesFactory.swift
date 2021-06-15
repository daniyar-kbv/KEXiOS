//
//  PromotionsPagesFactory.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation

protocol PromotionsPagesFactory {
    func makePromotionPage(promotionURL: URL, infoURL: URL) -> PromotionsController
    func makePromotionInfoPage(url: URL) -> WebViewController
}
 
class PromotionsPagesFactoryImpl: PromotionsPagesFactory {
    func makePromotionPage(promotionURL: URL, infoURL: URL) -> PromotionsController {
        return .init(promotionURL: promotionURL, infoURL: infoURL)
    }
    
    func makePromotionInfoPage(url: URL) -> WebViewController {
        return .init(url: url)
    }
}
