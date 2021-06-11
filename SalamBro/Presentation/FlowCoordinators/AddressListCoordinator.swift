//
//  AddressListCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class AddressListCoordinator {
    private let disposeBag = DisposeBag()
    private var navigationController: UINavigationController
    private var pagesFactory: AddressListPagesFactory
    
    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController,
         pagesFactory: AddressListPagesFactory) {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
    }

    func start() {
        let listPage = pagesFactory.makeAddressListPage()
        
        listPage.outputs.didTerminate.subscribe(onNext: { [weak self] object in
            self?.didFinish?()
        }).disposed(by: disposeBag)
        
        listPage.outputs.didSelectAddress.subscribe(onNext: { [weak self] params in
            self?.openDetail(deliveryAddress: params.0, onUpdate: params.1)
        }).disposed(by: disposeBag)
        
        listPage.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(listPage, animated: true)
    }
    
    func openDetail(deliveryAddress: DeliveryAddress, onUpdate: @escaping () -> Void) {
        let detailPage = pagesFactory.makeAddressDetailPage(deliveryAddress: deliveryAddress)
        
        detailPage.outputs.didDeleteAddress.subscribe(onNext: { [weak self] in
            onUpdate()
            self?.navigationController.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        navigationController.pushViewController(detailPage, animated: true)
    }
}
