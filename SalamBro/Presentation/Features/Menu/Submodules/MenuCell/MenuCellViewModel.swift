//
//  MenuCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuCellViewModelProtocol: ViewModel {
    var categoryPosition: Int { get }
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    var categoryPosition: Int
    var itemTitle: BehaviorRelay<String?>
    var itemDescription: BehaviorRelay<String?>
    var itemPrice: BehaviorRelay<String?>

    init(categoryPosition: Int, food: FoodUI) {
        self.categoryPosition = categoryPosition
        itemTitle = .init(value: food.title)
        itemDescription = .init(value: food.description)
        itemPrice = .init(value: "\(food.price) ₸") // здесь надо юзать локализацию
    }
}
