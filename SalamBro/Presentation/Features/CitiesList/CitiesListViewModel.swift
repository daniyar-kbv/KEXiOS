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
    var coordinator: AddressCoordinator { get set }
    var cities: [City] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func didSelect(index: Int, completion: (_ type: Any) -> Void)
    func getCities()
    func refreshCities()
}

final class CitiesListViewModel: CitiesListViewModelProtocol {
    private let disposeBag = DisposeBag()
    var coordinator: AddressCoordinator
    private let type: AddressCoordinator.FlowType
    private let countryId: Int

    var cities: [City] = []
    var updateTableView: BehaviorRelay<Void?>
    let didSelectCity: ((City) -> Void)?

    private let service: LocationService
    private let repository: LocationRepository

    init(coordinator: AddressCoordinator,
         type: AddressCoordinator.FlowType,
         countryId: Int,
         service: LocationService,
         repository: LocationRepository,
         didSelectCity: ((City) -> Void)?)
    {
        self.coordinator = coordinator
        self.type = type
        self.countryId = countryId
        self.service = service
        self.repository = repository
        self.didSelectCity = didSelectCity
        updateTableView = .init(value: nil)
    }

    func getCities() {
        if
            let cachedCities = repository.getCities(),
            cachedCities != []
        {
            cities = cachedCities
            updateTableView.accept(())
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
                self?.coordinator.alert(error: error)
            }
            .disposed(by: disposeBag)
    }

    private func process(receivedCities: [City]) {
        guard let cachedCities = repository.getCities() else {
            repository.set(cities: receivedCities)
            cities = receivedCities
            updateTableView.accept(())
            return
        }

        if cachedCities == receivedCities { return }
        repository.set(cities: receivedCities)
        cities = receivedCities
        updateTableView.accept(())
    }

    func didSelect(index: Int, completion: (_ type: Any) -> Void) {
        let city = cities[index]
        repository.changeCurrentCity(to: city)
        didSelectCity?(city)
        switch type {
        case .firstFlow:
            coordinator.openBrands()
        case .changeAddress, .changeMainInfo:
            break
        }
        completion(type)
    }
}
