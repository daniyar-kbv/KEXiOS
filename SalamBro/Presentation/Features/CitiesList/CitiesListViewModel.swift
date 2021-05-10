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
    func didSelect(index: Int)
}

public final class CitiesListViewModel: CitiesListViewModelProtocol {
    public enum FlowType {
        case change
        case select
    }

    public var router: Router
    private let repository: GeoRepository
    private let type: FlowType
    public var cities: [String]
    public var isAnimating: BehaviorRelay<Bool>
    public var updateTableView: BehaviorRelay<Void?>
    private let countryId: Int
    private let didSelectCity: ((String) -> Void)?

    public func update() {
        download()
    }

    public func didSelect(index: Int) {
        let city = cities[index]
        repository.currentCity = city
        didSelectCity?(city)
        switch type {
        case .select:
            let context = CitiesListRouter.RouteType.brands
            router.enqueueRoute(with: context)
        case .change:
            close()
        }
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadCities(country: self.countryId)
        }.done {
            self.cities = $0
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.isAnimating.accept(false)
            self.updateTableView.accept(())
        }
    }

    public init(router: Router,
                country id: Int,
                repository: GeoRepository,
                type: FlowType,
                didSelectCity: ((String) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.type = type
        self.didSelectCity = didSelectCity
        countryId = id
        cities = []
        isAnimating = .init(value: false)
        updateTableView = .init(value: nil)
        download()
    }
}
