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
                self?.process(error: error)
            }).disposed(by: disposeBag)
    }

    func setSelectedModifiers(for modifiers: [Modifier], with selectedModifiers: [Modifier], at uuid: String, totalCount: Int) {
        guard let index = modifierGroups.firstIndex(where: { $0.uuid == uuid }) else { return }
        modifierGroups[index].set(modifiers: modifiers)
        modifierGroups[index].set(selectedModifiers: selectedModifiers)
        modifierGroups[index].set(totalCount: totalCount)
        outputs.updateSelectedModifiers.accept(modifierGroups)
    }

    private func process(error: Error) {
        outputs.didEndRequest.accept(())

        if let error = error as? ErrorPresentable {
            if let errorReponse = (error as? ErrorResponse),
               errorReponse.code == Constants.ErrorCode.branchIsClosed
            {
                outputs.didGetBranchClosed.accept(errorReponse)
                NotificationCenter.default.post(name: Constants.InternalNotification.updateMenu.name, object: nil)
                return
            }
            outputs.didFail.accept(error)
        }
    }
}

extension MenuDetailRepositoryImpl {
    struct Output {
        let didGetProductDetail = PublishRelay<MenuPositionDetail>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didGetBranchClosed = PublishRelay<ErrorResponse>()
        let didEndRequest = PublishRelay<Void>()
        let updateSelectedModifiers = PublishRelay<[ModifierGroup]>()
    }
}
