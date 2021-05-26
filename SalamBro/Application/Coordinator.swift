//
//  Coordinator.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 10.05.2021.
//

import UIKit

public final class Coordinator {
    private let geoRepository: GeoRepository
    private let brandRepository: BrandRepository

    public init(geoRepository: GeoRepository,
                brandRepository: BrandRepository)
    {
        self.geoRepository = geoRepository
        self.brandRepository = brandRepository
    }

    public func start() {
        if geoRepository.currentCity != nil,
           geoRepository.currentCountry != nil,
           brandRepository.brand != nil
        {
            startMenu()
        } else {
            startFirstFlow()
        }
    }

    private func startFirstFlow() {
        let router = CountriesListRouter()
        let viewModel = CountriesListViewModel(router: router,
                                               repository: geoRepository,
                                               type: .select,
                                               didSelectCountry: nil)
        let vc = CountriesListController(viewModel: viewModel)
        router.baseViewController = vc
        let navVC = UINavigationController(rootViewController: vc)
        setRootView(navVC)
    }

    private func startMenu() {
        let vc = MainTabController()
        setRootView(vc)
    }

    private func setRootView(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = vc
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil) { _ in
            completion?()
        }
    }
}
