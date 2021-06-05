//
//  AddressListCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit

class AddressListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openDetail(address: String) {
        let vc = AddressDetailController()
        vc.addressLabel.text = address
        vc.commentaryLabel.text = "Квартира, подъезд, домофон, этаж, и очень длинный комментарий примерно в две"
        navigationController.pushViewController(vc, animated: true)
    }

    func start() {
        let vc = AddressListController(coordinator: self)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
