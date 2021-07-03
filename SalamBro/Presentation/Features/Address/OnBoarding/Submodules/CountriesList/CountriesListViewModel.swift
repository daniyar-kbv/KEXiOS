//
//  CountriesListViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol CountriesListViewModelProtocol: ViewModel {
    var countries: [Country] { get }
    func refresh()
    func didSelect(index: Int)
    func getCountries()

    var outputs: CountriesListViewModel.Output { get }
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    private(set) var outputs = Output()
    private let disposeBag = DisposeBag()

    private(set) var countries: [Country] = []

    private let service: LocationService
    private let repository: AddressRepository

    init(service: LocationService,
         repository: AddressRepository)
    {
        self.service = service
        self.repository = repository
    }

    func getCountries() {
        if
            let cachedCountries = repository.getCountries(),
            cachedCountries != []
        {
            countries = cachedCountries
            outputs.didGetCoutries.accept(())
        }

        makeCountriesRequest()
    }

    func refresh() {
        makeCountriesRequest()
    }

    private func makeCountriesRequest() {
        startAnimation()
        service.getAllCountries()
            .subscribe { [weak self] countriesResponse in
                self?.stopAnimation()
                self?.process(receivedCountries: countriesResponse)
            } onError: { [weak self] error in
                self?.stopAnimation()
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }
            .disposed(by: disposeBag)
    }

    private func process(receivedCountries: [Country]) {
        guard let cachedCountries = repository.getCountries() else {
            repository.set(countries: receivedCountries)
            countries = receivedCountries
            outputs.didGetCoutries.accept(())
            return
        }

        if receivedCountries == cachedCountries { return }
        repository.set(countries: receivedCountries)
        countries = receivedCountries
        outputs.didGetCoutries.accept(())
    }

    func didSelect(index: Int) {
        let country = countries[index]
        repository.changeCurrentCountry(to: country)
        outputs.didSelectCountry.accept(countries[index].id)
    }
}

extension CountriesListViewModel {
    struct Output {
        let didGetCoutries = BehaviorRelay<Void>(value: ())
        let didSelectCountry = PublishRelay<Int>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
