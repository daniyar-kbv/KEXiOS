//
//  MenuDetailRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/7/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuDetailRepository: AnyObject {
    var outputs: MenuDetailRepositoryImpl.Output { get }

    func getProductDetail(for leadUUID: String, by positionUUID: String)
    func setSelectedModifiers(for modifiers: [Modifier], with selectedModifiers: [Modifier], at uuid: String, totalCount: Int)
}

final class MenuDetailRepositoryImpl: MenuDetailRepository {
    private let disposeBag = DisposeBag()
    private(set) var outputs: Output = .init()
    private let ordersService: OrdersService
    private var modifierGroups: [ModifierGroup] = []

    private let mockModifierGroups: [ModifierGroup] = [
        .init(uuid: "1",
              name: "Выберите напиток",
              minAmount: 1,
              maxAmount: 7,
              isRequired: true,
              modifiers: [
                  .init(name: "Кола",
                        uuid: "1",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола2",
                        uuid: "2",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола3",
                        uuid: "3",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола4",
                        uuid: "4",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола5",
                        uuid: "5",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола7",
                        uuid: "6",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Кола8",
                        uuid: "7",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Спрайт",
                        uuid: "2",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Фанта",
                        uuid: "3",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
              ]),
        .init(uuid: "2",
              name: "Выберите напиток",
              minAmount: 1,
              maxAmount: 3,
              isRequired: true,
              modifiers: [
                  .init(name: "Кола",
                        uuid: "4",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Спрайт",
                        uuid: "5",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Фанта",
                        uuid: "6",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
              ]),
        .init(uuid: "3",
              name: "Выберите напиток",
              minAmount: 0,
              maxAmount: 3,
              isRequired: false,
              modifiers: [
                  .init(name: "Кола",
                        uuid: "7",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Спрайт",
                        uuid: "8",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
                  .init(name: "Фанта",
                        uuid: "9",
                        image: "https://media.istockphoto.com/photos/coke-picture-id458548157"),
              ]),
    ]

    private let mockPosition: MenuPositionDetail?

    init(ordersService: OrdersService) {
        self.ordersService = ordersService
        mockPosition = MenuPositionDetail(uuid: "1", name: "Коктейль Попкорн", description: "Ho", image: "", price: 450, categoryUUID: "bd260a51-6552-47be-9c5f-784c00dbea30", modifierGroups: mockModifierGroups)
    }

    func getProductDetail(for leadUUID: String, by positionUUID: String) {
        guard let mockPosition = mockPosition else { return }
        outputs.didStartRequest.accept(())
        ordersService.getProductDetail(for: leadUUID, by: positionUUID)
            .subscribe(onSuccess: { [weak self] _ in
                self?.outputs.didEndRequest.accept(())
                self?.modifierGroups = mockPosition.modifierGroups
                self?.outputs.didGetProductDetail.accept(mockPosition)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                guard let error = error as? ErrorPresentable else { return }
                self?.outputs.didFail.accept(error)
            }).disposed(by: disposeBag)
    }

    func setSelectedModifiers(for modifiers: [Modifier], with selectedModifiers: [Modifier], at uuid: String, totalCount: Int) {
        guard let index = modifierGroups.firstIndex(where: { $0.uuid == uuid }) else { return }
        modifierGroups[index].set(modifiers: modifiers)
        modifierGroups[index].set(selectedModifiers: selectedModifiers)
        modifierGroups[index].set(totalCount: totalCount)
        outputs.updateSelectedModifiers.accept(modifierGroups)
    }
}

extension MenuDetailRepositoryImpl {
    struct Output {
        let didGetProductDetail = PublishRelay<MenuPositionDetail>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let updateSelectedModifiers = PublishRelay<[ModifierGroup]>()
    }
}
