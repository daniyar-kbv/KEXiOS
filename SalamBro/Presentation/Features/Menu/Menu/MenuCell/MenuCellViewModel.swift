//
//  MenuCellViewModel.swift
//  SalamBro
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuCellViewModelProtocol: ViewModel {
    var position: MenuPosition { get }

    var itemImageURL: BehaviorRelay<URL?> { get }
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
    var itemStatus: BehaviorRelay<Bool?> { get }

    func reload()
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    let position: MenuPosition

    let itemImageURL = BehaviorRelay<URL?>(value: nil)
    let itemTitle = BehaviorRelay<String?>(value: nil)
    let itemDescription = BehaviorRelay<String?>(value: nil)
    let itemPrice = BehaviorRelay<String?>(value: nil)
    let itemStatus = BehaviorRelay<Bool?>(value: nil)

    init(position: MenuPosition) {
        self.position = position
    }

    func reload() {
        itemImageURL.accept(URL(string: position.imageSmall ?? ""))
        itemTitle.accept(position.name)
        itemDescription.accept(position.description)
        itemStatus.accept(position.status)
        itemPrice.accept(SBLocalization.localized(key: MenuText.Menu.MenuItem.price,
                                                  arguments: position.price?.removeTrailingZeros() ?? ""))
    }
}
