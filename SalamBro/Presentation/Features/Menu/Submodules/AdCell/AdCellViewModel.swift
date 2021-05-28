//
//  AdCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdCellViewModelProtocol: ViewModel {
    var adName: BehaviorRelay<String?> { get }
}

final class AdCellViewModel: AdCellViewModelProtocol {
    var router: Router
    var adName: BehaviorRelay<String?>
    init(router: Router,
         ad: AdUI)
    {
        self.router = router
        adName = .init(value: ad.name)
    }
}
