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

    weak var addressPickPage: AddressPickController?

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
        case .changeAddress:
            openAddressPicker()
        case let .changeBrand(presentOn):
            openSelectMainInfo(flowType: .changeBrand, presentOn: presentOn)
        }
    }

    private func openAddressPicker() {
        let addressPickPage = pagesFactory.makeAddressPickPage()

        self.addressPickPage = addressPickPage

        addressPickPage.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.didFinish?()
            }).disposed(by: disposeBag)

        addressPickPage.outputs.didSelectAddress
            .subscribe(onNext: { [weak self, weak addressPickPage] address in
                self?.openSelectMainInfo(flowType: .changeAddress(address.0),
                                         presentOn: addressPickPage)
            }).disposed(by: disposeBag)

        addressPickPage.outputs.didAddTapped
            .subscribe(onNext: { [weak self, weak addressPickPage] _ in
                self?.openSelectMainInfo(flowType: .create,
                                         presentOn: addressPickPage)
            }).disposed(by: disposeBag)

        addressPickPage.outputs.close
            .subscribe(onNext: { [weak addressPickPage] in
                addressPickPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        addressPickPage.outputs.finishFlow
            .subscribe(onNext: { [weak self] in
                self?.router.dismissAll(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: addressPickPage)
        router.present(nav, animated: true, completion: nil)
    }

    private func openSelectMainInfo(flowType: SelectMainInformationViewModel.FlowType,
                                    presentOn: UIViewController?)
    {
        let selectMainInfoPage = pagesFactory.makeSelectMainInfoPage(flowType: flowType)

        selectMainInfoPage.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.didFinish?()
            }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.toMap
            .subscribe(onNext: { [weak self, weak selectMainInfoPage] params in
                self?.openMap(userAddress: params.userAddress,
                              params.onSelect,
                              presentOn: selectMainInfoPage)
            }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.toBrands
            .subscribe(onNext: { [weak self, weak selectMainInfoPage] cityId, onSelectBrand in
                self?.openBrands(cityId: cityId, onSelectBrand, presentOn: selectMainInfoPage)
            }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.didSave
            .subscribe(onNext: { [weak selectMainInfoPage] in
                selectMainInfoPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.close
            .subscribe(onNext: { [weak selectMainInfoPage] in
                selectMainInfoPage?.dismiss(animated: true)
            }).disposed(by: disposeBag)

        selectMainInfoPage.outputs.finishFlow
            .subscribe(onNext: { [weak self] in
                self?.router.dismissAll(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: selectMainInfoPage)
        presentOn?.present(nav, animated: true)
    }

    private func openMap(userAddress: UserAddress,
                         _ onSelectAddress: @escaping (Address) -> Void,
                         presentOn: UIViewController?)
    {
        let mapPage = pagesFactory.makeMapPage(userAddress: userAddress)

        mapPage.selectedAddress = { [weak mapPage] address in
            onSelectAddress(address)
            mapPage?.dismiss(animated: true)
        }

        mapPage.modalPresentationStyle = .fullScreen
        presentOn?.present(mapPage, animated: true)
    }

    private func openBrands(cityId: Int,
                            _ onSelectBrand: @escaping (Brand) -> Void,
                            presentOn: UIViewController?)
    {
        let brandsPage = pagesFactory.makeBrandsPage(cityId: cityId)

        brandsPage.outputs.didSelectBrand.subscribe(onNext: { [weak brandsPage] brand in
            onSelectBrand(brand)
            brandsPage?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        brandsPage.outputs.close.subscribe(onNext: { [weak brandsPage] in
            brandsPage?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        let nav = SBNavigationController(rootViewController: brandsPage)
        presentOn?.present(nav, animated: true)
    }

    func finishFlow(completion: () -> Void) {
        completion()
    }
}

extension AddressCoordinator {
    enum FlowType {
        case changeAddress
        case changeBrand(presentOn: UIViewController)
    }
}
