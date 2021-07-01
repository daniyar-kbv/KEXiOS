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
    var category: MenuCategory { get }
    var categoryTitle: BehaviorRelay<String> { get }
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    let category: MenuCategory

    var categoryTitle: BehaviorRelay<String>

    init(category: MenuCategory) {
        self.category = category

        categoryTitle = .init(value: category.name)
    }
}
