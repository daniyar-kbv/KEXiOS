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
    private let menuService: MenuService
    private var modifierGroups: [ModifierGroup] = []

    init(menuService: MenuService) {
        self.menuService = menuService
    }

    func getProductDetail(for leadUUID: String, by positionUUID: String) {
        outputs.didStartRequest.accept(())
        menuService.getProductDetail(for: leadUUID, by: positionUUID)
            .subscribe(onSuccess: { [weak self] position in
                self?.outputs.didEndRequest.accept(())
                self?.modifierGroups = position.modifierGroups

                self?.outputs.didGetProductDetail.accept(position)
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
