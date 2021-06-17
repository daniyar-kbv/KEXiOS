//
//  MenuCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/2/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MenuCoordinator: TabCoordinator {
    private let disposeBag = DisposeBag()
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var childNavigationController: UINavigationController!
    var tabType: TabBarCoordinator.TabType
    
    private var serviceComponents: ServiceComponents
    private var pagesFactory: MenuPagesFactory
    
    private var addressCoordinator: AddressCoordinator?
    private var promotionsCoordinator: PromotionsCoordinator?
    private var menuDetailCoordinator: MenuDetailCoordinator?

    init(serviceComponents: ServiceComponents,
         pagesFactory: MenuPagesFactory,
         navigationController: UINavigationController,
         tabType: TabBarCoordinator.TabType) {
        self.serviceComponents = serviceComponents
        self.pagesFactory = pagesFactory
        
        self.navigationController = navigationController
        self.tabType = tabType
    }

    func start() {
        let menuPage = pagesFactory.makeManuPage()
        
        menuPage.outputs.toChangeBrand
            .subscribe(onNext: { [weak self] didSave in
                self?.openChangeBrand(didSave: didSave)
            }).disposed(by: disposeBag)
        
        menuPage.outputs.toAddressess
            .subscribe(onNext: { [weak self] didSave in
                self?.openChangeAddress(didSelectAddress: didSave)
        }).disposed(by: disposeBag)
        
        menuPage.outputs.toPromotion
            .subscribe(onNext: { [weak self] promotionURL, infoURL in
                self?.openPromotion(promotionURL: promotionURL, infoURL: infoURL)
        }).disposed(by: disposeBag)
        
        menuPage.outputs.toPositionDetail
            .subscribe(onNext: { [weak self] positionUUID in
                self?.openDetail(positionUUID: positionUUID)
            }).disposed(by: disposeBag)
        
        childNavigationController = templateNavigationController(title: tabType.title,
                                                                 image: tabType.image,
                                                                 rootViewController: menuPage)
    }

//    Tech debt: move to pages factory
    
    private func openChangeBrand(didSave: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                       pagesFactory: AddressPagesFactoryImpl(serviceComponents: serviceComponents),
                                       flowType: .changeBrand(didSave: didSave))
        
        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }

        addressCoordinator?.start()
    }
    
//    Tech debt: move to pages factory

    func openChangeAddress(didSelectAddress: (() -> Void)? = nil) {
        addressCoordinator = AddressCoordinator(navigationController: childNavigationController,
                                       pagesFactory: AddressPagesFactoryImpl(serviceComponents: serviceComponents),
                                       flowType: .changeAddress(didSelectAddress: didSelectAddress))
        
        addressCoordinator?.didFinish = { [weak self] in
            self?.addressCoordinator = nil
        }

        addressCoordinator?.start()
    }

    private func openPromotion(promotionURL: URL, infoURL: URL?) {
        let child = PromotionsCoordinator(navigationController: childNavigationController,
                                          pagesFactory: PromotionsPagesFactoryImpl())
        
        child.didFinish = { [weak self] in
            self?.promotionsCoordinator = nil
        }

        child.start(promotionURL: promotionURL, infoURL: infoURL)
    }

    private func openDetail(positionUUID: String) {
        let child = MenuDetailCoordinator(serviceComponents: serviceComponents,
                                          pagesFactory: MenuDetailPagesFactoryImpl(serviceComponents: serviceComponents),
                                          navigationController: childNavigationController)
        
        child.didFinish = { [weak self] in
            self?.menuDetailCoordinator = nil
        }
        
        child.start(positionUUID: positionUUID)
    }

    func didFinish() {}
}
