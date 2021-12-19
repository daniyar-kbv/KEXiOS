//
//  CountryCodePickerViewModel.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol CountryCodePickerViewModel: AnyObject {
    var countries: [CountryCodeModel] { get }
    var outputs: CountryCodePickerViewModelImpl.Output { get }
    func refresh()
    func getCountries()
    func selectCodeCountry(at indexPath: IndexPath) -> CountryCodeModel
}

final class CountryCodePickerViewModelImpl: CountryCodePickerViewModel {
    private let disposeBag = DisposeBag()

    private(set) var outputs = Output()

    private(set) var countries: [CountryCodeModel] = []

    private let countriesRepository: CountriesRepository
    private let addressRepository: AddressRepository

    init(countriesRepository: CountriesRepository, addressRepository: AddressRepository) {
        self.countriesRepository = countriesRepository
        self.addressRepository = addressRepository
        bindOutputs()
    }

    func selectCodeCountry(at indexPath: IndexPath) -> CountryCodeModel {
        countries[indexPath.row].isSelected.toggle()
        countriesRepository.changeCurrentCountry(to: countries[indexPath.row].country)
        return countries[indexPath.row]
    }

    func getCountries() {
        if let cachedCountries = countriesRepository.getCountries() {
            convert(cachedCountries: cachedCountries)
            return
        }

        makeRequest()
    }

    func refresh() {
        makeRequest()
    }

    private func convert(cachedCountries: [Country]) {
        var codeCountries: [CountryCodeModel] = []
        for country in cachedCountries {
            if country == addressRepository.getCurrentCountry() {
                codeCountries.append(CountryCodeModel(country: country, isSelected: true))
                break
            }
            codeCountries.append(CountryCodeModel(country: country, isSelected: false))
        }
        countries = codeCountries
        outputs.didGetCountries.accept(())
    }

    private func makeRequest() {
        countriesRepository.fetchCountries()
    }

    private func bindOutputs() {
        countriesRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        countriesRepository.outputs.didGetCountries.bind {
            [weak self] countries in
                self?.countriesRepository.setCountries(countries: countries)
                self?.convert(cachedCountries: countries)
                self?.outputs.didGetCountries.accept(())
        }
        .disposed(by: disposeBag)

        countriesRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        countriesRepository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }
}

extension CountryCodePickerViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetCountries = PublishRelay<Void>()
        let didFail = PublishRelay<ErrorPresentable>()
    }
}
