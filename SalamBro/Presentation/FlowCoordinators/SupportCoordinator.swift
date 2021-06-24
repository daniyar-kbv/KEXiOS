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
    }

    override func start() {
        let supportPage = pagesFactory.makeSupportPage()

        supportPage.outputs.openDocument
            .subscribe(onNext: { [weak self] url in
                self?.showAgreementPage(url: url)
            }).disposed(by: disposeBag)

        router.set(navigationController: SBNavigationController(rootViewController: supportPage))
    }

    private func showAgreementPage(url: URL) {
        let agreementPage = pagesFactory.makeAgreementPage(url: url)

        router.push(viewController: agreementPage, animated: true)
    }
}
