//
//  File.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

class ChangeAddressCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var innerNavigationController: UINavigationController!
    
    var selectedBrand: ((Brand) -> Void)?
    var selectedCountry: ((Country) -> Void)?
    var selectedCity: ((City) -> Void)?
    var selectedAddress: ((String) -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ChangeAddressViewModelImpl(coordinator: self)
        let changeAddressController = ChangeAddressController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: changeAddressController)
        innerNavigationController = nav
        navigationController.present(nav, animated: true)
    }
    
    func openCountries() {
        let child = CountriesListCoordinator(navigationController: innerNavigationController, type: .change) { [weak self] selectedCountry in
            self?.selectedCountry?(selectedCountry)
        }
        child.start()
    }
    
    func openCities(countryId: Int) {
        let router = CitiesListRouter()
        let context = CitiesListRouter.PresentationContext.change(countryID: countryId) { [weak self] selectedCity in
            self?.selectedCity?(selectedCity)
        }
        router.present(on: navigationController, context: context)
    }
    
    func openMap() {
        let mapController = MapViewController()
        mapController.modalPresentationStyle = .fullScreen
        mapController.isAddressChangeFlow = true
        mapController.selectedAddress = { [weak self] address in
            self?.selectedAddress?(address)
        }
        navigationController.present(mapController, animated: true, completion: nil)
    }
    
    func openBrand() {
        let router = BrandsRouter()
        let context = BrandsRouter.PresentationContext.change { [weak self] selectedBrand in
            self?.selectedBrand?(selectedBrand)
        }
        router.present(on: navigationController, context: context)
    }
    
    func onFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
