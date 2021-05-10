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

public protocol CountriesListViewModelProtocol: ViewModel {
    var countries: [CountryUI] { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func update()
    func didSelect(index: Int)
}

public final class CountriesListViewModel: CountriesListViewModelProtocol {
    public enum FlowType {
        case change
        case select
    }

    public var router: Router
    private let repository: GeoRepository
    private let type: FlowType
    public var countries: [CountryUI]
    public var isAnimating: BehaviorRelay<Bool>
    public var updateTableView: BehaviorRelay<Void?>
    private let didSelectCountry: ((CountryUI) -> Void)?

    public func update() {
        download()
    }

    public func didSelect(index: Int) {
        let country = countries[index]
        repository.currentCountry = country.toDomain()
        didSelectCountry?(country)
        switch type {
        case .change:
            close()
        case .select:
            let context = CountriesListRouter.RouteType.cities(countryId: countries[index].id)
            router.enqueueRoute(with: context)
        }
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCountries()
        }.done {
            self.countries = $0.map { CountryUI(from: $0) }
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.updateTableView.accept(())
            self.isAnimating.accept(false)
        }
    }

    public init(router: Router,
                repository: GeoRepository,
                type: FlowType,
                didSelectCountry: ((CountryUI) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.type = type
        self.didSelectCountry = didSelectCountry
        countries = []
        isAnimating = .init(value: false)
        updateTableView = .init(value: nil)
        download()
    }
}
