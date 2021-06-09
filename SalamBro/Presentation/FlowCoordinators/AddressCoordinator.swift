//
//  AddressCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddressCoordinator {
    private let disposeBag = DisposeBag()
    private let pagesFactory: AddressPagesFactory
    
    var navigationController: UINavigationController
    var flowType: FlowType
    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController,
         pagesFactory: AddressPagesFactory,
         flowType: FlowType) {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
        self.flowType = flowType
    }

    func start() {
        switch flowType {
        case let .changeAddress(didSelectAddress):
            openAddressPicker(didSelectAddress: didSelectAddress)
        case let .changeBrand(didSave):
            openSelectMainInfo(flowType: .changeBrand, didSave: didSave)
        }
    }

    private func openAddressPicker(didSelectAddress: (() -> Void)?) {
        let addressPickPage = pagesFactory.makeAddressPickPage()
        
        addressPickPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)
        
        addressPickPage.outputs.didSelectAddress.subscribe(onNext: { [weak self] address in
            self?.openSelectMainInfo(flowType: .changeAddress(address.0), didSave: { [weak self] in
                didSelectAddress?()
                address.1()
            })
        }).disposed(by: disposeBag)
        
        addressPickPage.outputs.didAddTapped.subscribe(onNext: { [weak self] onAdd in
            self?.openSelectMainInfo(flowType: .create, didSave: { [weak self] in
                didSelectAddress?()
                onAdd()
            })
        }).disposed(by: disposeBag)
        
        let nav = UINavigationController(rootViewController: addressPickPage)
        present(vc: nav)
    }
    
    private func openSelectMainInfo(flowType: SelectMainInformationViewModel.FlowType,
                                    didSave: (() -> Void)? = nil) {
        let selectMainInfoPage = pagesFactory.makeSelectMainInfoPage(flowType: flowType)
        
        selectMainInfoPage.outputs.didTerminate.subscribe(onNext: { [weak self] in
            self?.didFinish?()
        }).disposed(by: disposeBag)
        
        selectMainInfoPage.outputs.toMap.subscribe(onNext: { [weak self] onSelectAddress in
            self?.openMap(onSelectAddress)
        }).disposed(by: disposeBag)
        
        selectMainInfoPage.outputs.toBrands.subscribe(onNext: { [weak self] onSelectBrand in
            self?.openBrands(onSelectBrand)
        }).disposed(by: disposeBag)
        
        selectMainInfoPage.outputs.didSave.subscribe(onNext: { [weak self] in
            didSave?()
            selectMainInfoPage.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        let nav = UINavigationController(rootViewController: selectMainInfoPage)
        present(vc: nav)
    }
    
    private func openMap(_ onSelectAddress: @escaping (Address) -> Void) {
        let mapPage = pagesFactory.makeMapPage()
        
        mapPage.selectedAddress = { [weak self] address in
            onSelectAddress(Address(name: address.name, longitude: address.longitude, latitude: address.latitude))
            mapPage.dismiss(animated: true)
        }
        
        mapPage.modalPresentationStyle = .fullScreen
        present(vc: mapPage)
    }
    
    private func openBrands(_ onSelectBrand: @escaping (Brand) -> Void) {
        let brandsPage = pagesFactory.makeBrandsPage()
        
        brandsPage.outputs.didSelectBrand.subscribe(onNext: { [weak self] brand in
            onSelectBrand(brand)
        }).disposed(by: disposeBag)
        
        let nav = UINavigationController(rootViewController: brandsPage)
        present(vc: nav)
    }
    
    func finishFlow(completion: () -> Void) {
        completion()
    }
}

extension AddressCoordinator {
    func getLastPresentedViewController() -> UIViewController {
        var parentVc: UIViewController = navigationController
        var childVc: UIViewController? = navigationController.presentedViewController
        while childVc != nil {
            parentVc = childVc!
            childVc = parentVc.presentedViewController
        }
        return parentVc
    }
    
    func present(vc: UIViewController) {
        getLastPresentedViewController().present(vc, animated: true)
    }
}

extension AddressCoordinator {
    enum FlowType {
        case changeAddress(didSelectAddress: (() -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
    }
}
