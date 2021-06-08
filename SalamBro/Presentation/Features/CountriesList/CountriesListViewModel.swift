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
    var coordinator: FirstFlowCoordinator { get }
    var countries: [Country] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func refresh()
    func didSelect(index: Int)
    func getCountries()
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    private let disposeBag = DisposeBag()

    public var coordinator: FirstFlowCoordinator
    private(set) var countries: [Country] = []
    private(set) var updateTableView: BehaviorRelay<Void?>

    private let service: LocationService
    private let repository: LocationRepository

    init(coordinator: FirstFlowCoordinator,
         service: LocationService,
         repository: LocationRepository)
    {
        self.coordinator = coordinator
        self.service = service
        self.repository = repository
        updateTableView = .init(value: nil)
    }

    func getCountries() {
        if
            let cachedCountries = repository.getCountries(),
            cachedCountries != []
        {
            countries = cachedCountries
            updateTableView.accept(())
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
                self?.coordinator.alert(error: error)
            }
            .disposed(by: disposeBag)
    }

    private func process(receivedCountries: [Country]) {
        guard let cachedCountries = repository.getCountries() else {
            repository.set(countries: receivedCountries)
            countries = receivedCountries
            updateTableView.accept(())
            return
        }

        if receivedCountries == cachedCountries { return }
        repository.set(countries: receivedCountries)
        countries = receivedCountries
        updateTableView.accept(())
    }

    func didSelect(index: Int) {
        let country = countries[index]
        repository.changeCurrectCountry(to: country)
        coordinator.openCitiesList(countryId: countries[index].id)
    }
}
