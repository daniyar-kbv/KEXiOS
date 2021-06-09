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
    
    var onBoardingCoordinator: OnBoardingCoordinator?

    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    private let serviceComponents: ServiceComponents

    init(serviceComponents: ServiceComponents,
         navigationController: UINavigationController,
         geoRepository: GeoRepository,
         brandRepository: BrandRepository)
    {
        self.serviceComponents = serviceComponents
        self.navigationController = navigationController
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
    }

    public func start() {
        if geoRepository.currentCity != nil,
           geoRepository.currentCountry != nil,
           brandRepository.getCurrentBrand() != nil
        {
            startMenu()
        } else {
            startFirstFlow()
        }
    }

    private func startFirstFlow() {
        onBoardingCoordinator = OnBoardingCoordinator(navigationController: UINavigationController(),
                                          pagesFactory: OnBoardingPagesFactoryImpl())
        onBoardingCoordinator?.didFinish = { [weak self] in
            self?.onBoardingCoordinator = nil
            self?.start()
        }
        
        onBoardingCoordinator?.start()
    }

    private func startMenu() {
        let vc = MainTabController()
        UIApplication.shared.setRootView(vc)
    }

    func didFinish() {}
}
