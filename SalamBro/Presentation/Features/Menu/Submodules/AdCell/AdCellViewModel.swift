//
//  AdCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol AdCellViewModelProtocol: ViewModel {
    var adName: BehaviorRelay<String?> { get }
}

public final class AdCellViewModel: AdCellViewModelProtocol {
    public var adName: BehaviorRelay<String?>
    public init(ad: AdUI) {
        adName = .init(value: ad.name)
    }
}
