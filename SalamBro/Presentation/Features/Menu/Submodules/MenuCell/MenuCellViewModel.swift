//
//  MenuCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol MenuCellViewModelProtocol: ViewModel {
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
}

public final class MenuCellViewModel: MenuCellViewModelProtocol {
    public var itemTitle: BehaviorRelay<String?>
    public var itemDescription: BehaviorRelay<String?>
    public var itemPrice: BehaviorRelay<String?>

    public init(food: FoodUI) {
        itemTitle = .init(value: food.title)
        itemDescription = .init(value: food.description)
        itemPrice = .init(value: "\(food.price) T") // здесь надо юзать локализацию
    }
}
