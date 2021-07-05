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

    private(set) var router: Router

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
            .subscribe(onNext: { [weak self] promotionURL, name in
                self?.openPromotion(promotionURL: promotionURL, name: name)
            }).disposed(by: disposeBag)

        menuPage.outputs.toPositionDetail
            .subscribe(onNext: { [weak self] positionUUID in
                self?.openDetail(positionUUID: positionUUID)
            }).disposed(by: disposeBag)

        router.set(navigationController: SBNavigationController(rootViewController: menuPage))
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

    private func openPromotion(promotionURL: URL, name: String) {
        let promotionsPage = pagesFactory.makePromotionsPage(url: promotionURL, name: name)

        router.getNavigationController().setNavigationBarHidden(false, animated: true)

        router.push(viewController: promotionsPage, animated: true)
    }

    private func openDetail(positionUUID: String) {
        let menuDetailCoordinator = coordinatorsFactory.makeMenuDetailCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, positionUUID: positionUUID)
        add(menuDetailCoordinator)

        menuDetailCoordinator.didFinish = { [weak self] in
            self?.remove(menuDetailCoordinator)
        }

        menuDetailCoordinator.start()
    }

    func didFinish() {}
}
