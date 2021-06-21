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
    
    func getIndex(of category: String) -> Int?
    func getCategory(by index: Int) -> String
}

final class CategoriesSectionHeaderViewModel: CategoriesSectionHeaderViewModelProtocol {
    var cellViewModels: [CategoryCellViewModelProtocol]

    init(categories: [OrderProductResponse.Data.Category]) {
        cellViewModels = categories.map { CategoryCellViewModel(category: $0) }
    }
    
    func getIndex(of category: String) -> Int? {
        return cellViewModels.map() {
            $0.category
        }.firstIndex(where: {
            $0.uuid == category
        })
    }
    
    func getCategory(by index: Int) -> String {
        return cellViewModels[index].category.uuid
    }
}
