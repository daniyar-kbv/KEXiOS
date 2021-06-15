//
//  MenuCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

final class MenuCoordinator: TabCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType
    
    private var serviceComponents: ServiceComponents
    private var pagesFactory: MenuPagesFactory
    
    private var addressCoordinator: AddressCoordinator?
    private var promotionsCoordinator: PromotionsCoordinator?

    init(serviceComponents: ServiceComponents,
         pagesFactory: MenuPagesFactory,
         navigationController: UINavigationController,
         tabType: TabBarCoordinator.TabType) {
        self.serviceComponents = serviceComponents
        self.pagesFactory = pagesFactory
        
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func start() {
        let menuPage = pagesFactory.makeManuPage()
        
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: menuPage)
    }

//    Tech debt: move to pages factory
    
    func openSelectMainInfo(didSave: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                       pagesFactory: AddressPagesFactoryImpl(serviceComponents: serviceComponents),
                                       flowType: .changeBrand(didSave: didSave))
        
        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }
        
        addressCoordinator?.start()
    }
    
//    Tech debt: move to pages factory

    func openChangeAddress(didSelectAddress: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                       pagesFactory: AddressPagesFactoryImpl(serviceComponents: serviceComponents),
                                       flowType: .changeAddress(didSelectAddress: didSelectAddress))
        
        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }
        
        addressCoordinator?.start()
    }

    private func openPromotion(promotionURL: URL, infoURL: URL) {
        let child = PromotionsCoordinator(navigationController: childNavigationController,
                                          pagesFactory: PromotionsPagesFactoryImpl())
        
        child.didFinish = { [weak self] in
            self?.promotionsCoordinator = nil
        }

        child.start(promotionURL: promotionURL, infoURL: infoURL)
    }

    func openDetail() {
        let child = MenuDetailCoordinator(navigationController: childNavigationController)
        addChild(child)
        child.start()
    }

    func didFinish() {}
}
