//
//  MenuDetailCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public final class MenuDetailCoordinator {
    private let disposeBag = DisposeBag()
    private let serviceComponents: ServiceComponents
    private let pagesFactory: MenuDetailPagesFactory
    private let navigationController: UINavigationController

    var didFinish: (() -> Void)?

    init(serviceComponents: ServiceComponents,
         pagesFactory: MenuDetailPagesFactory,
         navigationController: UINavigationController)
    {
        self.serviceComponents = serviceComponents
        self.pagesFactory = pagesFactory
        self.navigationController = navigationController
    }

    func start(positionUUID: String) {
        let menuDetailPage = pagesFactory.makeMenuDetailPage(positionUUID: positionUUID)

        menuDetailPage.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                print("")
                self?.didFinish?()
            }).disposed(by: disposeBag)

        menuDetailPage.outputs.toModifiers
            .subscribe(onNext: { [weak self] in
                print("toModificators")
                self?.openModifiers(on: menuDetailPage)
            }, onDisposed: {
                print("toModifiers disposed")
            }).disposed(by: disposeBag)

        menuDetailPage.modalPresentationStyle = .pageSheet
        navigationController.present(menuDetailPage, animated: true)
    }

    private func openModifiers(on presentedController: UIViewController) {
        let modifiersPage = pagesFactory.makeModifiersPage()

        modifiersPage.modalPresentationStyle = .pageSheet
        presentedController.present(modifiersPage, animated: true)
    }
}
