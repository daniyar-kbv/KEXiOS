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
    var adName: BehaviorRelay<String?>
    
    init(ad: AdUI) {
        adName = .init(value: ad.name)
    }
}
