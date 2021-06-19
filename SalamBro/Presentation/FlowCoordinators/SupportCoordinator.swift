//
//  SupportCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import RxCocoa
import RxSwift
import UIKit

final class SupportCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    private(set) var router: Router
    private let pagesFactory: SupportPagesFactory
    private let coordinatorsFactory: SupportCoordinatorsFactory

    init(router: Router, pagesFactory: SupportPagesFactory, coordinatorsFactory: SupportCoordinatorsFactory) {
        self.router = router
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
        router.set(navigationController: router.getNavigationController())
    }

    override func start() {
        let supportPage = pagesFactory.makeSupportPage()

        supportPage.onTapAgreementDocs = { [weak self] in
            self?.showAgreementPage()
        }

        router.push(viewController: supportPage, animated: true)
    }

    private func showAgreementPage() {
        let agreementPage = pagesFactory.makeAgreementPage()

        router.push(viewController: agreementPage, animated: true)
    }
}
