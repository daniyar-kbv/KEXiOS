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
    func country(by index: Int) -> CountryUI
}

public final class CountryCodePickerViewModel: CountryCodePickerViewModelProtocol {
    private let repository: GeoRepository
    public var cellViewModels: [CountryCodeCellViewModelProtocol]
    public var updateTableView: BehaviorRelay<Void?>
    public var isAnimating: BehaviorRelay<Bool>
    private var countries: [CountryUI]

    public func update() {
        download()
    }

    public func country(by index: Int) -> CountryUI {
        countries[index]
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCountries()
        }.done {
            self.cellViewModels = $0.map { CountryCodeCellViewModel(country: CountryUI(from: $0)) }
            self.countries = $0.map { CountryUI(from: $0) }
        }.catch { _ in

        }.finally {
            self.isAnimating.accept(false)
            self.updateTableView.accept(())
        }
    }

    public init(repository: GeoRepository) {
        self.repository = repository
        cellViewModels = []
        updateTableView = .init(value: nil)
        isAnimating = .init(value: false)
        countries = []
        download()
    }
}
