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

protocol CountryCodePickerViewModelProtocol: ViewModel {
    var cellViewModels: [CountryCodeCellViewModelProtocol] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func update()
    func didSelect(index: Int)
}

final class CountryCodePickerViewModel: CountryCodePickerViewModelProtocol {
    public var router: Router
    private let repository: GeoRepository
    public var cellViewModels: [CountryCodeCellViewModelProtocol]
    public var updateTableView: BehaviorRelay<Void?>
    private var countries: [Country]
    private let didSelectCountry: ((Country) -> Void)?

    public func update() {
        download()
    }

    public func didSelect(index: Int) {
        let country = countries[index]
        repository.currentCountry = country
        didSelectCountry?(country)
        // TODO: chango to coordinators
//        close()
    }

    private func download() {
//        startAnimation()
//        firstly {
//            repository.downloadCountries()
//        }.done {
//            self.cellViewModels = $0.map {
//                CountryCodeCellViewModel(router: self.router,
//                                         country: $0,
//                                         isSelected: self.repository.currentCountry == $0)
//            }
//            self.countries = $0
//        }.catch {
//            self.router.alert(error: $0)
//        }.finally {
//            self.stopAnimation()
//            self.updateTableView.accept(())
//        }
    }

    init(router: Router,
         repository: GeoRepository,
         didSelectCountry: ((Country) -> Void)?)
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
