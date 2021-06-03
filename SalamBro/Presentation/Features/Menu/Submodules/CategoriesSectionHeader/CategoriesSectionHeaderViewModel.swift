//
//  CategoriesSectionHeaderViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol CategoriesSectionHeaderViewModelProtocol: ViewModel {
    var cellViewModels: [CategoryCellViewModelProtocol] { get }
}

final class CategoriesSectionHeaderViewModel: CategoriesSectionHeaderViewModelProtocol {
    var cellViewModels: [CategoryCellViewModelProtocol]
    
    init(categories: [FoodTypeUI]){
        cellViewModels = categories.map { CategoryCellViewModel(category: $0) }
    }
}
