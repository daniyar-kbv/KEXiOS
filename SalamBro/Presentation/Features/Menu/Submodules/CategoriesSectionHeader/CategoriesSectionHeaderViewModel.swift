//
//  CategoriesSectionHeaderViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

public protocol CategoriesSectionHeaderViewModelProtocol: ViewModel {
    var cellViewModels: [CategoryCellViewModelProtocol] { get }
}

public final class CategoriesSectionHeaderViewModel: CategoriesSectionHeaderViewModelProtocol {
    public var cellViewModels: [CategoryCellViewModelProtocol]
    public init(categories: [FoodType]) {
        self.cellViewModels = categories.map { CategoryCellViewModel(category: $0) }
    }
}
