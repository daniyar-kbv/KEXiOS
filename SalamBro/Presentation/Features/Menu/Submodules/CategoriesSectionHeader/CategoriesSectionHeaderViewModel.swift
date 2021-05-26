//
//  CategoriesSectionHeaderViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation

protocol CategoriesSectionHeaderViewModelProtocol: ViewModel {
    var cellViewModels: [CategoryCellViewModelProtocol] { get }
}

final class CategoriesSectionHeaderViewModel: CategoriesSectionHeaderViewModelProtocol {
    var router: Router
    var cellViewModels: [CategoryCellViewModelProtocol]
    init(router: Router,
         categories: [FoodTypeUI])
    {
        self.router = router
        cellViewModels = categories.map { CategoryCellViewModel(router: router,
                                                                category: $0) }
    }
}
