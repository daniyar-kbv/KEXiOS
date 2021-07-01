//
//  MenuItemDetailViewModel.swift
//  SalamBro
//
//  Created by Arystan on 5/3/21.
//

import Foundation
import PromiseKit
import RxCocoa
import RxSwift

protocol MenuDetailViewModel: AnyObject {
    var outputs: MenuDetailViewModelImpl.Output { get }
    var modifierGroups: [ModifierGroup] { get set }

    func update()
    func proceed()
    func set(comment: String)
    func set(modifier: Modifier, at indexPath: IndexPath)
}

final class MenuDetailViewModelImpl: MenuDetailViewModel {
    private let positionUUID: String
    private let defaultStorage: DefaultStorage
    private let ordersService: OrdersService
    private let cartRepository: CartRepository

    private let disposeBag = DisposeBag()
    private var position: MenuPositionDetail? {
        didSet {
            outputs.itemImage.accept(URL(string: position?.image ?? ""))
            outputs.itemTitle.accept(position?.name)
            outputs.itemDescription.accept(position?.description)
            outputs.itemPrice.accept("\(L10n.MenuDetail.proceedButton) \(position?.price.removeTrailingZeros() ?? "")")

//            Tech debt: remove when modifiers added to API
            if let modifierGroups = position?.modifierGroups,
               modifierGroups.count > 0
            {
                self.modifierGroups = modifierGroups
            } else {
                setTestModifiers()
            }
        }
    }

    var modifierGroups = [ModifierGroup]() {
        didSet {
            outputs.updateModifiers.accept(())
            modifierGroups.forEach { _ in selectedModifiers.append([]) }
            check()
        }
    }

    private var selectedModifiers = [[Modifier]]()
    private var comment: String?

    let outputs = Output()

    init(positionUUID: String,
         defaultStorage: DefaultStorage,
         ordersService: OrdersService,
         cartRepository: CartRepository)
    {
        self.positionUUID = positionUUID
        self.defaultStorage = defaultStorage
        self.ordersService = ordersService
        self.cartRepository = cartRepository
    }

    public func update() {
        download()
    }

    private func download() {
        guard let leadUUID = defaultStorage.leadUUID else { return }

        outputs.didStartRequest.accept(())

        ordersService.getProductDetail(for: leadUUID, by: positionUUID)
            .subscribe(onSuccess: { [weak self] position in
                self?.outputs.didEndRequest.accept(())
                self?.position = position
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetError.accept(error as? ErrorPresentable)
            }).disposed(by: disposeBag)
    }

    func proceed() {
        guard let position = position else { return }
        cartRepository.addItem(item: position.toCartItem(
            count: 1,
            comment: comment ?? "",
            modifiers: selectedModifiers.flatMap { $0 }
        ))
        outputs.didProceed.accept(())
    }

    func set(comment: String) {
        self.comment = comment
        outputs.comment.accept(comment)
    }

    func set(modifier: Modifier, at indexPath: IndexPath) {
        selectedModifiers[indexPath.section].append(modifier)
        check()
        outputs.didSelectModifier.accept((modifier, indexPath))
    }

    private func check() {
        outputs.isComplete.accept(!modifierGroups.enumerated()
            .map { index, modifierGroup in
                selectedModifiers[index].count == modifierGroup.maxAmount
            }
            .contains(false))
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

        let didSelectModifier = PublishRelay<(Modifier, IndexPath)>()
        let didProceed = PublishRelay<Void>()
        let isComplete = PublishRelay<Bool>()
    }
}

//  MARK: Test data, remove when modifiers added to API

extension MenuDetailViewModelImpl {
    private func setTestModifiers() {
        var modifierGroups = [ModifierGroup]()

        modifierGroups.append(.init(
            uuid: "testUUID",
            name: "Выберите напиток",
            minAmount: 2,
            maxAmount: 2,
            isRequired: true,
            modifiers: [
                Modifier(name: "Кола",
                         uuid: "testUUID"),
                Modifier(name: "Спрайт",
                         uuid: "testUUID"),
                Modifier(name: "Фанта",
                         uuid: "testUUID"),
                Modifier(name: "Пепси",
                         uuid: "testUUID"),
            ]
        ))

        modifierGroups.append(.init(
            uuid: "testUUID",
            name: "Выберите соус",
            minAmount: 1,
            maxAmount: 1,
            isRequired: true,
            modifiers: [
                Modifier(name: "Сырный",
                         uuid: "testUUID"),
                Modifier(name: "Кетчуп",
                         uuid: "testUUID"),
                Modifier(name: "Барбекю",
                         uuid: "testUUID"),
                Modifier(name: "Чесночный",
                         uuid: "testUUID"),
            ]
        ))

        self.modifierGroups = modifierGroups
    }
}
