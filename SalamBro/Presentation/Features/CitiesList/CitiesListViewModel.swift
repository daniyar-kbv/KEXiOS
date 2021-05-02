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

public protocol CitiesListViewModelProtocol: ViewModel {
    var cities: [String] { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func update()
}

public final class CitiesListViewModel: CitiesListViewModelProtocol {
    private let repository: GeoRepository
    public var cities: [String]
    public var isAnimating: BehaviorRelay<Bool>
    public var updateTableView: BehaviorRelay<Void?>
    private let countryId: Int

    public func update() {
        download()
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCities(country: self.countryId)
        }.done {
            self.cities = $0
        }.catch { _ in

        }.finally {
            self.isAnimating.accept(false)
            self.updateTableView.accept(())
        }
    }

    public init(country id: Int, repository: GeoRepository) {
        self.repository = repository
        countryId = id
        cities = []
        isAnimating = .init(value: false)
        updateTableView = .init(value: nil)
        download()
    }
}
