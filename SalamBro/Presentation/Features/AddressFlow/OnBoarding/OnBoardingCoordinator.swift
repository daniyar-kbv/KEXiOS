//
//  FirstFlowCoordinator.swift
//  SalamBro
//
//  Created by Dan on 6/6/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class OnBoardingCoordinator: BaseCoordinator {
    private(set) var router: Router
    private let pagesFactory: OnBoadingPagesFactory
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?

    init(router: Router,
         pagesFactory: OnBoadingPagesFactory)
    {
        self.router = router
        self.pagesFactory = pagesFactory
    }

    override func start() {
        let countriesPage = pagesFactory.makeCountriesPage()

        countriesPage.outputs.didSelectCountry.subscribe(onNext: { [weak self] countryId in
            self?.openCities(countryId: countryId)
        }).disposed(by: disposeBag)

        router.push(viewController: countriesPage, animated: false)
        UIApplication.shared.setRootView(router.getNavigationController())
    }

    private func openCities(countryId: Int) {
        let citiesPage = pagesFactory.makeCitiesPage(countryId: countryId)

        citiesPage.outputs.didSelectCity.subscribe(onNext: { [weak self] cityId in
            self?.openBrands(cityId: cityId)
        }).disposed(by: disposeBag)

        router.push(viewController: citiesPage, animated: true)
    }

    private func openBrands(cityId: Int) {
        let brandsPage = pagesFactory.makeBrandsPage(cityId: cityId)

        brandsPage.outputs.didSelectBrand.subscribe(onNext: { [weak self] _ in
            self?.openMap()
        }).disposed(by: disposeBag)

        router.push(viewController: brandsPage, animated: true)
    }

    private func openMap() {
        let mapPage = pagesFactory.makeMapPage()

        mapPage.selectedAddress = { [weak self] _ in
            self?.didFinish?()
            self?.router.getNavigationController().viewControllers.removeAll()
        }
        router.push(viewController: mapPage, animated: true)
    }
}
