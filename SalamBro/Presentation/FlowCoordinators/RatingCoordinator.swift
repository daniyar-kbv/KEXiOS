//
//  RatingCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class PromotionsCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    private var router: Router
    private var pagesFactory: PromotionsPagesFactory
    private let promotionURL: URL
    private let infoURL: URL?

    var didFinish: (() -> Void)?

    init(router: Router,
         pagesFactory: PromotionsPagesFactory,
         promotionURL: URL,
         infoURL: URL?)
    {
        self.router = router
        self.pagesFactory = pagesFactory
        self.promotionURL = promotionURL
        self.infoURL = infoURL
    }

    func start() {
        let promotionPage = pagesFactory.makePromotionsPage(promotionURL: promotionURL, infoURL: infoURL)

        promotionPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)

        promotionPage.outputs.toInfo.subscribe(onNext: { [weak self] url in
            self?.openPromotionInfo(url: url)
        }).disposed(by: disposeBag)

        promotionPage.hidesBottomBarWhenPushed = true
        router.push(viewController: promotionPage, animated: true)
    }

    private func openPromotionInfo(url: URL) {
        let promotionInfoPage = pagesFactory.makePromotionsInfoPage(url: url)

        router.present(promotionInfoPage, animated: true, completion: nil)
    }
}
