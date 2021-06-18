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

final class PromotionsCoordinator {
    private let disposeBag = DisposeBag()
    private var navigationController: UINavigationController
    private var pagesFactory: PromotionsPagesFactory

    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController,
         pagesFactory: PromotionsPagesFactory)
    {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
    }

    func start(promotionURL: URL, infoURL: URL?) {
        let promotionPage = pagesFactory.makePromotionsPage(promotionURL: promotionURL, infoURL: infoURL)

        promotionPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)

        promotionPage.outputs.toInfo.subscribe(onNext: { [weak self] url in
            self?.openPromotionInfo(url: url)
        }).disposed(by: disposeBag)

        promotionPage.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(promotionPage, animated: true)
    }

    private func openPromotionInfo(url: URL) {
        let promotionInfoPage = pagesFactory.makePromotionsInfoPage(url: url)

        navigationController.present(promotionInfoPage, animated: true)
    }
}
