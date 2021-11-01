//
//  CountriesListViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol CountriesListViewModelProtocol: ViewModel {
    var outputs: CountriesListViewModel.Output { get }

    var countries: [Country] { get }

    func didSelect(index: Int)
    func getCountries()
    func getCountriesCount() -> Int
    func getCountryName(at index: Int) -> String
}

final class CountriesListViewModel: CountriesListViewModelProtocol {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()

    private(set) var countries: [Country] = []

    private let repository: CountriesRepository

    init(repository: CountriesRepository) {
        self.repository = repository
        bindOutputs()
    }

    private func bindOutputs() {
        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didGetCountries.bind {
            [weak self] countries in
            self?.countries = countries
            self?.repository.setCountries(countries: countries)
            self?.outputs.didGetCountries.accept(())
        }
        .disposed(by: disposeBag)

        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }

    func getCountries() {
        repository.fetchCountries()
        askNotifications()
    }

    func getCountriesCount() -> Int {
        return countries.count
    }

    func getCountryName(at index: Int) -> String {
        return countries[index].name
    }

    func didSelect(index: Int) {
        let country = countries[index]
        repository.changeCurrentCountry(to: country)
        outputs.didSelectCountry.accept(countries[index].id)
    }

    private func askNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
    }
}

extension CountriesListViewModel {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didGetCountries = BehaviorRelay<Void>(value: ())
        let didSelectCountry = PublishRelay<Int>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didEndRequest = PublishRelay<Void>()
    }
}
