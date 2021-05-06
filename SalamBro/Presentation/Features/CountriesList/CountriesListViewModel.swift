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
    func didSelect(index: Int) -> CountryUI
}

public final class CountriesListViewModel: CountriesListViewModelProtocol {
    private let repository: GeoRepository
    public var countries: [CountryUI]
    public var isAnimating: BehaviorRelay<Bool>
    public var updateTableView: BehaviorRelay<Void?>

    public func update() {
        download()
    }

    public func didSelect(index: Int) -> CountryUI {
        let country = countries[index]
        repository.currentCountry = country.toDomain()
        return country
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCountries()
        }.done {
            self.countries = $0.map { CountryUI(from: $0) }
        }.catch { _ in

        }.finally {
            self.updateTableView.accept(())
            self.isAnimating.accept(false)
        }
    }

    public init(repository: GeoRepository) {
        self.repository = repository
        countries = []
        isAnimating = .init(value: false)
        updateTableView = .init(value: nil)
        download()
    }
}
