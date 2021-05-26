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
    func refresh()
    func didSelect(index: Int)
}

final class BrandViewModel: BrandViewModelProtocol {
    public enum FlowType {
        case change
        case select
    }

    var router: Router
    private let repository: BrandRepository
    private let type: FlowType
    public var cellViewModels: [BrandCellViewModelProtocol]
    public var ratios: [(Float, Float)]
    public var updateCollectionView: BehaviorRelay<Void?>
    private var brands: [BrandUI]
    private let didSelectBrand: ((BrandUI) -> Void)?

    public init(router: Router,
                repository: BrandRepository,
                type: FlowType,
                didSelectBrand: ((BrandUI) -> Void)?)
    {
        self.router = router
        self.repository = repository
        self.type = type
        self.didSelectBrand = didSelectBrand
        cellViewModels = []
        ratios = []
        brands = []
        updateCollectionView = .init(value: nil)
        download()
    }

    public func refresh() {
        download()
    }

    public func didSelect(index: Int) {
        let brand = brands[index]
        repository.brand = brand.toDomain()
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
        firstly {
            repository.downloadBrands()
        }.done {
            self.cellViewModels = $0.0
                .map { BrandUI(from: $0) }
                .map { BrandCellViewModel(router: self.router,
                                          brand: $0) }
            self.ratios = $0.1
            self.brands = $0.0.map { BrandUI(from: $0) }
        }.catch {
            self.router.alert(error: $0)
        }.finally {
            self.stopAnimation()
            self.updateCollectionView.accept(())
        }
    }
}
