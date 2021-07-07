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
    var modifierCellViewModels: [[MenuDetailModifierCellViewModel]] { get set }

    func update()
    func proceed()
    func set(comment: String)
    func getComment() -> String?
    func set(modifier: Modifier, at indexPath: IndexPath)
}

final class MenuDetailViewModelImpl: MenuDetailViewModel {
    private let positionUUID: String
    private let defaultStorage: DefaultStorage
    private let menuDetailRepository: MenuDetailRepository
    private let cartRepository: CartRepository

    private let disposeBag = DisposeBag()

    private var position: MenuPositionDetail?
    private var comment: String?

    var modifierCellViewModels: [[MenuDetailModifierCellViewModel]] = []
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

    func set(modifier: Modifier, at indexPath: IndexPath) {
        check()
        outputs.didSelectModifier.accept((modifier, indexPath))
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
    }

    private func download() {
        guard let leadUUID = defaultStorage.leadUUID else { return }

        menuDetailRepository.getProductDetail(for: leadUUID, by: positionUUID)
    }

    private func process(position: MenuPositionDetail) {
        self.position = position

        outputs.itemImage.accept(URL(string: position.image ?? ""))
        outputs.itemTitle.accept(position.name)
        outputs.itemDescription.accept(position.description)
        outputs.itemPrice.accept("\(L10n.MenuDetail.proceedButton) \(position.price.removeTrailingZeros())")

        modifierCellViewModels = position.modifierGroups.map { modifierGroup in
            (0 ..< modifierGroup.maxAmount).map { _ in
                MenuDetailModifierCellViewModelImpl(modifierGroup: modifierGroup)
            }
        }

        outputs.updateModifiers.accept(())
        check()
    }

    private func check() {
        outputs.isComplete.accept(!modifierCellViewModels.flatMap { $0 }.contains(where: { $0.didSelect() == false }))
    }

    private func getSelectedModifiers() -> [Modifier] {
        return modifierCellViewModels.flatMap { $0 }.map { $0.getValue() }.filter { $0 != nil } as! [Modifier]
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
