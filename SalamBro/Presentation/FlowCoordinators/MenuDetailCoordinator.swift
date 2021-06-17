//
//  MenuDetailCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/3/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public final class MenuDetailCoordinator {
    private let disposeBag = DisposeBag()
    private let serviceComponents: ServiceComponents
    private let pagesFactory: MenuDetailPagesFactory
    private let navigationController: UINavigationController
    
    var didFinish: (() -> Void)?

    init(serviceComponents: ServiceComponents,
         pagesFactory: MenuDetailPagesFactory,
         navigationController: UINavigationController) {
        self.serviceComponents = serviceComponents
        self.pagesFactory = pagesFactory
        self.navigationController = navigationController
    }

    func start(positionUUID: String) {
        let menuDetailPage = pagesFactory.makeMenuDetailPage(positionUUID: positionUUID)
        
        menuDetailPage.outputs.didTerminate
            .subscribe(onNext: { [weak self] in
                self?.didFinish?()
        }).disposed(by: disposeBag)
        
        menuDetailPage.outputs.toModificators
            .subscribe(onNext: { [weak self] in
                self?.openModifiers(on: menuDetailPage)
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
