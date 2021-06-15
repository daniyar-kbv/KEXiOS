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
    var position: OrderProductResponse.Position { get }
    var itemTitle: BehaviorRelay<String?> { get }
    var itemDescription: BehaviorRelay<String?> { get }
    var itemPrice: BehaviorRelay<String?> { get }
}

final class MenuCellViewModel: MenuCellViewModelProtocol {
    let position: OrderProductResponse.Position
    
    let itemTitle: BehaviorRelay<String?>
    let itemDescription: BehaviorRelay<String?>
    let itemPrice: BehaviorRelay<String?>

    init(position: OrderProductResponse.Position) {
        self.position = position
        
        itemTitle = .init(value: position.name)
        itemDescription = .init(value: position.description)
        itemPrice = .init(value: "\(position.price) ₸") // здесь надо юзать локализацию
    }
}
