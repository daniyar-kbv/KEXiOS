//
//  SelectMainInformationViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 07.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

// Tech debt: change logic to properly change/save addresses

protocol SelectMainInformationViewModelProtocol: ViewModel {
    var flowType: SelectMainInformationViewModel.FlowType { get }
    var countries: [String] { get }
    var cities: [City] { get }
    var brands: [Brand] { get }
    var outputs: SelectMainInformationViewModel.Output { get set }
    
    func didChange(cityname: String)
    func didChange(country index: Int)
    func didChange(brand: Brand)
    func didChange(address: Address)
    func didSave()
    func checkValues()
    //    Tech debt: remove after addresses storage change
    func sendCurrentValues()
    func sendAddressValues()
}

final class SelectMainInformationViewModel: SelectMainInformationViewModelProtocol {
    internal var flowType: FlowType
    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    public var countries: [String]
    public var cities: [City]
    public var brands: [Brand]
    
    private var country: Country?
    private var city: City?
    private var address: Address?
    private var brand: Brand?
    
    var outputs = Output()
    
    init(geoRepository: GeoRepository,
         brandRepository: BrandRepository,
         flowType: FlowType) {
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
        self.flowType = flowType
        
        countries = geoRepository.countries.map { $0.name }
        cities = geoRepository.cities
        brands = brandRepository.getBrands() ?? [] // brandRepository.brands.map { $0.name }
        
        setupValues()
    }

    func didChange(country index: Int) {
        country = geoRepository.countries[index]
        outputs.didSelectCountry.accept(country?.name)
        checkValues()
    }
    
    func didChange(cityname: String) {
        let city = cities.first(where: { $0.name == cityname })
        self.city = city
        outputs.didSelectCity.accept(city?.name)
        checkValues()
    }
    
    func didChange(address: Address) {
        self.address = address
        outputs.didSelectAddress.accept(address.name)
        checkValues()
    }

    func didChange(brand: Brand) {
        self.brand = brand
        outputs.didSelectBrand.accept(brand.name)
        checkValues()
    }
    
    func checkValues() {
        outputs.checkResult.accept(
            country != nil && city != nil && address != nil && brand != nil
        )
    }
    
    func setupValues() {
        switch flowType {
        case let .changeAddress(address):
            self.country = geoRepository.currentCountry
            self.city = geoRepository.currentCity
            self.address = address
            self.brand = brandRepository.getCurrentBrand()
        case .changeBrand:
            self.country = geoRepository.currentCountry
            self.city = geoRepository.currentCity
            self.address = geoRepository.currentAddress
            self.brand = brandRepository.getCurrentBrand()
        case .create:
            break
        }
    }
    
    func didSave() {
        switch flowType {
        case let .changeAddress(address):
            if let addressIndex = geoRepository.addresses?.firstIndex(where: { $0 == address }), let changedAddress = self.address {
                geoRepository.addresses?[addressIndex] = changedAddress
                geoRepository.currentAddress = changedAddress
            }
        case .create:
            geoRepository.currentCountry = country
            geoRepository.currentCity = city
            if let address = address {
                geoRepository.addresses?.append(address)
                geoRepository.currentAddress = address
            }
            if let brand = brand {
                brandRepository.changeCurrent(brand: brand)
            }
        case .changeBrand:
            if let brand = brand {
                brandRepository.changeCurrent(brand: brand)
            }
        }
        outputs.didSave.accept(())
    }
    
//    Tech debt: remove after addresses storage change
    func sendCurrentValues() {
        outputs.didSelectCountry.accept(country?.name)
        outputs.didSelectCity.accept(city?.name)
        outputs.didSelectAddress.accept(address?.name)
        outputs.didSelectBrand.accept(brand?.name)
    }
    
    func sendAddressValues() {
        outputs.didSelectAddress.accept(address?.name)
        outputs.didSelectBrand.accept(brand?.name)
    }
}

extension SelectMainInformationViewModel {
    enum FlowType: Equatable {
        case create
        case changeAddress(_ address: Address)
        case changeBrand
    }
    
    struct Output {
        let checkResult = PublishRelay<Bool>()
        let didSelectCountry = PublishRelay<String?>()
        let didSelectCity = PublishRelay<String?>()
        let didSelectAddress = PublishRelay<String?>()
        let didSelectBrand = PublishRelay<String?>()
        let didSave = PublishRelay<Void>()
    }
}
