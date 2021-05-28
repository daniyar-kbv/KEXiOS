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
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    var router: Router
    var itemTitle: BehaviorRelay<String?>
    var itemDescription: BehaviorRelay<String?>
    var itemPrice: BehaviorRelay<String?>

    init(router: Router,
         food: FoodUI)
    {
        self.router = router
        itemTitle = .init(value: food.title)
        itemDescription = .init(value: food.description)
        itemPrice = .init(value: "\(food.price) ₸") // здесь надо юзать локализацию
    }
}
