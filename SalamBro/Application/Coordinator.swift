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
        let viewModel = CountriesListViewModel(repository: DIResolver.resolve(GeoRepository.self)!)
        let vc = CountriesListController(viewModel: viewModel)
        let navVC = QFNavigationController(rootViewController: vc)
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
