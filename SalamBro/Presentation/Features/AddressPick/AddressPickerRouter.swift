//
//  AddressPickerRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class AddressPickerRouter: Router {
    public enum PresentationContext {
        case select(didSelectAddress: ((Address) -> Void)?)
    }

    public enum RouteType {}

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
        case let .select(didSelectAddress):
            let viewModel = AddressPickerViewModel(router: self,
                                                   repository: DIResolver.resolve(GeoRepository.self)!,
                                                   didSelectAddress: didSelectAddress)
            let vc = AddressPickController(viewModel: viewModel)
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

        switch routeType {}
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}
