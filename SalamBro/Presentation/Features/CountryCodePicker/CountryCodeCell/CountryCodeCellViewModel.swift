//
//  Countr.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 02.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol CountryCodeCellViewModelProtocol: ViewModel {
    var title: BehaviorRelay<String?> { get }
    var code: BehaviorRelay<String?> { get }
    var isSelected: BehaviorRelay<Bool> { get }
}

final class CountryCodeCellViewModel: CountryCodeCellViewModelProtocol {
    let router: Router
    var title: BehaviorRelay<String?>
    var code: BehaviorRelay<String?>
    var isSelected: BehaviorRelay<Bool>

    init(router: Router,
         country: Country,
         isSelected: Bool)
    {
        self.router = router
        title = .init(value: country.name)
        code = .init(value: country.countryCode)
        self.isSelected = .init(value: isSelected)
    }
}
