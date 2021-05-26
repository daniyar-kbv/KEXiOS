//
//  ChangeAddressRouter.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 19.05.2021.
//

import UIKit

final class ChangeAddressRouter: Router {
    enum PresentationContext {}

    public enum RouteType {
        case map
        case brand
        case country
        case city(countryId: Int)
    }

    var baseViewController: UIViewController?
    private var context: PresentationContext?

    var selectedBrand: ((BrandUI) -> Void)?
    var selectedCountry: ((Country) -> Void)?
    var selectedCity: ((City) -> Void)?
    var selectedAddress: ((String) -> Void)?

    func present(on baseVC: UIViewController, animated _: Bool, context _: Any?, completion _: (() -> Void)?) {
        baseViewController = baseVC

        let viewModel = ChangeAddressViewModelImpl(router: self)

        let changeAddressController = ChangeAddressController(viewModel: viewModel)
        let navVC = UINavigationController(rootViewController: changeAddressController)
        baseVC.present(navVC, animated: true, completion: nil)
        baseViewController = changeAddressController
    }

    public func enqueueRoute(with context: Any?, animated _: Bool, completion _: (() -> Void)?) {
        guard let routeType = context as? RouteType else {
            assertionFailure("The route type mismatch")
            return
        }

        guard let baseVC = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }

        switch routeType {
        case .brand:
            let router = BrandsRouter()
            let context = BrandsRouter.PresentationContext.change { [weak self] selectedBrand in
                self?.selectedBrand?(selectedBrand)
            }
            router.present(on: baseVC, context: context)
        case .map:
            let mapController = MapViewController()
            mapController.modalPresentationStyle = .fullScreen
            mapController.isAddressChangeFlow = true
            mapController.selectedAddress = { [weak self] address in
                self?.selectedAddress?(address)
            }
            baseVC.present(mapController, animated: true, completion: nil)
        case .country:
            let router = CountriesListRouter()
            let context = CountriesListRouter.PresentationContext.present { [weak self] selectedCountry in
                self?.selectedCountry?(selectedCountry)
            }
            router.present(on: baseVC, context: context)
        case let .city(countryId):
            let router = CitiesListRouter()
            let context = CitiesListRouter.PresentationContext.change(countryID: countryId) { [weak self] selectedCity in
                self?.selectedCity?(selectedCity)
            }
            router.present(on: baseVC, context: context)
        }
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}
