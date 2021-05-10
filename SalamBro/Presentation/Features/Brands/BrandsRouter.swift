//
//  BrandsRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class BrandsRouter: Router {
    public enum PresentationContext {
        case change(didSelectBrand: ((BrandUI) -> Void)?)
        case select
    }

    public enum RouteType {
        case map
    }

    public var baseViewController: UIViewController?
    private var context: PresentationContext?

    public func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: (() -> Void)?) {
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
                                           type: .change,
                                           didSelectBrand: didSelectBrand)
            let vc = BrandsController(viewModel: viewModel)
            baseVC.present(vc, animated: animated, completion: completion)
        case .select:
            let viewModel = BrandViewModel(router: self,
                                           repository: DIResolver.resolve(BrandRepository.self)!,
                                           type: .select,
                                           didSelectBrand: nil)
            let vc = BrandsController(viewModel: viewModel)
            baseVC.navigationController?.pushViewController(vc, animated: animated)
        }
    }

    public func enqueueRoute(with context: Any?, animated: Bool, completion _: (() -> Void)?) {
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
            let vc = MapViewController()
            baseVC.navigationController?.pushViewController(vc, animated: animated)
        }
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
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
