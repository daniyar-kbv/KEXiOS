//
//  MenuCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class MenuCoordinator: TabCoordinator {
    var parentCoordinator: LegacyCoordinator?

    var childCoordinators: [LegacyCoordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType

    var addressCoordinator: AddressCoordinator?

    init(navigationController: UINavigationController, tabType: TabBarCoordinator.TabType) {
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func start() {
        let viewModel = MenuViewModel(coordinator: self,
                                      menuRepository: DIResolver.resolve(MenuRepository.self)!,
                                      locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                      brandRepository: DIResolver.resolve(BrandRepository.self)!)
        let vc = MenuController(viewModel: viewModel, scrollService: MenuScrollService())
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: vc)
    }

    func openSelectMainInfo(didSave: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                                pagesFactory: AddressPagesFactoryImpl(),
                                                flowType: .changeBrand(didSave: didSave))

        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }

        addressCoordinator?.start()
    }

    func openChangeAddress(didSelectAddress: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                                pagesFactory: AddressPagesFactoryImpl(),
                                                flowType: .changeAddress(didSelectAddress: didSelectAddress))

        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }

        addressCoordinator?.start()
    }

    func openRating() {
        let child = RatingCoordinator(navigationController: childNavigationController)
        addChild(child)
        child.start()
    }

    func openDetail() {
        let child = MenuDetailCoordinator(navigationController: childNavigationController)
        addChild(child)
        child.start()
    }

    func didFinish() {}
}
