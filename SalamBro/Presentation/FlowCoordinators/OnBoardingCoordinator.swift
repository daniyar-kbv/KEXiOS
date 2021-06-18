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

    private func openBrands(cityId _: Int) {
//        let brandsPage = pagesFactory.makeBrandsPage(cityId: cityId)
//
//        brandsPage.outputs.didSelectBrand.subscribe(onNext: { [weak self] _ in
//            self?.openMap()
//        }).disposed(by: disposeBag)
//
//        navigationController.pushViewController(brandsPage, animated: true)

//        TODO: remove

        DIResolver.resolve(BrandRepository.self)?.changeCurrent(brand: Brand(id: 1, name: "Салам бро", image: "", isAvailable: true))

        openMap()
    }

    private func openMap() {
        let mapPage = MapPage(viewModel: MapViewModel(flow: .creation))
        mapPage.selectedAddress = { [weak self] address in
            let locationRepository = DIResolver.resolve(LocationRepository.self)
            let address = Address(name: address.name, longitude: address.longitude, latitude: address.latitude)
            locationRepository?.changeCurrentAddress(to: address)
            self?.didFinish?()
            self?.router.getNavigationController().viewControllers.removeAll()
//            Tech debt: add order apply api
        }
        router.push(viewController: mapPage, animated: true)
    }
}
