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

protocol CitiesListViewModelProtocol: AnyObject {
    var outputs: CitiesListViewModel.Output { get }
    var cities: [City] { get }

    func getCities()
    func getCitiesCount() -> Int
    func getCityName(at index: Int) -> String
    func didSelect(index: Int)
}

final class CitiesListViewModel: CitiesListViewModelProtocol {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()
    private let countryId: Int

    private(set) var cities: [City] = []

    private let repository: CitiesRepository

    init(countryId: Int,
         repository: CitiesRepository)
    {
        self.countryId = countryId
        self.repository = repository
        bindOutputs()
    }

    func getCities() {
        repository.fetchCities(with: countryId)
    }

    func getCitiesCount() -> Int {
        return cities.count
    }

    func getCityName(at index: Int) -> String {
        return cities[index].name
    }

    func didSelect(index: Int) {
        let city = cities[index]
        repository.changeCurrentCity(to: city)
        outputs.didSelectCity.accept(city.id)
    }

    private func bindOutputs() {
        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didGetCities.bind {
            [weak self] cities in
            self?.cities = cities
            self?.outputs.didGetCities.accept(())
        }
        .disposed(by: disposeBag)

        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }
}

extension CitiesListViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didGetCities = BehaviorRelay<Void>(value: ())
        let didSelectCity = PublishRelay<Int>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didEndRequest = PublishRelay<Void>()
    }
}
