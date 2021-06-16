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

final class OnBoardingCoordinator {
    private let navigationController: UINavigationController
    private let pagesFactory: OnBoadingPagesFactory
    private let disposeBag = DisposeBag()

    var didFinish: (() -> Void)?

    init(navigationController: UINavigationController,
         pagesFactory: OnBoadingPagesFactory)
    {
        self.navigationController = navigationController
        self.pagesFactory = pagesFactory
    }

    func start() {
        let countriesPage = pagesFactory.makeCountriesPage()

        countriesPage.outputs.didSelectCountry.subscribe(onNext: { [weak self] countryId in
            self?.openCities(countryId: countryId)
        }).disposed(by: disposeBag)

        navigationController.pushViewController(countriesPage, animated: false)
        UIApplication.shared.setRootView(navigationController)
    }

    private func openCities(countryId: Int) {
        let citiesPage = pagesFactory.makeCitiesPage(countryId: countryId)

        citiesPage.outputs.didSelectCity.subscribe(onNext: { [weak self] cityId in
            self?.openBrands(cityId: cityId)
        }).disposed(by: disposeBag)

        navigationController.pushViewController(citiesPage, animated: true)
    }
    
    private func openBrands(cityId: Int) {
        let brandsPage = pagesFactory.makeBrandsPage(cityId: cityId)

        brandsPage.outputs.didSelectBrand.subscribe(onNext: { [weak self] _ in
            self?.openMap()
        }).disposed(by: disposeBag)

        navigationController.pushViewController(brandsPage, animated: true)
        
//        TODO: remove
        
//        DIResolver.resolve(BrandRepository.self)?.changeCurrent(brand: Brand(id: 1, name: "Салам бро", image: "", isAvailable: true))
//
//        openMap()
    }

    private func openMap() {
        let mapPage = pagesFactory.makeMapPage()
        
        mapPage.selectedAddress = { [weak self] address in
            self?.didFinish?()
            self?.navigationController.viewControllers.removeAll()
        }
        
        navigationController.pushViewController(mapPage, animated: true)
    }
}
