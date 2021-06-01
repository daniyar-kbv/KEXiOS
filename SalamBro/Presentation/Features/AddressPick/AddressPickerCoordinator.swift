//
//  AddressPickerCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/1/21.
//

import Foundation
import UIKit

class AddressPickerCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var didSelectAddress: ((Address) -> Void)?
    weak var innerNavigationControler: UINavigationController!
    
    init(navigationController: UINavigationController, didSelectAddress: ((Address) -> Void)?) {
        self.navigationController = navigationController
        self.didSelectAddress = didSelectAddress
    }
    
    func start() {
        let viewModel = AddressPickerViewModel(coordinator: self,
                                               repository: DIResolver.resolve(GeoRepository.self)!,
                                               didSelectAddress: didSelectAddress)
        let vc = AddressPickController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        innerNavigationControler = nav
        navigationController.present(nav, animated: true)
    }
    
    func openChangeAddress() {
        let child = ChangeAddressCoordinator(navigationController: innerNavigationControler)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func onFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
