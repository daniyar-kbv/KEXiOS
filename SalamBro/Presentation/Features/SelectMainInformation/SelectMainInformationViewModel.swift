//
//  SelectMainInformationViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol SelectMainInformationViewModelProtocol: AnyObject {
    var countryName: BehaviorRelay<String?> { get }
    var cityName: BehaviorRelay<String?> { get }
    var brandName: BehaviorRelay<String?> { get }
    var countries: [String] { get }
    var cities: [String] { get }
    var brands: [String] { get }
    func didChange(city: String)
    func didChange(country index: Int)
    func didChange(brand: BrandUI)
}

public final class SelectMainInformationViewModel: SelectMainInformationViewModelProtocol {
    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    public var countryName: BehaviorRelay<String?>
    public var cityName: BehaviorRelay<String?>
    public var brandName: BehaviorRelay<String?>
    public var countries: [String]
    public var cities: [String]
    public var brands: [String]

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

    public init(geoRepository: GeoRepository,
                brandRepository: BrandRepository)
    {
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
        countryName = .init(value: geoRepository.currentCountry?.name)
        cityName = .init(value: geoRepository.currentCity)
        brandName = .init(value: brandRepository.brand?.name)
        countries = geoRepository.countries.map { $0.name }
        cities = geoRepository.cities
        brands = brandRepository.brands.map { $0.name }
    }
}
