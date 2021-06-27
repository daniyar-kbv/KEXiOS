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
    var category: OrderProductResponse.Data.Category { get }
    var categoryTitle: BehaviorRelay<String> { get }
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    let category: OrderProductResponse.Data.Category

    var categoryTitle: BehaviorRelay<String>

    init(category: OrderProductResponse.Data.Category) {
        self.category = category

        categoryTitle = .init(value: category.name)
    }
}
