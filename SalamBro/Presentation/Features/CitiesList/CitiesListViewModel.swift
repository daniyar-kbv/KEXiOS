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

protocol CitiesListViewModelProtocol: ViewModel {
    var cities: [String] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    func update()
    func didSelect(index: Int)
}

final class CitiesListViewModel: CitiesListViewModelProtocol {
    public enum FlowType {
        case change
        case select
    }

    public var router: Router
    private let repository: GeoRepository
    private let type: FlowType
    public var cities: [String]
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
        startAnimation()
        firstly {
            repository.downloadCities(country: self.countryId)
        }.done {
            self.cities = $0
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.stopAnimation()
            self.updateTableView.accept(())
        }
    }

    init(router: Router,
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
        updateTableView = .init(value: nil)
        download()
    }
}
