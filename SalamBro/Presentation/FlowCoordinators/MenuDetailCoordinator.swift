//
//  MenuDetailCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit

public final class MenuDetailCoordinator: LegacyCoordinator {
    var parentCoordinator: LegacyCoordinator?
    var childCoordinators: [LegacyCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MenuDetailViewModel(coordinator: self, menuDetailRepository: DIResolver.resolve(MenuDetailRepository.self)!)
        let vc = MenuDetailController(viewModel: viewModel)
        vc.modalPresentationStyle = .pageSheet
        getLastPresentedViewController().present(vc, animated: true, completion: nil)
    }

    func openModificator() {
        let vc = AdditionalItemController()
        vc.modalPresentationStyle = .pageSheet
        getLastPresentedViewController().present(vc, animated: true, completion: nil)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
