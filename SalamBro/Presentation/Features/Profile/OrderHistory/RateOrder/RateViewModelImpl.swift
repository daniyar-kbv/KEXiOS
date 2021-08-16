//
//  RateViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/18/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol RateViewModel: AnyObject {
    var outputs: RateViewModelImpl.Output { get }
    var currentChoices: [RateItem] { get }

    func getRateChoices()
    func getRateItem(at index: Int) -> RateItem
    func changeDataSet(by rating: Int)
    func configureDataSet(at index: Int)
    func setOrderNumber(with orderNumber: Int)
    func sendUserRate(stars: Int, comment: String)
}

final class RateViewModelImpl: RateViewModel {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()

    private var rateChoices: [RateStarList] = []
    private(set) var currentChoices: [RateItem] = []
    private var selectedChoices: [RateItem] = []

    private let repository: RateOrderRepository

    private var orderNumber: Int?

    init(repository: RateOrderRepository) {
        self.repository = repository
        bindOutputs()
    }

    func getRateChoices() {
        repository.fetchRates()
    }

    func getRateItem(at index: Int) -> RateItem {
        return currentChoices[index]
    }

    func changeDataSet(by rating: Int) {
        currentChoices = []
        guard let choices = rateChoices.first(where: { $0.value == rating }) else { return }
        currentChoices = choices.samples.map { sample in
            .init(sample: sample,
                  isSelected: selectedChoices.contains(where: { $0.sample.id == sample.id }))
        }
        outputs.didGetQuestionTitle.accept(choices.title)
        outputs.didGetSuggestionTitle.accept(choices.description)
    }

    func configureDataSet(at index: Int) {
        if currentChoices[index].isSelected {
            if let i = selectedChoices.firstIndex(of: currentChoices[index]) {
                selectedChoices.remove(at: i)
                currentChoices[index].isSelected.toggle()
            }
        } else {
            currentChoices[index].isSelected.toggle()
            selectedChoices.append(currentChoices[index])
        }
    }

    func setOrderNumber(with orderNumber: Int) {
        self.orderNumber = orderNumber
    }

    private func bindOutputs() {
        repository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        repository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        repository.outputs.didFail
            .bind(to: outputs.didFail)
            .disposed(by: disposeBag)

        repository.outputs.didGetRates
            .bind { [weak self] rates in
                self?.rateChoices = rates
            }
            .disposed(by: disposeBag)
    }

    func sendUserRate(stars: Int, comment: String) {
        let samples = selectedChoices.filter { currentChoices.contains($0) }.map { $0.sample.id }
        guard let orderNumber = orderNumber else { return }
        repository.set(stars: stars, order: orderNumber, comment: comment, samples: samples)
    }
}

extension RateViewModelImpl {
    struct Output {
        let didGetQuestionTitle = PublishRelay<String>()
        let didGetSuggestionTitle = PublishRelay<String>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
    }
}
