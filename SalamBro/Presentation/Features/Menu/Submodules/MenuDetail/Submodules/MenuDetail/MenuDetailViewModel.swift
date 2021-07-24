//
//  MenuItemDetailViewModel.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol MenuDetailViewModel: AnyObject {
    var outputs: MenuDetailViewModelImpl.Output { get }
    var modifierCellViewModels: [MenuDetailModifierCellViewModel] { get set }
    var currentModifierGroupIndex: IndexPath? { get set }

    func update()
    func proceed()
    func set(comment: String)
    func getComment() -> String?
}

final class MenuDetailViewModelImpl: MenuDetailViewModel {
    private let positionUUID: String
    private let defaultStorage: DefaultStorage
    private let menuDetailRepository: MenuDetailRepository
    private let cartRepository: CartRepository

    private let disposeBag = DisposeBag()

    private var position: MenuPositionDetail?
    private var comment: String?

    var modifierCellViewModels: [MenuDetailModifierCellViewModel] = []
    var currentModifierGroupIndex: IndexPath?
    let outputs = Output()

    init(positionUUID: String,
         defaultStorage: DefaultStorage,
         menuDetailRepository: MenuDetailRepository,
         cartRepository: CartRepository)
    {
        self.positionUUID = positionUUID
        self.defaultStorage = defaultStorage
        self.menuDetailRepository = menuDetailRepository
        self.cartRepository = cartRepository
        bindOutputs()
    }

    func update() {
        download()
    }

    func proceed() {
        guard let position = position else { return }

        cartRepository.addItem(item: position.toCartItem(
            count: 1,
            comment: comment ?? "",
            modifiers: getSelectedModifiers()
        ))

        outputs.didProceed.accept(())
    }

    func set(comment: String) {
        self.comment = comment
        outputs.comment.accept(comment)
    }

    func getComment() -> String? {
        return comment
    }
}

extension MenuDetailViewModelImpl {
    private func bindOutputs() {
        menuDetailRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.didGetProductDetail.bind {
            [weak self] position in
            self?.outputs.didEndRequest.accept(())
            self?.process(position: position)
        }
        .disposed(by: disposeBag)

        menuDetailRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.updateSelectedModifiers.bind {
            [weak self] modifiers in
            if let index = self?.currentModifierGroupIndex {
                self?.position?.modifierGroups[index.row].selectedModifiers = modifiers
                self?.assignSelectedModifiers()
            }
            self?.check()
            self?.outputs.updateModifiers.accept(())
        }
        .disposed(by: disposeBag)
    }

    private func download() {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        menuDetailRepository.getProductDetail(for: leadUUID, by: positionUUID)
    }

    private func process(position: MenuPositionDetail) {
//        self.position = position
//
//        outputs.itemImage.accept(URL(string: position.image ?? ""))
//        outputs.itemTitle.accept(position.name)
//        outputs.itemDescription.accept(position.description)
//        outputs.itemPrice.accept("\(SBLocalization.localized(key: MenuText.MenuDetail.proceedButton)) \(position.price.removeTrailingZeros())")

//        modifierCellViewModels = position.modifierGroups.map {
//            MenuDetailModifierCellViewModelImpl(modifierGroup: $0)
//        }

        let modifierGroups: [ModifierGroup] = [
            .init(uuid: "1",
                  name: "Выберите напиток",
                  minAmount: 1,
                  maxAmount: 10,
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
                  minAmount: 2,
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

        let position = MenuPositionDetail(uuid: "1", name: "Коктейль Попкорн", description: "Ho", image: "", price: 450, categoryUUID: "bd260a51-6552-47be-9c5f-784c00dbea30", modifierGroups: modifierGroups)

        self.position = position

        outputs.itemImage.accept(URL(string: position.image ?? ""))
        outputs.itemTitle.accept(position.name)
        outputs.itemDescription.accept(position.description)
        outputs.itemPrice.accept("\(SBLocalization.localized(key: MenuText.MenuDetail.proceedButton)) \(position.price.removeTrailingZeros())")

        assignSelectedModifiers()

//        modifierCellViewModels = modifierGroups.map {
//            MenuDetailModifierCellViewModelImpl(modifierGroup: $0)
//        }

        outputs.updateModifiers.accept(())
        outputs.isComplete.accept(false)
    }

    private func assignSelectedModifiers() {
        if let position = position {
            modifierCellViewModels = position.modifierGroups.map {
                MenuDetailModifierCellViewModelImpl(modifierGroup: $0)
            }
        }
    }

    private func check() {
        if let position = position {
            for i in position.modifierGroups {
                if i.isRequired, i.selectedModifiers.isEmpty { return }
                if i.isRequired, !i.selectedModifiers.isEmpty {
                    if i == position.modifierGroups.last {
                        return
                    }
                }
            }
            outputs.isComplete.accept(true)
        }
    }

    private func getSelectedModifiers() -> [Modifier] {
        return modifierCellViewModels
            .map { $0.getValue() }
            .filter { $0 != nil } as! [Modifier]
    }
}

extension MenuDetailViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()

        let comment = PublishRelay<String>()
        let itemImage = PublishRelay<URL?>()
        let itemTitle = PublishRelay<String?>()
        let itemDescription = PublishRelay<String?>()
        let itemPrice = PublishRelay<String?>()
        let updateModifiers = PublishRelay<Void>()

        let didProceed = PublishRelay<Void>()
        let isComplete = PublishRelay<Bool>()
    }
}
