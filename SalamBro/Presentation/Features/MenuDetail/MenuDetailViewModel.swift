//
//  MenuItemDetailViewModel.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

public protocol MenuDetailViewModelProtocol: AnyObject {
    var coordinator: MenuDetailCoordinator { get }
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
    func update()
}

public final class MenuDetailViewModel: MenuDetailViewModelProtocol {
    private let menuDetailRepository: MenuDetailRepository
    public var coordinator: MenuDetailCoordinator
    public var itemTitle: BehaviorRelay<String?>
    public var itemDescription: BehaviorRelay<String?>
    public var itemPrice: BehaviorRelay<String?>

    public func update() {
        download()
    }

    private func download() {
        firstly {
            self.menuDetailRepository.downloadMenuDetail()
        }.done {
            self.itemTitle.accept("\($0.title)")
            self.itemDescription.accept("\($0.description)")
            self.itemPrice.accept(L10n.MenuDetail.proceedButton + " \($0.price) ₸")
        }.catch {
            print($0)
            // TODO: - написать обработку и презентацию ошибок
        }.finally {}
    }

    init(coordinator: MenuDetailCoordinator, menuDetailRepository: MenuDetailRepository) {
        self.coordinator = coordinator
        itemTitle = .init(value: nil)
        itemDescription = .init(value: nil)
        itemPrice = .init(value: nil)
        self.menuDetailRepository = menuDetailRepository
        download()
    }

    public func bindData(food: FoodUI) {
        itemTitle = .init(value: food.title)
        itemDescription = .init(value: food.description)
        itemPrice = .init(value: "\(food.price) T") // здесь надо юзать локализацию
    }
}
