//
//  AdCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol AdCellViewModelProtocol: ViewModel {
    var adName: BehaviorRelay<String?> { get }
}

public final class AdCellViewModel: AdCellViewModelProtocol {
    public var adName: BehaviorRelay<String?>
    public init(ad: Ad) {
        self.adName = .init(value: ad.name)
    }
}
