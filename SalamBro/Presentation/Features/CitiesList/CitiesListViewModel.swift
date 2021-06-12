//
//  CitiesListViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol CitiesListViewModelProtocol: ViewModel {
    var cities: [City] { get }
    func didSelect(index: Int)
    func getCities()
    func refreshCities()
    
    var outputs: CitiesListViewModel.Outputs { get }
}

final class CitiesListViewModel: CitiesListViewModelProtocol {
    internal let outputs = Outputs()
    private let disposeBag = DisposeBag()
    private let countryId: Int

    var cities: [City] = []

    private let service: LocationService
    private let repository: LocationRepository

    init(countryId: Int,
         service: LocationService,
         repository: LocationRepository) {
        self.countryId = countryId
        self.service = service
        self.repository = repository
    }

    func getCities() {
        if
            let cachedCities = repository.getCities(),
            cachedCities != []
        {
            cities = cachedCities
            outputs.didGetCities.accept(())
        }

        makeCitiesRequest()
    }

    func refreshCities() {
        makeCitiesRequest()
    }

    private func makeCitiesRequest() {
        startAnimation()
        service.getCities(for: countryId)
            .subscribe { [weak self] citiesResponse in
                self?.stopAnimation()
                self?.process(receivedCities: citiesResponse)
            } onError: { [weak self] error in
                self?.stopAnimation()
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }
            .disposed(by: disposeBag)
    }

    private func process(receivedCities: [City]) {
        guard let cachedCities = repository.getCities() else {
            repository.set(cities: receivedCities)
            cities = receivedCities
            outputs.didGetCities.accept(())
            return
        }

        if cachedCities == receivedCities { return }
        repository.set(cities: receivedCities)
        cities = receivedCities
        outputs.didGetCities.accept(())
    }

    func didSelect(index: Int) {
        let city = cities[index]
        repository.changeCurrentCity(to: city)
        outputs.didSelectCity.accept(city.id)
    }
}

extension CitiesListViewModel {
    struct Outputs {
        let didGetCities = BehaviorRelay<Void>(value: ())
        let didSelectCity = PublishRelay<Int>()
        let didGetError = PublishRelay<ErrorPresentable?>()
    }
}
