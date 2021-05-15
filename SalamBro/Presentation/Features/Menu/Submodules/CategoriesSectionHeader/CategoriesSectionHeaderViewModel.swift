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
    public var router: Router
    public var cellViewModels: [CategoryCellViewModelProtocol]
    public init(router: Router,
                categories: [FoodTypeUI])
    {
        self.router = router
        cellViewModels = categories.map { CategoryCellViewModel(router: router,
                                                                category: $0) }
    }
}
