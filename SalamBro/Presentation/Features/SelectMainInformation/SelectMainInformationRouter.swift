//
//  SelectMainInformationRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class SelectMainInformationRouter: Router {
    public enum PresentationContext {
        case present(didSave: (() -> Void)?)
    }

    public enum RouteType {
        case selectBrand(didSelectBrand: (BrandUI) -> Void)
        case selectAddress(didSelectAddress: ((Address) -> Void)?)
    }

    public var baseViewController: UIViewController?

    public func present(on baseVC: UIViewController,
                        animated: Bool,
                        context: Any?,
                        completion: (() -> Void)?)
    {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {
        case let .present(didSave): break
            let viewModel = SelectMainInformationViewModel(router: self,
                                                           geoRepository: DIResolver.resolve(GeoRepository.self)!,
                                                           brandRepository: DIResolver.resolve(BrandRepository.self)!,
                                                           didSave: didSave)
            let vc = SelectMainInformationViewController(viewModel: viewModel)
            let navVC = UINavigationController(rootViewController: vc)
            baseViewController = vc
            baseVC.present(navVC, animated: animated, completion: completion)
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
        case let .selectBrand(didSelectBrand):
            let router = BrandsRouter()
            let context = BrandsRouter.PresentationContext.change(didSelectBrand: didSelectBrand)
            router.present(on: baseVC, context: context)
        case let .selectAddress(didSelectAddress):
            let router = AddressPickerRouter()
            let context = AddressPickerRouter.PresentationContext.select(didSelectAddress: didSelectAddress)
            router.present(on: baseVC, context: context)
        }
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.navigationController?.dismiss(animated: animated, completion: completion)
    }
}
