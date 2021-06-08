//
//  AddressCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

class AddressCoordinator: Coordinator, BrandsCooridnator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!

    var flowType: FlowType

    enum FlowType {
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
        
        var brandsFlowType: BrandViewModel.FlowType {
            switch self {
            case .changeAddress(let didSelectAddress):
                return .changeAddress(didSelectAddress: didSelectAddress)
            case .changeBrand(let didSave):
                return .changeBrand(didSave: didSave)
            }
        }
    }

    init(navigationController: UINavigationController, flowType: FlowType) {
        self.navigationController = navigationController
        self.flowType = flowType
    }

    func openAddressPicker(didSelectAddress: ((Address) -> Void)?) {
        let viewModel = AddressPickerViewModel(coordinator: self,
                                               repository: DIResolver.resolve(GeoRepository.self)!,
                                               didSelectAddress: didSelectAddress)
        let vc = AddressPickController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        present(vc: nav)
    }

    func openBrands(didSelectBrand: ((Brand) -> Void)? = nil) {
        let viewModel = BrandViewModel(coordinator: self,
                                       repository: DIResolver.resolve(BrandRepository.self)!,
                                       locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                       service: DIResolver.resolve(LocationService.self)!,
                                       type: flowType.brandsFlowType,
                                       didSelectBrand: didSelectBrand)
        let vc = BrandsController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        childNavigationController = nav
        present(vc: nav)
    }

    func openMap(didSelectAddress: ((Address) -> Void)? = nil) {
        let mapPage = MapPage(viewModel: MapViewModel(flow: .change))
        mapPage.modalPresentationStyle = .fullScreen
        mapPage.selectedAddress = { address in
            didSelectAddress?(Address(name: address.name, longitude: address.longitude, latitude: address.latitude))
        }
        present(vc: mapPage)
    }

    func openSelectMainInfo(didSave: (() -> Void)? = nil) {
        let viewModel = SelectMainInformationViewModel(coordinator: self,
                                                       geoRepository: DIResolver.resolve(GeoRepository.self)!,
                                                       brandRepository: DIResolver.resolve(BrandRepository.self)!,
                                                       didSave: didSave)
        let vc = SelectMainInformationViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        present(vc: nav)
    }

    func finishFlow(completion: () -> Void) {
        completion()
    }

    func start() {
        switch flowType {
        case let .changeAddress(didSelectAddress):
            openAddressPicker(didSelectAddress: didSelectAddress)
        case let .changeBrand(didSave):
            openSelectMainInfo(didSave: didSave)
        }
    }
}

extension AddressCoordinator {
    func present(vc: UIViewController) {
        getLastPresentedViewController().present(vc, animated: true)
    }

    func push(vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
