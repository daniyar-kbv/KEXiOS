//
//  CartCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

class CartCoordinator: TabCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType

    init(navigationController: UINavigationController, tabType: TabBarCoordinator.TabType) {
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func openAuth() {
        let child = AuthCoordinator(navigationController: childNavigationController, pagesFactory: AuthPagesFactoryImpl())
        addChild(child)
        child.start()
    }

    func start() {
        let viewModel = CartViewModel(coordinator: self, cartRepository: CartRepositoryMockImpl())
        let vc = CartController(viewModel: viewModel)
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: vc)
    }

    func didFinish() {}
}
