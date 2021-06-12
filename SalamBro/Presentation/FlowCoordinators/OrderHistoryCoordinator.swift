//
//  OrderHistoryCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit

final class OrderHistoryCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = OrderHistoryController(coordinator: self)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func openRateOrder() {
        let vc = RateController()
        vc.modalPresentationStyle = .pageSheet
        getLastPresentedViewController().present(vc, animated: true, completion: nil)
    }

    func openShareOrder() {
        navigationController.pushViewController(ShareOrderController(), animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
