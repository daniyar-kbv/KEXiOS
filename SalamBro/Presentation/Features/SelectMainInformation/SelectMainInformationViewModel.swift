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
    var countries: [Country] { get }
    var cities: [City] { get }
    var brands: [Brand] { get }
    var brand: Brand? { get set }
    var deliveryAddress: DeliveryAddress? { get }
    var outputs: SelectMainInformationViewModel.Output { get set }

    func getCountries()
    func didChange(country index: Int)
    func didChange(city index: Int?)
    func didChange(address: Address?)
    func didChange(brand: Brand?)
    func didSave()
    func checkValues()
}

final class SelectMainInformationViewModel: SelectMainInformationViewModelProtocol {
    internal var flowType: FlowType

    private let locationService: LocationService
    private let locationRepository: LocationRepository
    private let brandRepository: BrandRepository

    public lazy var countries: [Country] = locationRepository.getCountries() ?? []
    public lazy var cities: [City] = locationRepository.getCities() ?? []
    public lazy var brands: [Brand] = brandRepository.getBrands() ?? []

    lazy var brand: Brand? = brandRepository.getCurrentBrand()
    var deliveryAddress: DeliveryAddress?

    var outputs = Output()
    private let disposeBag = DisposeBag()

    init(locationService: LocationService,
         locationRepository: LocationRepository,
         brandRepository: BrandRepository,
         flowType: FlowType)
    {
        self.locationService = locationService
        self.locationRepository = locationRepository
        self.brandRepository = brandRepository
        self.flowType = flowType

        switch flowType {
        case let .changeAddress(deliveryAddress):
            self.deliveryAddress = deliveryAddress
        case .changeBrand:
            deliveryAddress = locationRepository.getCurrentDeliveryAddress()
        case .create:
            deliveryAddress = DeliveryAddress()
        }
    }
}

extension SelectMainInformationViewModel {
    func didChange(country index: Int) {
        guard deliveryAddress?.country != countries[index] else { return }
        deliveryAddress?.country = countries[index]
        outputs.didSelectCountry.accept(deliveryAddress?.country?.name)
        checkValues()
        getCities()

        didChange(city: nil)
        didChange(address: nil)
        didChange(brand: nil)
    }

    func didChange(city index: Int?) {
        guard let index = index else {
            deliveryAddress?.city = nil
            outputs.didSelectCity.accept(deliveryAddress?.city?.name)
            checkValues()
            return
        }
        guard deliveryAddress?.city != cities[index] else { return }
        let city = cities[index]
        deliveryAddress?.city = city
        outputs.didSelectCity.accept(deliveryAddress?.city?.name)
        checkValues()

        didChange(address: nil)
        didChange(brand: nil)
    }

    func didChange(address: Address?) {
        deliveryAddress?.address = address
        outputs.didSelectAddress.accept(address?.name)
        checkValues()
    }

    func didChange(brand: Brand?) {
        self.brand = brand
        outputs.didSelectBrand.accept(brand?.name)
        checkValues()
    }

    func didSave() {
        if let brand = brand {
            brandRepository.changeCurrent(brand: brand)
        }
        switch flowType {
        case .create:
            if let deliveryAddress = deliveryAddress {
                locationRepository.addDeliveryAddress(deliveryAddress: deliveryAddress)
            }
        default:
            break
        }
        outputs.didSave.accept(())
    }

    func checkValues() {
        outputs.checkResult.accept(deliveryAddress?.isComplete() ?? false)
    }
}

extension SelectMainInformationViewModel {
    func getCountries() {
        if let cachedCountries = locationRepository.getCountries(),
           cachedCountries != []
        {
            countries = cachedCountries
            outputs.didGetCountries.accept(())
        }

        makeCountriesRequest()
    }

    private func makeCountriesRequest() {
        startAnimation()
        locationService.getAllCountries()
            .subscribe { [weak self] countriesResponse in
                self?.stopAnimation()
                self?.process(received: countriesResponse)
            } onError: { [weak self] error in
                self?.stopAnimation()
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }
            .disposed(by: disposeBag)
    }

    private func process(received countries: [Country]) {
        guard let cachedCountries = locationRepository.getCountries() else {
            locationRepository.set(countries: countries)
            self.countries = countries
            outputs.didGetCountries.accept(())
            return
        }

        if countries == cachedCountries { return }
        locationRepository.set(countries: countries)
        self.countries = countries
        outputs.didGetCountries.accept(())
    }
}

extension SelectMainInformationViewModel {
    private func getCities() {
        guard let countryId = deliveryAddress?.country?.id else { return }
        startAnimation()
        locationService.getCities(for: countryId)
            .subscribe { [weak self] citiesResponse in
                self?.stopAnimation()
                self?.process(received: citiesResponse)
            } onError: { [weak self] error in
                self?.stopAnimation()
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }
            .disposed(by: disposeBag)
    }

    private func process(received cities: [City]) {
        self.cities = cities
        outputs.didGetCities.accept(())
    }
}

extension SelectMainInformationViewModel {
    enum FlowType: Equatable {
        case create
        case changeAddress(_ address: DeliveryAddress)
        case changeBrand
    }

    struct Output {
        let didGetCountries = PublishRelay<Void>()
        let didGetCities = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let updateTableView = PublishRelay<Void>()

        let didSelectCountry = PublishRelay<String?>()
        let didSelectCity = PublishRelay<String?>()
        let didSelectAddress = PublishRelay<String?>()
        let didSelectBrand = PublishRelay<String?>()

        let checkResult = PublishRelay<Bool>()
        let didSave = PublishRelay<Void>()
    }
}
