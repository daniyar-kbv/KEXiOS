//
//  FirstFlowCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/6/21.
//

import Foundation
import UIKit


protocol BrandsCooridnator: Coordinator {
    func openMap(didSelectAddress: ((Address) -> Void)?)
}


class FirstFlowCoordinator: Coordinator, BrandsCooridnator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openCitiesList(countryId: Int) {
        let viewModel = CitiesListViewModel(coordinator: self,
                                            countryId: countryId,
                                            service: DIResolver.resolve(LocationService.self)!,
                                            repository: DIResolver.resolve(LocationRepository.self)!)
        let vc = CitiesListController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func openBrands(didSelectBrand: ((Brand) -> Void)? = nil) {
        let viewModel = BrandViewModel(coordinator: self,
                                       repository: DIResolver.resolve(BrandRepository.self)!,
                                       locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                       service: DIResolver.resolve(LocationService.self)!,
                                       type: .firstFlow,
                                       didSelectBrand: didSelectBrand)
        let vc = BrandsController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func openMap(didSelectAddress: ((Address) -> Void)? = nil) {
        let mapPage = MapPage(viewModel: MapViewModel(flow: .creation))
        mapPage.selectedAddress = { [weak self] address in
            self?.finishFlow()
            let geoRepository = DIResolver.resolve(GeoRepository.self)
            geoRepository?.currentAddress = Address(name: address.name, longitude: address.longitude, latitude: address.latitude)
        }
        navigationController.pushViewController(mapPage, animated: true)
    }
    
    func finishFlow() {
        let appCoordinator = DIResolver.resolve(AppCoordinator.self)!
        appCoordinator.start()
        navigationController.viewControllers.removeAll()
    }
    
    func start() {
        let viewModel = CountriesListViewModel(
            coordinator: self,
            service: DIResolver.resolve(LocationService.self)!,
            repository: DIResolver.resolve(LocationRepository.self)!
        )
        let vc = CountriesListController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        navigationController = nav
        UIApplication.shared.setRootView(nav)
    }
    
    func didFinish() { }
}
