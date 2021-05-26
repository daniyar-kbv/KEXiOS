//
//  CitiesListRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

final class CitiesListRouter: Router {
    enum PresentationContext {
        case change(countryID: Int, didSelectCity: ((City) -> Void)?)
        case select(countryID: Int)
    }

    enum RouteType {
        case brands
    }

    var baseViewController: UIViewController?
    private var context: PresentationContext?

    func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC
        self.context = context

        switch context {
        case let .change(countryId, didSelectCity):
            let viewModel = CitiesListViewModel(router: self,
                                                type: .change,
                                                countryId: countryId,
                                                service: DIResolver.resolve(LocationService.self)!,
                                                repository: DIResolver.resolve(LocationRepository.self)!,
                                                didSelectCity: didSelectCity)
            let vc = CitiesListController(viewModel: viewModel)
            let navVC = UINavigationController(rootViewController: vc)
            baseVC.present(navVC, animated: animated, completion: completion)
        case let .select(countryId):
            let viewModel = CitiesListViewModel(router: self,
                                                type: .select,
                                                countryId: countryId,
                                                service: DIResolver.resolve(LocationService.self)!,
                                                repository: DIResolver.resolve(LocationRepository.self)!,
                                                didSelectCity: nil)
            let vc = CitiesListController(viewModel: viewModel)
            baseVC.navigationController?.pushViewController(vc, animated: animated)
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
        case .brands:
            let router = BrandsRouter()
            let context = BrandsRouter.PresentationContext.select
            router.present(on: baseVC, context: context)
        }
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        switch context {
        case .change:
            baseViewController?.dismiss(animated: animated, completion: completion)
        case .select:
            baseViewController?.navigationController?.popViewController(animated: animated)
        default:
            break
        }
    }
}
