//
//  CountryCodePickerViewModel.swift
//  SalamBro
//
//  Created by Arystan on 3/13/21.
//

import Foundation
import PromiseKit
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

    private let repository: AddressRepository
    private let service: LocationService

    init(repository: AddressRepository, service: LocationService) {
        self.repository = repository
        self.service = service
    }

    func selectCodeCountry(at indexPath: IndexPath) -> CountryCodeModel {
        countries[indexPath.row].isSelected.toggle()
        repository.changeCurrentCountry(to: countries[indexPath.row].country)
        return countries[indexPath.row]
    }

    func getCountries() {
        if let cachedCountries = repository.getCountries() {
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
            if country == repository.getCurrentCountry() {
                codeCountries.append(CountryCodeModel(country: country, isSelected: true))
                break
            }
            codeCountries.append(CountryCodeModel(country: country, isSelected: false))
        }
        countries = codeCountries
        outputs.didGetCountries.accept(())
    }

    private func makeRequest() {
        outputs.didStartRequest.accept(())
        service.getAllCountries()
            .subscribe(onSuccess: { [weak self] countries in
                self?.outputs.didEndRequest.accept(())
                self?.repository.set(countries: countries)
                self?.convert(cachedCountries: countries)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                if let error = error as? ErrorPresentable {
                    self?.outputs.didFail.accept(error)
                    return
                }
                self?.outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            })
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
