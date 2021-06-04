//
//  AddressCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit

class AddressCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!

    var flowType: FlowType

    enum FlowType {
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeMainInfo(didSave: (() -> Void)?)
        case firstFlow
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

    // Old realization with presents
    func openChangeAddress() {
        let viewModel = ChangeAddressViewModelImpl(coordinator: self)
        let changeAddressController = ChangeAddressController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: changeAddressController)
        present(vc: nav)
    }

    func openCountriesList(didSelectCountry: ((Country) -> Void)? = nil) {
        let viewModel = CountriesListViewModel(
            coordinator: self,
            service: DIResolver.resolve(LocationService.self)!,
            repository: DIResolver.resolve(LocationRepository.self)!,
            type: flowType,
            didSelectCountry: didSelectCountry
        )
        let vc = CountriesListController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: vc)
        navigationController = nav
        UIApplication.shared.setRootView(nav)
    }

    func openCitiesList(countryId: Int, didSelectCity: ((City) -> Void)? = nil) {
        let viewModel = CitiesListViewModel(coordinator: self,
                                            type: flowType,
                                            countryId: countryId,
                                            service: DIResolver.resolve(LocationService.self)!,
                                            repository: DIResolver.resolve(LocationRepository.self)!,
                                            didSelectCity: didSelectCity)
        let vc = CitiesListController(viewModel: viewModel)
        push(vc: vc)
    }

    func openBrands(didSelectBrand: ((Brand) -> Void)? = nil) {
        let viewModel = BrandViewModel(coordinator: self,
                                       repository: DIResolver.resolve(BrandRepository.self)!,
                                       locationRepository: DIResolver.resolve(LocationRepository.self)!,
                                       service: DIResolver.resolve(LocationService.self)!,
                                       type: flowType,
                                       didSelectBrand: didSelectBrand)
        let vc = BrandsController(viewModel: viewModel)
        switch flowType {
        case .changeAddress, .changeMainInfo:
            let nav = UINavigationController(rootViewController: vc)
            childNavigationController = nav
            present(vc: nav)
        case .firstFlow:
            push(vc: vc)
        }
    }

    func openMap(didSelectAddress: ((String) -> Void)? = nil) {
        var mapPage: MapPage

        switch flowType {
        case .changeAddress, .changeMainInfo:
            mapPage = MapPage(viewModel: MapViewModel(flow: .change))
            mapPage.modalPresentationStyle = .fullScreen
            mapPage.selectedAddress = { address in
                didSelectAddress?(address.name)
            }
            present(vc: mapPage)
        case .firstFlow:
            mapPage = MapPage(viewModel: MapViewModel(flow: .creation))
            mapPage.selectedAddress = { address in
                didSelectAddress?(address.name)
            }
            push(vc: mapPage)
        }
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
        switch flowType {
        case .firstFlow:
            // TODO: Change to new DI
            let appCoordinator = DIResolver.resolve(AppCoordinator.self)!
            appCoordinator.start()
        default:
            break
        }
        completion()
    }

    func start() {
        switch flowType {
        case .firstFlow:
            openCountriesList()
        case let .changeAddress(didSelectAddress):
            openAddressPicker(didSelectAddress: didSelectAddress)
        case let .changeMainInfo(didSave):
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
