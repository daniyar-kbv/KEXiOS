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
        let menuPage = makeMenuPage()

        router.set(navigationController: SBNavigationController(rootViewController: menuPage))
    }

    func restart() {
        let menuPage = makeMenuPage()

        router.getNavigationController().setViewControllers([menuPage], animated: true)
    }

    private func makeMenuPage() -> MenuController {
        let menuPage = pagesFactory.makeManuPage()

        menuPage.outputs.toChangeBrand
            .subscribe(onNext: { [weak self] in
                self?.openChangeBrand()
            })
            .disposed(by: disposeBag)

        menuPage.outputs.toAddressess
            .subscribe(onNext: { [weak self] in
                self?.openChangeAddress()
            })
            .disposed(by: disposeBag)

        menuPage.outputs.toPromotion
            .subscribe(onNext: { [weak self] promotionId, promotionURL, name in
                self?.openPromotion(promotionId: promotionId, promotionURL: promotionURL, name: name)
            })
            .disposed(by: disposeBag)

        menuPage.outputs.toPositionDetail
            .subscribe(onNext: { [weak self] positionUUID in
                self?.openDetail(positionUUID: positionUUID)
            })
            .disposed(by: disposeBag)

        menuPage.outputs.toAuthChangeBrand
            .subscribe(onNext: { [weak self] in
                self?.startAuthCoordinator {
                    self?.openChangeBrand()
                }
            })
            .disposed(by: disposeBag)

        menuPage.outputs.toAuthChangeAddress
            .subscribe(onNext: { [weak self] in
                self?.startAuthCoordinator {
                    self?.openChangeAddress()
                }
            })
            .disposed(by: disposeBag)

        return menuPage
    }

    private func openChangeBrand() {
        let addressCoordinator = coordinatorsFactory.makeAddressCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, flowType: .changeBrand(presentOn: router.getNavigationController()))
        add(addressCoordinator)

        addressCoordinator.didFinish = { [weak self] in
            self?.remove(addressCoordinator)
        }

        addressCoordinator.start()
    }

    private func openChangeAddress() {
        let addressCoordinator = coordinatorsFactory.makeAddressCoordinator(serviceComponents: serviceComponents, repositoryComponents: repositoryComponents, flowType: .changeAddress)
        add(addressCoordinator)

        addressCoordinator.didFinish = { [weak self] in
            self?.remove(addressCoordinator)
        }

        addressCoordinator.start()
    }

    func openPromotion(promotionId: Int, promotionURL: URL, name: String?) {
        let promotionsPage = pagesFactory.makePromotionsPage(id: promotionId, url: promotionURL, name: name)

        promotionsPage.outputs.toAuth
            .subscribe(onNext: { [weak self] in
                self?.startAuthCoordinator { [weak promotionsPage] in
                    promotionsPage?.didAuthirize()
                }
            })
            .disposed(by: disposeBag)

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

    private func startAuthCoordinator(didAuthorize: @escaping () -> Void) {
        let authCoordinator = coordinatorsFactory.makeAuthCoordinator()
        router.getNavigationController().setNavigationBarHidden(false, animated: true)

        add(authCoordinator)

        authCoordinator.didFinish = { [weak self, weak authCoordinator] in
            self?.remove(authCoordinator)
        }

        authCoordinator.didAuthorize = didAuthorize

        authCoordinator.start()
    }

    func didFinish() {}
}
