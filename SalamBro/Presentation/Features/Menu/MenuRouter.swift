//
//  MenuRouter.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class MenuRouter: Router {
    public enum PresentationContext {}

    public enum RouteType {
        case selectMainInfo(didSave: (() -> Void)?)
        case selectAddress(didSelectAddress: ((Address) -> Void)?)
    }

    public var baseViewController: UIViewController?

    public func present(on baseVC: UIViewController, animated _: Bool, context: Any?, completion _: (() -> Void)?) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }

        baseViewController = baseVC

        switch context {}
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
        case let .selectMainInfo(didSave):
            let router = SelectMainInformationRouter()
            let context = SelectMainInformationRouter.PresentationContext.present(didSave: didSave)
            router.present(on: baseVC, context: context)
        case let .selectAddress(didSelectAddress):
            let router = AddressPickerRouter()
            let context = AddressPickerRouter.PresentationContext.select(didSelectAddress: didSelectAddress)
            router.present(on: baseVC, context: context)
        }
    }

    public func dismiss(animated _: Bool, completion _: (() -> Void)?) {}
}
