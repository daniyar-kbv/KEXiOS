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
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    let position: OrderProductResponse.Data.Position
    
    let itemImageURL: BehaviorRelay<URL?>
    let itemTitle: BehaviorRelay<String?>
    let itemDescription: BehaviorRelay<String?>
    let itemPrice: BehaviorRelay<String?>

    init(position: OrderProductResponse.Data.Position) {
        self.position = position
        
        itemImageURL = .init(value: URL(string: position.image ?? ""))
        itemTitle = .init(value: position.name)
        itemDescription = .init(value: position.description)
        itemPrice = .init(value: "\(position.price.removeTrailingZeros()) ₸") // здесь надо юзать локализацию
    }
}
