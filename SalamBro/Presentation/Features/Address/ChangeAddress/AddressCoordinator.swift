//
//  AddressCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class AddressCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    private let pagesFactory: AddressPagesFactory

    var router: Router
    var flowType: FlowType
    var didFinish: (() -> Void)?

    init(router: Router,
         pagesFactory: AddressPagesFactory,
         flowType: FlowType)
    {
        self.router = router
        self.pagesFactory = pagesFactory
        self.flowType = flowType
    }

    func start() {
        switch flowType {
        case let .changeAddress(didSelectAddress):
            openAddressPicker(didSelectAddress: didSelectAddress)
        case let .changeBrand(didSave, presentOn):
            openSelectMainInfo(flowType: .changeBrand, didSave: didSave, presentOn: presentOn)
        }
    }

    private func openAddressPicker(didSelectAddress: (() -> Void)?) {
        let addressPickPage = pagesFactory.makeAddressPickPage()

        addressPickPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)

        addressPickPage.outputs.didSelectAddress.subscribe(onNext: { [weak self] address in
            self?.openSelectMainInfo(flowType: .changeAddress(address.0),
                                     didSave: {
                                         didSelectAddress?()
                                         address.1()
                                     }, presentOn: addressPickPage)
        }).disposed(by: disposeBag)

        addressPickPage.outputs.didAddTapped.subscribe(onNext: { [weak self] onAdd in
            self?.openSelectMainInfo(flowType: .create,
                                     didSave: {
                                         didSelectAddress?()
                                         onAdd()
                                     }, presentOn: addressPickPage)
        }).disposed(by: disposeBag)

        addressPickPage.outputs.close.subscribe(onNext: {
            addressPickPage.dismiss(animated: true)
        }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: addressPickPage)
        router.present(nav, animated: true, completion: nil)
    }

    private func openSelectMainInfo(flowType: SelectMainInformationViewModel.FlowType,
                                    didSave: (() -> Void)? = nil,
                                    presentOn: UIViewController)
    {
        let selectMainInfoPage = pagesFactory.makeSelectMainInfoPage(flowType: flowType)

        selectMainInfoPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.toMap.subscribe(onNext: { [weak self] params in
            self?.openMap(address: params.0, params.1, presentOn: selectMainInfoPage)
        }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.toBrands.subscribe(onNext: { [weak self] cityId, onSelectBrand in
            self?.openBrands(cityId: cityId, onSelectBrand, presentOn: selectMainInfoPage)
        }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.didSave.subscribe(onNext: {
            didSave?()
            selectMainInfoPage.dismiss(animated: true)
        }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.close.subscribe(onNext: {
            selectMainInfoPage.dismiss(animated: true)
        }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: selectMainInfoPage)
        presentOn.present(nav, animated: true)
    }

    private func openMap(address: Address?,
                         _ onSelectAddress: @escaping (Address) -> Void,
                         presentOn: UIViewController)
    {
        let mapPage = pagesFactory.makeMapPage(address: address)

        mapPage.selectedAddress = { address in
            onSelectAddress(address)
            mapPage.dismiss(animated: true)
        }

        mapPage.modalPresentationStyle = .fullScreen
        presentOn.present(mapPage, animated: true)
    }

    private func openBrands(cityId: Int,
                            _ onSelectBrand: @escaping (Brand) -> Void,
                            presentOn: UIViewController)
    {
        let brandsPage = pagesFactory.makeBrandsPage(cityId: cityId)

        brandsPage.outputs.didSelectBrand.subscribe(onNext: { brand in
            onSelectBrand(brand)
        }).disposed(by: disposeBag)

        brandsPage.outputs.close.subscribe(onNext: {
            brandsPage.dismiss(animated: true)
        }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: brandsPage)
        presentOn.present(nav, animated: true)
    }

    func finishFlow(completion: () -> Void) {
        completion()
    }
}

extension AddressCoordinator {
    enum FlowType {
        case changeAddress(didSelectAddress: (() -> Void)?)
        case changeBrand(didSave: (() -> Void)?, presentOn: UIViewController)
    }
}
