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
            comment: comment,
            description: position.description,
            type: .main
        ))
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

        menuDetailRepository.outputs.didGetProductDetail
            .bind { [weak self] position in
                self?.outputs.didGetProductDetail.accept(())
                self?.process(position: position)
            }
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.didFail
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.didGetBranchClosed
            .bind(to: outputs.didGetBranchClosed)
            .disposed(by: disposeBag)

        menuDetailRepository.outputs.updateSelectedModifiers.bind {
            [weak self] modifierGroups in
            self?.position?.modifierGroups = modifierGroups
            self?.assignSelectedModifiers()
            self?.check()
            self?.outputs.updateModifiers.accept(())
        }
        .disposed(by: disposeBag)

        cartRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        cartRepository.outputs.didAdd
            .subscribe(onNext: { [weak self] in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didProceed.accept(())
            }).disposed(by: disposeBag)

        cartRepository.outputs.didGetBranchClosed
            .bind(to: outputs.didGetBranchClosed)
            .disposed(by: disposeBag)

        cartRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)
    }

    private func download() {
        guard let leadUUID = defaultStorage.leadUUID else { return }
        menuDetailRepository.getProductDetail(for: leadUUID, by: positionUUID)
    }

    private func process(position: MenuPositionDetail) {
        self.position = position

        outputs.itemImage.accept(URL(string: position.imageSmall ?? ""))
        outputs.itemTitle.accept(position.name)
        outputs.itemDescription.accept(position.description)
        outputs.itemPrice.accept(SBLocalization.localized(key: MenuText.MenuDetail.proceedButton, arguments: position.price.removeTrailingZeros()))

        if position.modifierGroups.isEmpty {
            outputs.isComplete.accept(true)
        } else {
            outputs.isComplete.accept(false)
            assignSelectedModifiers()
            check()
            outputs.updateModifiers.accept(())
        }
    }

    private func assignSelectedModifiers() {
        if let position = position {
            modifierCellViewModels = position.modifierGroups.map {
                MenuDetailModifierCellViewModelImpl(modifierGroup: $0)
            }
        }
    }

    private func check() {
        guard let isComplete = position?.modifierGroups
            .filter({ $0.isRequired &&
                    $0.selectedModifiers.map { $0.itemCount }.reduce(0, +) < $0.minAmount })
            .isEmpty
        else { return }
        outputs.isComplete.accept(isComplete)
    }

    private func getSelectedModifiers() -> [Modifier] {
        return modifierCellViewModels.compactMap { $0.getValue() }
    }
}

extension MenuDetailViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable?>()
        let didGetProductDetail = PublishRelay<Void>()

        let comment = PublishRelay<String>()
        let itemImage = PublishRelay<URL?>()
        let itemTitle = PublishRelay<String?>()
        let itemDescription = PublishRelay<String?>()
        let itemPrice = PublishRelay<String?>()
        let updateModifiers = PublishRelay<Void>()

        let didProceed = PublishRelay<Void>()
        let isComplete = PublishRelay<Bool>()

        let didGetBranchClosed = PublishRelay<ErrorPresentable>()
    }
}
