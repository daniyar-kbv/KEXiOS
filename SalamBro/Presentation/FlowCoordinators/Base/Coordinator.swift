//
//  Coordinator.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 13.06.2021.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []

    func start() {}

    func add(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

    func remove(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else { return }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
