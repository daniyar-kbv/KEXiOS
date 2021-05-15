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
    func update()
    func didSelect(index: Int)
}

public final class CountryCodePickerViewModel: CountryCodePickerViewModelProtocol {
    public var router: Router
    private let repository: GeoRepository
    public var cellViewModels: [CountryCodeCellViewModelProtocol]
    public var updateTableView: BehaviorRelay<Void?>
    private var countries: [CountryUI]
    private let didSelectCountry: ((CountryUI) -> Void)?

    public func update() {
        download()
    }

    public func didSelect(index: Int) {
        let country = countries[index]
        repository.currentCountry = country.toDomain()
        didSelectCountry?(country)
        close()
    }

    private func download() {
        startAnimation()
        firstly {
            repository.downloadCountries()
        }.done {
            self.cellViewModels = $0.map {
                CountryCodeCellViewModel(router: self.router,
                                         country: CountryUI(from: $0),
                                         isSelected: self.repository.currentCountry == $0)
            }
            self.countries = $0.map { CountryUI(from: $0) }
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.stopAnimation()
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
        countries = []
        download()
    }
}
