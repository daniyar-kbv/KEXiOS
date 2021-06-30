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

public final class MenuDetailCoordinator: Coordinator {
    private let disposeBag = DisposeBag()

    private let router: Router
    private let serviceComponents: ServiceComponents
    private let pagesFactory: MenuDetailPagesFactory
    private let positionUUID: String

    var didFinish: (() -> Void)?

    init(router: Router,
         serviceComponents: ServiceComponents,
         pagesFactory: MenuDetailPagesFactory,
         positionUUID: String)
    {
        self.router = router
        self.serviceComponents = serviceComponents
        self.pagesFactory = pagesFactory
        self.positionUUID = positionUUID
    }

    func start() {
        let menuDetailPage = pagesFactory.makeMenuDetailPage(positionUUID: positionUUID)

        menuDetailPage.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.didFinish?()
            }).disposed(by: disposeBag)

        menuDetailPage.outputs.close
            .subscribe(onNext: {
                menuDetailPage.dismiss(animated: true)
            }).disposed(by: disposeBag)

        menuDetailPage.outputs.toModifiers
            .subscribe(onNext: { [weak self] modifierGroup, indexPath in
                self?.openModifiers(on: menuDetailPage,
                                    modifierGroup: modifierGroup) { modifier in
                    menuDetailPage.set(modifier: modifier, at: indexPath)
                }
            }, onDisposed: {}).disposed(by: disposeBag)

        menuDetailPage.modalPresentationStyle = .pageSheet
        router.present(menuDetailPage, animated: true, completion: nil)
    }

    private func openModifiers(on presentedController: UIViewController,
                               modifierGroup _: ModifierGroup,
                               onSelect _: (Modifier) -> Void)
    {
        let modifiersPage = pagesFactory.makeModifiersPage()

        modifiersPage.modalPresentationStyle = .pageSheet
        presentedController.present(modifiersPage, animated: true)
    }
}
