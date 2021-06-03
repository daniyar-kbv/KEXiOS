//
//  MenuCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

class MenuCoordinator: TabCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType
    
    init(navigationController: UINavigationController, tabType: TabBarCoordinator.TabType) {
        self.navigationController = navigationController
        self.tabType = tabType
    }
    
    func start() {
        let viewModel = MenuViewModel(coordinator: self,
                                      menuRepository: DIResolver.resolve(MenuRepository.self)!,
                                      locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                      brandRepository: DIResolver.resolve(BrandRepository.self)!,
                                      geoRepository: DIResolver.resolve(GeoRepository.self)!)
        let vc = MenuController(viewModel: viewModel, scrollService: MenuScrollService())
        childNavigationController = templateNavigationController(title: tabType.title,
                                                      image: tabType.image,
                                                      rootViewController: vc)
    }
    
    func openSelectMainInfo(didSave: (() -> Void)? = nil) {
        let child = AddressCoordinator(navigationController: childNavigationController, flowType: .changeMainInfo(didSave: didSave))
        addChild(child)
        child.start()
    }
    
    func openChangeAddress(didSelectAddress: ((Address) -> Void)? = nil) {
        let child = AddressCoordinator(navigationController: childNavigationController, flowType: .changeAddress(didSelectAddress: didSelectAddress))
        addChild(child)
        child.start()
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
    
    func didFinish() { }
}
