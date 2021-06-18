//
//  RatingCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit

// MARK: Tech debt

final class RatingCoordinator: LegacyCoordinator {
    var parentCoordinator: LegacyCoordinator?
    var childCoordinators: [LegacyCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func openAgreement() {
        let vc = AgreementController(viewModel: AgreementViewModelImpl())
        navigationController.pushViewController(vc, animated: true)
    }

    func start() {
        let vc = RatingController(coordinator: self)
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
