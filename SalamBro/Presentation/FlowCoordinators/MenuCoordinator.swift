//
//  MenuCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class MenuCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()

    let router: Router

    private let serviceComponents: ServiceComponents
    private let repositoryComponents: RepositoryComponents
    private let pagesFactory: MenuPagesFactory
    private let coordinatorsFactory: MenuCoordinatorsFactory

    init(router: Router,
         serviceComponents: ServiceComponents,
         repositoryComponents: RepositoryComponents,
         pagesFactory: MenuPagesFactory,
         coordinatorsFactory: MenuCoordinatorsFactory)
    {
        self.router = router
        self.serviceComponents = serviceComponents
        self.repositoryComponents = repositoryComponents
        self.pagesFactory = pagesFactory
        self.coordinatorsFactory = coordinatorsFactory
        router.set(navigationController: router.getNavigationController())
    }

    override func start() {
        let menuPage = pagesFactory.makeManuPage()

        menuPage.outputs.toChangeBrand
            .subscribe(onNext: { [weak self] didSave in
                self?.openChangeBrand(didSave: didSave)
            }).disposed(by: disposeBag)

        menuPage.outputs.toAddressess
            .subscribe(onNext: { [weak self] didSave in
                self?.openChangeAddress(didSelectAddress: didSave)
            }).disposed(by: disposeBag)

        menuPage.outputs.toPromotion
            .subscribe(onNext: { [weak self] promotionURL, infoURL in
                self?.openPromotion(promotionURL: promotionURL, infoURL: infoURL)
            }).disposed(by: disposeBag)

        menuPage.outputs.toPositionDetail
            .subscribe(onNext: { [weak self] positionUUID in
                self?.openDetail(positionUUID: positionUUID)
            }).disposed(by: disposeBag)

        router.push(viewController: menuPage, animated: true)
    }

    private func openChangeBrand(didSave: (() -> Void)? = nil) {
        let addressCoordinator = coordinatorsFactory.makeAddressCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, flowType: .changeBrand(didSave: didSave, presentOn: router.getNavigationController()))
        add(addressCoordinator)

        addressCoordinator.didFinish = { [weak self] in
            self?.remove(addressCoordinator)
        }

        addressCoordinator.start()
    }

    func openChangeAddress(didSelectAddress: (() -> Void)? = nil) {
        let addressCoordinator = coordinatorsFactory.makeAddressCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, flowType: .changeAddress(didSelectAddress: didSelectAddress))
        add(addressCoordinator)

        addressCoordinator.didFinish = { [weak self] in
            self?.remove(addressCoordinator)
        }

        addressCoordinator.start()
    }

    private func openPromotion(promotionURL: URL, infoURL: URL?) {
        let promotionsCoordinator = coordinatorsFactory.makePromotionsCoordinator(promotionURL: promotionURL, infoURL: infoURL)
        add(promotionsCoordinator)

        promotionsCoordinator.didFinish = { [weak self] in
            self?.remove(promotionsCoordinator)
        }

        promotionsCoordinator.start()
    }

    private func openDetail(positionUUID: String) {
        let menuDetailCoordinator = coordinatorsFactory.makeMenuDetailCoordinator(serviceComponents: serviceComponents, positionUUID: positionUUID)
        add(menuDetailCoordinator)

        menuDetailCoordinator.didFinish = { [weak self] in
            self?.remove(menuDetailCoordinator)
        }

        menuDetailCoordinator.start()
    }

    func didFinish() {}
}
