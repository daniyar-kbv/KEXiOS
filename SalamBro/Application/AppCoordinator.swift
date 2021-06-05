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

    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    init(navigationController: UINavigationController, geoRepository: GeoRepository, brandRepository: BrandRepository) {
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
        let child = AddressCoordinator(navigationController: navigationController, flowType: .firstFlow)
        child.start()
    }

    private func startMenu() {
        let vc = MainTabController()
        UIApplication.shared.setRootView(vc)
    }

    func didFinish() {}
}
