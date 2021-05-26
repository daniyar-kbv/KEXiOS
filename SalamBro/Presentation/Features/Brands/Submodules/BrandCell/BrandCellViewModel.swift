//
//  BrandCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol BrandCellViewModelProtocol: ViewModel {
    var name: BehaviorRelay<String> { get }
}

final class BrandCellViewModel: BrandCellViewModelProtocol {
    var router: Router
    var name: BehaviorRelay<String>
    init(router: Router,
         brand: BrandUI)
    {
        self.router = router
        name = .init(value: brand.name + brand.priority.description)
    }
}
