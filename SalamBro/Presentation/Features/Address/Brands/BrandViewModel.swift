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
    var outputs: BrandViewModel.Outputs { get }

    var brands: [Brand] { get }
    var ratios: [(CGFloat, CGFloat)] { get }

    func getBrands()
    func didSelect(index: Int)
}

final class BrandViewModel: BrandViewModelProtocol {
    private(set) var outputs: Outputs = .init()

    private let cityId: Int
    private let disposeBag = DisposeBag()

    private let repository: BrandRepository

    private(set) var brands: [Brand] = [] {
        didSet {
            updateRatio()
        }
    }

    private var cellSizeSequence: [BrandCellSizeType] = [.square, .horizontalShort, .vertical, .square, .square, .horizontalLong]
    var ratios: [(CGFloat, CGFloat)] = []

    init(brandRepository: BrandRepository, cityId: Int) {
        self.cityId = cityId
        repository = brandRepository
        bindOutputs()
    }

    private func bindOutputs() {
        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didGetBrands.bind {
            [weak self] brands in
            self?.brands = brands
            self?.repository.setBrands(brands: brands)
            self?.outputs.didGetBrands.accept(())
        }
        .disposed(by: disposeBag)

        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)
    }

    func getBrands() {
        repository.fetchBrands(with: cityId)
    }

    private func updateRatio() {
        for index in 0 ..< brands.count {
            ratios.append(cellSizeSequence[index % cellSizeSequence.count].ratio)
        }

        outputs.didGetBrands.accept(())
    }

    func didSelect(index: Int) {
        let brand = brands[index]
        repository.changeCurrentBrand(to: brand)
        outputs.didSelectBrand.accept(brand)
    }
}

extension BrandViewModel {
    struct Outputs {
        let didStartRequest = PublishRelay<Void>()
        let didGetBrands = BehaviorRelay<Void>(value: ())
        let didSelectBrand = PublishRelay<Brand>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didEndRequest = PublishRelay<Void>()
    }
}

extension BrandViewModel {
    private enum FlowType {
        case firstFlow
        case changeAddress(didSelectAddress: ((Address) -> Void)?)
        case changeBrand(didSave: (() -> Void)?)
    }

    private enum BrandCellSizeType {
        case square
        case horizontalShort
        case horizontalLong
        case vertical

//        MARK: Size rations according to design

        private static let fullSize: CGFloat = 343

        var ratio: (CGFloat, CGFloat) {
            switch self {
            case .square:
                return (146 / Self.fullSize,
                        146 / Self.fullSize)
            case .horizontalShort:
                return (197 / Self.fullSize,
                        146 / Self.fullSize)
            case .horizontalLong:
                return (Self.fullSize / Self.fullSize,
                        146 / Self.fullSize)
            case .vertical:
                return (197 / Self.fullSize,
                        292 / Self.fullSize)
            }
        }
    }
}
