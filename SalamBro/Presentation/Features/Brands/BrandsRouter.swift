//
//  BrandsRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

final class BrandsRouter: Router {
    enum PresentationContext {
        case change(didSelectBrand: ((Brand) -> Void)?)
        case select
    }

    enum RouteType {
        case map
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
        case let .change(didSelectBrand):
            let viewModel = BrandViewModel(router: self,
                                           repository: DIResolver.resolve(BrandRepository.self)!,
                                           locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                           service: DIResolver.resolve(LocationService.self)!,
                                           type: .change,
                                           didSelectBrand: didSelectBrand)
            let vc = BrandsController(viewModel: viewModel)
            let navVC = UINavigationController(rootViewController: vc)
            baseVC.present(navVC, animated: animated, completion: completion)
        case .select:
            // TODO: change to coordinators
            guard let baseVC = baseVC as? UINavigationController else { return }
            let viewModel = BrandViewModel(router: self,
                                           repository: DIResolver.resolve(BrandRepository.self)!,
                                           locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                           service: DIResolver.resolve(LocationService.self)!,
                                           type: .select,
                                           didSelectBrand: nil)
            let vc = BrandsController(viewModel: viewModel)
            baseVC.pushViewController(vc, animated: animated)
        }
    }

    func enqueueRoute(with context: Any?, animated: Bool, completion _: (() -> Void)?) {
        guard let routeType = context as? RouteType else {
            assertionFailure("The route type mismatch")
            return
        }

        guard let baseVC = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }

        switch routeType {
        case .map:
            guard let baseVC = baseVC as? UINavigationController else { return }
            let vc = MapViewController()
            baseVC.pushViewController(vc, animated: animated)
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
