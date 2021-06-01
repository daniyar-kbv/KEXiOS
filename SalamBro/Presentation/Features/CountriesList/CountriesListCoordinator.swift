//
//  CountriesListCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

class CountriesListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var type: CountriesListViewModel.FlowType
    var didSelectCountry: ((Country) -> Void)?
    
    init(navigationController: UINavigationController = UINavigationController(), type: CountriesListViewModel.FlowType = .select, didSelectCountry: ((Country) -> Void)? = nil) {
        self.type = type
        self.didSelectCountry = didSelectCountry
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = CountriesListViewModel(
            coordinator: self,
            service: DIResolver.resolve(LocationService.self)!,
            repository: DIResolver.resolve(LocationRepository.self)!,
            type: type,
            didSelectCountry: didSelectCountry
        )
        let vc = CountriesListController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        switch type {
        case .change:
            navigationController.present(nav, animated: true)
        case .select:
            let nav = UINavigationController(rootViewController: vc)
            navigationController = nav
            UIApplication.shared.setRootView(nav)
        }
    }
    
    func openCities(countryId: Int) {
        let router = CitiesListRouter()
        let context = CitiesListRouter.PresentationContext.select(countryID: countryId)
        router.baseViewController = navigationController
        router.present(on: navigationController, context: context)
    }
    
    func onClose() {
        navigationController.dismiss(animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
