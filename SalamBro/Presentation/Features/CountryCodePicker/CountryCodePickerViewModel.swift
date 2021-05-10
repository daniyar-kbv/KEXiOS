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

public protocol CountryCodePickerViewModelProtocol: ViewModel {
    var cellViewModels: [CountryCodeCellViewModelProtocol] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    func update()
    func didSelect(index: Int)
}

public final class CountryCodePickerViewModel: CountryCodePickerViewModelProtocol {
    public var router: Router
    private let repository: GeoRepository
    public var cellViewModels: [CountryCodeCellViewModelProtocol]
    public var updateTableView: BehaviorRelay<Void?>
    public var isAnimating: BehaviorRelay<Bool>
    private var countries: [CountryUI]
    private let didSelectCountry: ((CountryUI) -> Void)?

    public func update() {
        download()
    }

    public func didSelect(index: Int) {
        let country = countries[index]
        repository.currentCountry = country.toDomain()
        didSelectCountry?(country)
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCountries()
        }.done {
            self.cellViewModels = $0.map {
                CountryCodeCellViewModel(router: self.router,
                                         country: CountryUI(from: $0),
                                         isSelected: self.repository.currentCountry == $0)
            }
            self.countries = $0.map { CountryUI(from: $0) }
        }.catch { _ in

        }.finally {
            self.isAnimating.accept(false)
            self.updateTableView.accept(())
        }
    }

    public init(router: Router,
                repository: GeoRepository,
                didSelectCountry: ((CountryUI) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.didSelectCountry = didSelectCountry
        cellViewModels = []
        updateTableView = .init(value: nil)
        isAnimating = .init(value: false)
        countries = []
        download()
    }
}
