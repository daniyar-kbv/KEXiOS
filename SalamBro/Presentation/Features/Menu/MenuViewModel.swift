//
//  MenuViewModel.swift
//  SalamBro
//
//  Created by Arystan on 4/30/21.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

public protocol MenuViewModelProtocol: AnyObject {
    var headerViewModels: [ViewModel?] { get }
    var cellViewModels: [[ViewModel]] { get }
    var updateTableView: BehaviorRelay<Void?> { get }
    var isAnimating: BehaviorRelay<Bool> { get }
    func update()
}

public final class MenuViewModel: MenuViewModelProtocol {
    private let menuRepository: MenuRepository
    public var headerViewModels: [ViewModel?]
    public var cellViewModels: [[ViewModel]]
    public var updateTableView: BehaviorRelay<Void?>
    public var isAnimating: BehaviorRelay<Bool>

    public func update() {
        download()
    }

    private func download() {
        firstly {
            self.menuRepository.downloadMenuCategories()
        }.done {
            self.headerViewModels = [
                nil,
                CategoriesSectionHeaderViewModel(categories: $0.map { FoodTypeUI(from: $0) }),
            ]
        }.then {
            self.menuRepository.downloadMenuAds()
        }.done {
            self.cellViewModels.append([
                AddressPickCellViewModel(),
                AdCollectionCellViewModel(ads: $0.map { AdUI(from: $0) }),
            ])
        }.then {
            self.menuRepository.downloadMenuItems()
        }.done {
            self.cellViewModels.append($0.map { FoodUI(from: $0) }
                .map { MenuCellViewModel(food: $0) })
        }.catch {
            print($0)
            // TODO: - написать обработку и презентацию ошибок
        }.finally {
            self.updateTableView.accept(())
        }
    }

    init(menuRepository: MenuRepository) {
        cellViewModels = []
        headerViewModels = []
        updateTableView = .init(value: nil)
        isAnimating = .init(value: false)
        self.menuRepository = menuRepository
        download()
    }
}
