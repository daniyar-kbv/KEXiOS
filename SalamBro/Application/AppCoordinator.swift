//
//  AppCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private var onBoardingCoordinator: OnBoardingCoordinator?

    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository

    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents,
         navigationController: UINavigationController,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository)
    {
        self.serviceComponents = serviceComponents
        self.navigationController = navigationController
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
    }

    public func start() {
        if locationRepository.isAddressComplete(),
           brandRepository.getCurrentBrand() != nil
        {
            startMenu()
        } else {
            startFirstFlow()
        }
    }

    private func startFirstFlow() {
        onBoardingCoordinator = OnBoardingCoordinator(navigationController: UINavigationController(),
                                          pagesFactory: OnBoardingPagesFactoryImpl(serviceComponents: serviceComponents))
        
        onBoardingCoordinator?.didFinish = { [weak self] in
            self?.onBoardingCoordinator = nil
            self?.start()
        }
        
        onBoardingCoordinator?.start()
    }

    private func startMenu() {
        let vc = MainTabController(serviceComponents: serviceComponents)
        UIApplication.shared.setRootView(vc)
    }

    func didFinish() {}
}
