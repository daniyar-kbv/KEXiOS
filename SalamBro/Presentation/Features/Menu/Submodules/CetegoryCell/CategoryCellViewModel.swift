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
}

final class CategoryCellViewModel: CategoryCellViewModelProtocol {
    var router: Router
    var categoryTitle: BehaviorRelay<String?>

    init(router: Router,
         category: FoodTypeUI)
    {
        self.router = router
        categoryTitle = .init(value: category.title)
    }
}
