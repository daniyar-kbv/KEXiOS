//
//  AddressListCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class AddressListCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private let router: Router
    private var pagesFactory: AddressListPagesFactory

    var didFinish: (() -> Void)?

    init(router: Router,
         pagesFactory: AddressListPagesFactory)
    {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let listPage = pagesFactory.makeAddressListPage()

        listPage.outputs.didTerminate.subscribe(onNext: { [weak self] _ in
            self?.didFinish?()
        }).disposed(by: disposeBag)

        listPage.outputs.didSelectAddress.subscribe(onNext: { [weak self] params in
            self?.openDetail(deliveryAddress: params.0, onUpdate: params.1)
        }).disposed(by: disposeBag)

        listPage.hidesBottomBarWhenPushed = true
        router.push(viewController: listPage, animated: true)
    }

    func openDetail(deliveryAddress: DeliveryAddress, onUpdate: @escaping () -> Void) {
        let detailPage = pagesFactory.makeAddressDetailPage(deliveryAddress: deliveryAddress)

        detailPage.outputs.didDeleteAddress.subscribe(onNext: { [weak self] in
            onUpdate()
            self?.router.pop(animated: true)
        }).disposed(by: disposeBag)

        router.push(viewController: detailPage, animated: true)
    }
}
