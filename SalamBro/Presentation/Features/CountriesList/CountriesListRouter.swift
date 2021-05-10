//
//  CountriesListRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class CountriesListRouter: Router {
    public enum PresentationContext {
        case present(didSelectCountry: ((CountryUI) -> Void)?)
    }

    public enum RouteType {
        case cities(countryId: Int)
    }

    public var baseViewController: UIViewController?

    public func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {
        case let .present(didSelectCountry):
            let viewModel = CountriesListViewModel(router: self,
                                                   repository: DIResolver.resolve(GeoRepository.self)!,
                                                   type: .change,
                                                   didSelectCountry: didSelectCountry)
            let vc = CountriesListController(viewModel: viewModel)
            baseVC.present(vc, animated: animated, completion: completion)
        }
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
        case let .cities(id):
            let router = CitiesListRouter()
            let context = CitiesListRouter.PresentationContext.select(countryID: id)
            router.present(on: baseVC, context: context)
        }
    }

    public func dismiss(animated _: Bool, completion _: (() -> Void)?) {}
}
