//
//  PaymentEditViewModel.swift
//  SalamBro
//
//  Created by Dan on 7/29/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PaymentEditViewModel: AnyObject {
    var outputs: PaymentEditViewModelImpl.Output { get }

    func deleteCards()

    func getCards()
    func numberOfRows() -> Int
    func cellInfo(for row: Int) -> (cardTitle: String, isSelected: Bool)
    func selectCard(at row: Int)
}

final class PaymentEditViewModelImpl: PaymentEditViewModel {
    private let disposeBag = DisposeBag()
    private let paymentRepository: PaymentRepository
    private var cards: [(card: MyCard, isSelected: Bool)] = []

    let outputs = Output()

    init(paymentRepository: PaymentRepository) {
        self.paymentRepository = paymentRepository

        bindPaymentRepository()
    }

    private func bindPaymentRepository() {
        paymentRepository.outputs
            .didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs
            .didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        paymentRepository.outputs
            .didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        paymentRepository.outputs
            .savedCards
            .subscribe(onNext: { [weak self] cards in
                self?.process(cards: cards)
            })
            .disposed(by: disposeBag)
    }

    private func process(cards: [MyCard]) {
        guard !cards.isEmpty else {
            outputs.needsClose.accept(())
            return
        }

        self.cards = cards
            .map { card in (
                card,
                self.cards.filter { $0.isSelected }.contains(where: { $0.card == card })
            ) }
        outputs.needsUpdate.accept(())
    }
}

extension PaymentEditViewModelImpl {
    func getCards() {
        paymentRepository.getPaymentMethods()
    }

    func numberOfRows() -> Int {
        return cards.count
    }

    func cellInfo(for row: Int) -> (cardTitle: String, isSelected: Bool) {
        let card = cards[row]
        let cardTitle = SBLocalization.localized(key: PaymentText.PaymentEdit.cellTitle,
                                                 arguments: card.card.cardMaskedNumber)
        return (cardTitle, card.isSelected)
    }

    func selectCard(at row: Int) {
        cards[row].isSelected.toggle()
        outputs.needsUpdate.accept(())
        outputs.canDelete.accept(cards.contains(where: { $0.isSelected }))
    }

    func deleteCards() {
        let uuids = cards
            .filter { $0.isSelected }
            .map { $0.card.uuid }
        paymentRepository.deleteCards(with: uuids)
    }
}

extension PaymentEditViewModelImpl {
    struct Output {
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
        let needsClose = PublishRelay<Void>()
        let needsUpdate = PublishRelay<Void>()
        let canDelete = BehaviorRelay<Bool>(value: false)
    }
}
