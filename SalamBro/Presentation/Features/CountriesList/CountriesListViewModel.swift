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
    var updateTableView: BehaviorRelay<Void?> { get }
    func refresh()
    func didSelect(index: Int)
    func getCountries()
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    enum FlowType {
        case change
        case select
    }

    private let disposeBag = DisposeBag()

    public var router: Router
    private let type: FlowType
    private(set) var countries: [Country] = []
    private(set) var updateTableView: BehaviorRelay<Void?>
    private let didSelectCountry: ((Country) -> Void)?

    private let service: LocationService
    private let repository: LocationRepository

    init(router: Router,
         service: LocationService,
         repository: LocationRepository,
         type: FlowType,
         didSelectCountry: ((Country) -> Void)?)
    {
        self.router = router
        self.service = service
        self.repository = repository
        self.type = type
        self.didSelectCountry = didSelectCountry
        updateTableView = .init(value: nil)
    }

    func refresh() {
        makeCountriesRequest()
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

    private func makeCountriesRequest() {
        startAnimation()
        service.getAllCountries()
            .subscribe { [weak self] countriesResponse in
                self?.stopAnimation()
                self?.process(receivedCountries: countriesResponse)
            } onError: { [weak self] error in
                self?.stopAnimation()
                self?.router.alert(error: error)
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
        didSelectCountry?(country)
        switch type {
        case .change:
            close()
        case .select:
            let context = CountriesListRouter.RouteType.cities(countryId: countries[index].id)
            router.enqueueRoute(with: context)
        }
    }
}
