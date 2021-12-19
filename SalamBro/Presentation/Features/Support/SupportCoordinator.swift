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
        let supportPage = makeSupportPage()

        router.set(navigationController: SBNavigationController(rootViewController: supportPage))
    }

    func restart() {
        let supportPage = makeSupportPage()

        router.getNavigationController().setViewControllers([supportPage], animated: false)
    }

    private func makeSupportPage() -> SupportController {
        let supportPage = pagesFactory.makeSupportPage()

        supportPage.outputs.openDocument
            .subscribe(onNext: { [weak self] url, name in
                self?.showAgreementPage(url: url, name: name)
            }).disposed(by: disposeBag)

        return supportPage
    }

    private func showAgreementPage(url: URL, name: String) {
        let agreementPage = pagesFactory.makeAgreementPage(url: url, name: name)

        router.push(viewController: agreementPage, animated: true)
    }
}
