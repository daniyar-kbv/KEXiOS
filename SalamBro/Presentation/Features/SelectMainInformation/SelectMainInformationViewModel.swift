//
//  SelectMainInformationViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol SelectMainInformationViewModelProtocol: ViewModel {
    var countryName: BehaviorRelay<String?> { get }
    var cityName: BehaviorRelay<String?> { get }
    var brandName: BehaviorRelay<String?> { get }
    var address: BehaviorRelay<String?> { get }
    var countries: [String] { get }
    var cities: [String] { get }
    var brands: [String] { get }
    func didChange(city: String)
    func didChange(country index: Int)
    func didChange(brand: BrandUI)
    func didChange(address: Address)
    func selectBrand()
    func selectAddress()
    func save()
}

public final class SelectMainInformationViewModel: SelectMainInformationViewModelProtocol {
    public var router: Router
    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    public var countryName: BehaviorRelay<String?>
    public var cityName: BehaviorRelay<String?>
    public var brandName: BehaviorRelay<String?>
    public var address: BehaviorRelay<String?>
    public var countries: [String]
    public var cities: [String]
    public var brands: [String]
    private let didSave: (() -> Void)?

    public func didChange(city: String) {
        geoRepository.currentCity = city
        cityName.accept(city)
    }

    public func didChange(country index: Int) {
        let country = geoRepository.countries[index]
        geoRepository.currentCountry = country
        countryName.accept(country.name)
    }

    public func didChange(brand: BrandUI) {
        brandRepository.brand = brand.toDomain()
        brandName.accept(brand.name)
    }

    public func didChange(address: Address) {
        geoRepository.currentAddress = address
        self.address.accept(address.name)
    }

    public func selectBrand() {
        let context = SelectMainInformationRouter.RouteType.selectBrand { [unowned self] in
            self.didChange(brand: $0)
        }
        router.enqueueRoute(with: context)
    }

    public func selectAddress() {
        let context = SelectMainInformationRouter.RouteType.selectAddress { [unowned self] in
            self.didChange(address: $0)
        }
        router.enqueueRoute(with: context)
    }

    public func save() {
        didSave?()
        router.dismiss()
    }

    public init(router: Router,
                geoRepository: GeoRepository,
                brandRepository: BrandRepository,
                didSave: (() -> Void)?)
    {
        self.router = router
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
        self.didSave = didSave
        countryName = .init(value: geoRepository.currentCountry?.name)
        cityName = .init(value: geoRepository.currentCity)
        brandName = .init(value: brandRepository.brand?.name)
        countries = geoRepository.countries.map { $0.name }
        cities = geoRepository.cities
        brands = brandRepository.brands.map { $0.name }
        address = .init(value: geoRepository.currentAddress?.name)
    }
}
