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
    func didSelect(index: Int) -> Country
}

final class CountryCodePickerViewModel: CountryCodePickerViewModelProtocol {
    private let repository: GeoRepository
    public var cellViewModels: [CountryCodeCellViewModelProtocol]
    public var updateTableView: BehaviorRelay<Void?>
    private var countries: [Country]

    public func update() {
        download()
    }

    public func didSelect(index: Int) -> Country {
        let country = countries[index]
        repository.currentCountry = country
        return country
    }

    private func download() {
//        TODO: finish 
//        startAnimation()
//        firstly {
//            repository.downloadCountries()
//        }.done {
//            self.cellViewModels = $0.map {
//                CountryCodeCellViewModel(country: $0,
//                                         isSelected: self.repository.currentCountry == $0)
//            }
//            self.countries = $0
//        }.catch {
//            self.coordinator.alert(error: $0)
//        }.finally {
//            self.stopAnimation()
//            self.updateTableView.accept(())
//        }
    }

    init(repository: GeoRepository)
    {
        self.repository = repository
        cellViewModels = []
        updateTableView = .init(value: nil)
        countries = []
        download()
    }
}
