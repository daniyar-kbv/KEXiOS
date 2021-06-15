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
    var category: OrderProductResponse.Category { get }
    var categoryTitle: BehaviorRelay<String?> { get }
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    let category: OrderProductResponse.Category
    
    var categoryTitle: BehaviorRelay<String?>

    init(category: OrderProductResponse.Category) {
        self.category = category
        
        categoryTitle = .init(value: category.name)
    }
}
