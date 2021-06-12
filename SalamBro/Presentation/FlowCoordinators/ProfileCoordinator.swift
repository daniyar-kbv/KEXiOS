//
//  ProfileCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class ProfileCoordinator: TabCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType
    
    private var addressListCoordinator: AddressListCoordinator?

    init(navigationController: UINavigationController, tabType: TabBarCoordinator.TabType) {
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func start() {
        let vc = ProfileController(coordinator: self)
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: vc)
    }

    func openOrderHistory() {
        let child = OrderHistoryCoordinator(navigationController: childNavigationController)
        addChild(child)
        child.start()
    }

    func openChangeLanguage() {
        let vc = ChangeLanguageController()
        vc.hidesBottomBarWhenPushed = true
        childNavigationController.pushViewController(vc, animated: true)
    }

    func openAddressList() {
        addressListCoordinator = AddressListCoordinator(navigationController: childNavigationController,
                                           pagesFactory: AddressListPagesFactoryImpl())
        
        addressListCoordinator?.didFinish = { [weak self] in
            self?.addressListCoordinator = nil
        }
        
        addressListCoordinator?.start()
    }

    func openChangeName() {
        let vc = ChangeNameController()
        vc.hidesBottomBarWhenPushed = true
        childNavigationController.pushViewController(vc, animated: true)
    }

    func didFinish() {}
}
