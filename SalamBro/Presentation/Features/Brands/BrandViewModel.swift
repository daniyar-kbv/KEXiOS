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

public protocol BrandViewModelProtocol: ViewModel {
    var cellViewModels: [BrandCellViewModelProtocol] { get }
    var ratios: [(Float, Float)] { get }
    var updateCollectionView: BehaviorRelay<Void?> { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    func refresh()
}

public final class BrandViewModel: BrandViewModelProtocol {
    private let repository: BrandRepository
    public var cellViewModels: [BrandCellViewModelProtocol]
    public var ratios: [(Float, Float)]
    public var updateCollectionView: BehaviorRelay<Void?>
    public var isAnimating: BehaviorRelay<Bool>

    public init(repository: BrandRepository) {
        self.repository = repository
        cellViewModels = []
        ratios = []
        updateCollectionView = .init(value: nil)
        isAnimating = .init(value: false)
        download()
    }

    public func refresh() {
        download()
    }

    private func download() {
        isAnimating.accept(true)
        firstly {
            repository.downloadBrands()
        }.done {
            self.cellViewModels = $0.0
                .map { BrandUI(from: $0) }
                .map { BrandCellViewModel(brand: $0) }
            self.ratios = $0.1
        }.catch { _ in
            // TODO:
        }.finally {
            self.isAnimating.accept(false)
            self.updateCollectionView.accept(())
        }
    }
}
