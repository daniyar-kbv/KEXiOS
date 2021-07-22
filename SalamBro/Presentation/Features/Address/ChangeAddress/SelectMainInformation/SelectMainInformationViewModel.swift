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

protocol SelectMainInformationViewModelProtocol {
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

    private let addressRepository: AddressRepository
    private let countriesRepository: CountriesRepository
    private let citiesRepository: CitiesRepository
    private let brandRepository: BrandRepository
    private let defaultStorage: DefaultStorage

    public lazy var countries: [Country] = countriesRepository.getCountries() ?? []
    public lazy var cities: [City] = citiesRepository.getCities() ?? []

    public lazy var brands: [Brand] = brandRepository.getBrands() ?? []

    lazy var brand: Brand? = brandRepository.getCurrentBrand()
    var deliveryAddress: DeliveryAddress?

    var outputs = Output()
    private let disposeBag = DisposeBag()

    init(addressRepository: AddressRepository,
         countriesRepository: CountriesRepository,
         citiesRepository: CitiesRepository,
         brandRepository: BrandRepository,
         defaultStorage: DefaultStorage,
         flowType: FlowType)
    {
        self.addressRepository = addressRepository
        self.countriesRepository = countriesRepository
        self.citiesRepository = citiesRepository
        self.brandRepository = brandRepository
        self.defaultStorage = defaultStorage
        self.flowType = flowType

        switch flowType {
        case let .changeAddress(deliveryAddress):
            self.deliveryAddress = deliveryAddress
        case .changeBrand:
            deliveryAddress = addressRepository.getCurrentDeliveryAddress()
        case .create:
            deliveryAddress = DeliveryAddress()
        }

        bindOutputs()
    }
}

extension SelectMainInformationViewModel {
    private func bindOutputs() {
        countriesRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        countriesRepository.outputs.didGetCountries.bind {
            [weak self] countries in
            self?.process(received: countries)
        }
        .disposed(by: disposeBag)

        countriesRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        countriesRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        citiesRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        citiesRepository.outputs.didGetCities.bind {
            [weak self] cities in
            self?.cities = cities
            self?.process(received: cities)
        }
        .disposed(by: disposeBag)

        citiesRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        citiesRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        addressRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didGetLeadUUID
            .bind(to: outputs.didSave)
            .disposed(by: disposeBag)

        addressRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        addressRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)
    }

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
            brandRepository.changeCurrentBrand(to: brand)
        }

        switch flowType {
        case .create:
            if let deliveryAddress = deliveryAddress {
                addressRepository.addDeliveryAddress(deliveryAddress: deliveryAddress)
            }
        default:
            break
        }

        addressRepository.applyOrder(withAddress: true)
    }

    func checkValues() {
        outputs.checkResult.accept((deliveryAddress?.isComplete() ?? false) && brand != nil)
    }
}

extension SelectMainInformationViewModel {
    func getCountries() {
        outputs.updateTableView.accept(())

        if let cachedCountries = countriesRepository.getCountries(),
           cachedCountries != []
        {
            countries = cachedCountries
            outputs.didGetCountries.accept(cachedCountries.map { $0.name })
        }

        makeCountriesRequest()
    }

    private func makeCountriesRequest() {
        countriesRepository.fetchCountries()
    }

    private func process(received countries: [Country]) {
        guard let cachedCountries = countriesRepository.getCountries() else {
            countriesRepository.setCountries(countries: countries)
            self.countries = countries
            outputs.didGetCountries.accept(countries.map { $0.name })
            return
        }

        if countries == cachedCountries { return }
        countriesRepository.setCountries(countries: countries)
        self.countries = countries
        outputs.didGetCountries.accept(countries.map { $0.name })
    }
}

extension SelectMainInformationViewModel {
    private func getCities() {
        guard let countryId = deliveryAddress?.country?.id else { return }
        citiesRepository.fetchCities(with: countryId)
    }

    private func process(received cities: [City]) {
        self.cities = cities
        outputs.didGetCities.accept(cities.map { $0.name })
    }
}

extension SelectMainInformationViewModel {
    enum FlowType: Equatable {
        case create
        case changeAddress(_ address: DeliveryAddress)
        case changeBrand
    }

    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let didGetCountries = PublishRelay<[String]>()
        let didGetCities = PublishRelay<[String]>()

        let updateTableView = PublishRelay<Void>()

        let didSelectCountry = PublishRelay<String?>()
        let didSelectCity = PublishRelay<String?>()
        let didSelectAddress = PublishRelay<String?>()
        let didSelectBrand = PublishRelay<String?>()

        let checkResult = PublishRelay<Bool>()
        let didSave = PublishRelay<Void>()
    }
}
