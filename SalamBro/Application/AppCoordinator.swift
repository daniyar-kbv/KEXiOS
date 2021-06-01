//
//  AppCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
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
//        let router = CountriesListRouter()
//        let viewModel = CountriesListViewModel(router: router,
//                                               service: DIResolver.resolve(LocationService.self)!,
//                                               repository: DIResolver.resolve(LocationRepository.self)!,
//                                               type: .select,
//                                               didSelectCountry: nil)
//        let vc = CountriesListController(viewModel: viewModel)
//        router.baseViewController = vc
//        let navVC = UINavigationController(rootViewController: vc)
//        setRootView(navVC)
        let child = CountriesListCoordinator(type: .select)
        child.start()
    }

    private func startMenu() {
        let vc = MainTabController()
        UIApplication.shared.setRootView(vc)
    }
}
