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
    func sendUserRate(stars: Int, comment: String)
}

final class RateViewModelImpl: RateViewModel {
    private(set) var outputs: Output = .init()
    private let disposeBag = DisposeBag()

    private var rateChoices: [RateStarList] = []
    private(set) var currentChoices: [RateItem] = []
    private var selectedChoices: [RateItem] = []
    private var rating = 0

    private let repository: RateOrderRepository

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
        self.rating = rating
        let choices = rateChoices[rating - 1]
        for i in choices.samples {
            if selectedChoices.contains(where: { $0.title == i.name }) {
                currentChoices.append(RateItem(title: i.name, isSelected: true))
            } else {
                currentChoices.append(RateItem(title: i.name, isSelected: false))
            }
        }
        outputs.didGetQuestionTitle.accept(choices.title)
        outputs.didGetSuggestionTitle.accept(choices.description)
    }

    func configureDataSet(at index: Int) {
        if selectedChoices.contains(where: { $0.title == currentChoices[index].title }) {
            if let index = selectedChoices.firstIndex(of: currentChoices[index]) {
                currentChoices[index].isSelected.toggle()
                selectedChoices.remove(at: index)
            }
        } else {
            currentChoices[index].isSelected.toggle()
            selectedChoices.append(currentChoices[index])
        }
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
        var samples: [Int] = []
        let choices = rateChoices[rating - 1].samples
        for i in 0 ..< selectedChoices.count {
            if choices.contains(where: { $0.name == selectedChoices[i].title }) {
                if let index = choices.firstIndex(where: { $0.name == selectedChoices[i].title }) {
                    samples.append(choices[index].id)
                }
            }
        }
        repository.set(stars: stars, order: 5, comment: comment, samples: samples)
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
