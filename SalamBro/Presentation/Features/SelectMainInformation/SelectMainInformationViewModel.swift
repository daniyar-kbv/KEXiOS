//
//  SelectMainInformationViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol SelectMainInformationViewModelProtocol: ViewModel {
    var countryName: BehaviorRelay<String?> { get }
    var cityName: BehaviorRelay<String?> { get }
    var brandName: BehaviorRelay<String?> { get }
    var address: BehaviorRelay<String?> { get }
    var countries: [String] { get }
    var cities: [City] { get }
    var brands: [Brand] { get }
    func didChange(cityname: String)
    func didChange(country index: Int)
    func didChange(brand: Brand)
    func didChange(address: Address)
    func selectBrand()
    func selectAddress()
    func save()
}

final class SelectMainInformationViewModel: SelectMainInformationViewModelProtocol {
    var router: Router
    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    public var countryName: BehaviorRelay<String?>
    public var cityName: BehaviorRelay<String?>
    public var brandName: BehaviorRelay<String?>
    public var address: BehaviorRelay<String?>
    public var countries: [String]
    public var cities: [City]
    public var brands: [Brand]
    private let didSave: (() -> Void)?

    func didChange(cityname: String) {
        for city in cities where city.name == cityname {
            geoRepository.currentCity = city
            cityName.accept(city.name)
        }
    }

    func didChange(country index: Int) {
        let country = geoRepository.countries[index]
        geoRepository.currentCountry = country
        countryName.accept(country.name)
    }

    func didChange(brand: Brand) {
        brandRepository.changeCurrent(brand: brand)
        brandName.accept(brand.name)
    }

    func didChange(address: Address) {
        geoRepository.currentAddress = address
        self.address.accept(address.name)
    }

    func selectBrand() {
        let context = SelectMainInformationRouter.RouteType.selectBrand { [unowned self] in
            self.didChange(brand: $0)
        }
        router.enqueueRoute(with: context)
    }

    func selectAddress() {
        let context = SelectMainInformationRouter.RouteType.selectAddress { [unowned self] in
            self.didChange(address: $0)
        }
        router.enqueueRoute(with: context)
    }

    func save() {
        didSave?()
        router.dismiss()
    }

    init(router: Router,
         geoRepository: GeoRepository,
         brandRepository: BrandRepository,
         didSave: (() -> Void)?)
    {
        self.router = router
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
        self.didSave = didSave
        countryName = .init(value: geoRepository.currentCountry?.name)
        cityName = .init(value: geoRepository.currentCity?.name)
        brandName = .init(value: brandRepository.getCurrentBrand()?.name)
        countries = geoRepository.countries.map { $0.name }
        cities = geoRepository.cities
        brands = brandRepository.getBrands() ?? [] // brandRepository.brands.map { $0.name }
        address = .init(value: geoRepository.currentAddress?.name)
    }
}
