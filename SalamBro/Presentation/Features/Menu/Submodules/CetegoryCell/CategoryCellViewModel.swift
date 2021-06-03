//
//  CategoryCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol CategoryCellViewModelProtocol: ViewModel {
    var categoryTitle: BehaviorRelay<String?> { get }
    var categoryPosition: Int { get }
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    var categoryTitle: BehaviorRelay<String?>
    var categoryPosition: Int

    init(category: FoodTypeUI) {
        categoryPosition = .init(category.position)
        categoryTitle = .init(value: category.title)
    }
}
