//
//  CartCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import RxCocoa
import RxSwift

final class CartCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private(set) var router: Router
    private let pagesFactory: CartPagesFactory
    private let coordinatorsFactory: CartCoordinatorsFactory

    init(router: Router,
         pagesFactory: CartPagesFactory,
         coordinatorsFactory: CartCoordinatorsFactory)
    {
        self.router = router
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
    }

    override func start() {
        let cartPage = pagesFactory.makeCartPage()

        cartPage.outputs.toAuth.subscribe(onNext: { [weak self] in
            self?.startAuthCoordinator()

        }).disposed(by: disposeBag)

        router.set(navigationController: SBNavigationController(rootViewController: cartPage))
    }

    private func startAuthCoordinator() {
        let authCoordinator = coordinatorsFactory.makeAuthCoordinator()
        add(authCoordinator)

        authCoordinator.didFinish = { [weak self, weak authCoordinator] in
            self?.remove(authCoordinator)
            authCoordinator = nil
        }

        authCoordinator.start()
    }
}
