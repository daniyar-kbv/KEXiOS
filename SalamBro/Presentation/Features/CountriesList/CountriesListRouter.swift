//
//  CountriesListRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

final class CountriesListRouter: Router {
    enum PresentationContext {
        case present(didSelectCountry: ((Country) -> Void)?)
    }

    enum RouteType {
        case cities(countryId: Int)
    }

    var baseViewController: UIViewController?

    func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {
        case let .present(didSelectCountry):
            let viewModel = CountriesListViewModel(router: self,
                                                   service: DIResolver.resolve(LocationService.self)!,
                                                   repository: DIResolver.resolve(LocationRepository.self)!,
                                                   type: .change,
                                                   didSelectCountry: didSelectCountry)
            let vc = CountriesListController(viewModel: viewModel)
            let navVC = UINavigationController(rootViewController: vc)
            baseVC.present(navVC, animated: animated, completion: completion)
        }
    }

    func enqueueRoute(with context: Any?, animated _: Bool, completion _: (() -> Void)?) {
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

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}
