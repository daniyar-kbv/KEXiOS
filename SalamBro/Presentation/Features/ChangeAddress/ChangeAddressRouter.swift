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
//        case city(countryId: Int)
        case map
        case brand
    }

    var baseViewController: UIViewController?
    private var context: PresentationContext?

    func present(on baseVC: UIViewController, animated _: Bool, context _: Any?, completion _: (() -> Void)?) {
        baseViewController = baseVC

        let viewModel = ChangeAddressViewModelImpl(router: self)

        let changeAddressController = ChangeAddressController(viewModel: viewModel)
        let navVC = UINavigationController(rootViewController: changeAddressController)
        baseVC.present(navVC, animated: true, completion: nil)
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
        case .brand:
            let router = BrandsRouter()
            let context = BrandsRouter.PresentationContext.select
            router.present(on: baseVC, context: context)
        case .map:
            let mapController = MapViewController()
            baseVC.navigationController?.pushViewController(mapController, animated: animated)
        }
    }

    public func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController?.dismiss(animated: animated, completion: completion)
    }
}
