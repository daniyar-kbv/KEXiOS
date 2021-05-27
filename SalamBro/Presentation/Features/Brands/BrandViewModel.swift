//
//  BrandViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol BrandViewModelProtocol: ViewModel {
    var cellViewModels: [BrandCellViewModelProtocol] { get }
    var ratios: [(Float, Float)] { get }
    var updateCollectionView: BehaviorRelay<Void?> { get }
    func refreshBrands()
    func didSelect(index: Int)
}

final class BrandViewModel: BrandViewModelProtocol {
    public enum FlowType {
        case change
        case select
    }

    let router: Router
    private let repository: BrandRepository
    private let service: LocationService
    private let type: FlowType
    var cellViewModels: [BrandCellViewModelProtocol] = []
    var ratios: [(Float, Float)] = []
    var updateCollectionView: BehaviorRelay<Void?>
    private var brands: [Brand] = []
    private let didSelectBrand: ((Brand) -> Void)?

    init(router: Router,
         repository: BrandRepository,
         service: LocationService,
         type: FlowType,
         didSelectBrand: ((Brand) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.service = service
        self.type = type
        self.didSelectBrand = didSelectBrand
        updateCollectionView = .init(value: nil)
    }

    func refreshBrands() {
        download()
    }

    func didSelect(index: Int) {
        let brand = brands[index]
        repository.changeCurrent(brand: brand)
        didSelectBrand?(brand)
        switch type {
        case .change:
            router.dismiss()
        case .select:
            let context = BrandsRouter.RouteType.map
            router.enqueueRoute(with: context)
        }
    }

    private func download() {
        startAnimation()
//        firstly {
//            repository.downloadBrands()
//        }.done {
//            self.cellViewModels = $0.0
//                .map { BrandUI(from: $0) }
//                .map { BrandCellViewModel(router: self.router,
//                                          brand: $0) }
//            self.ratios = $0.1
//            self.brands = $0.0.map { BrandUI(from: $0) }
//        }.catch {
//            self.router.alert(error: $0)
//        }.finally {
//            self.stopAnimation()
//            self.updateCollectionView.accept(())
//        }
    }
}
