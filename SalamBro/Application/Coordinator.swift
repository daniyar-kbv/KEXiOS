//
//  Coordinator.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func alert(error: Error, closeHandler: (() -> Void)? = nil) {
        let router = AlertRouter()
        let context = AlertRouter.PresentationContext.error(message: error.localizedDescription, closeHandler: closeHandler)
        router.present(on: navigationController, animated: true, context: context, completion: nil)
    }

    func alert(title: String, message: String, closeHandler: (() -> Void)? = nil) {
        let router = AlertRouter()
        let context = AlertRouter.PresentationContext.default(title: title, message: message, closeHandler: closeHandler)
        router.present(on: navigationController, animated: true, context: context, completion: nil)
    }
}
