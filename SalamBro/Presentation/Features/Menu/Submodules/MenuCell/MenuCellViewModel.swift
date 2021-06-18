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
    var position: OrderProductResponse.Data.Position { get }

    var itemImageURL: BehaviorRelay<URL?> { get }
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }

    func reload()
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    let position: OrderProductResponse.Data.Position

    let itemImageURL = BehaviorRelay<URL?>(value: nil)
    let itemTitle = BehaviorRelay<String?>(value: nil)
    let itemDescription = BehaviorRelay<String?>(value: nil)
    let itemPrice = BehaviorRelay<String?>(value: nil)

    init(position: OrderProductResponse.Data.Position) {
        self.position = position
    }

    func reload() {
        itemImageURL.accept(URL(string: position.image ?? ""))
        itemTitle.accept(position.name)
        itemDescription.accept(position.description)
        itemPrice.accept("\(position.price.removeTrailingZeros()) ₸") // здесь надо юзать локализацию
    }
}
