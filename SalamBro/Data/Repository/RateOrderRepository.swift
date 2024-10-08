//
//  RateOrderRepository.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol RateOrderRepository: AnyObject {
    var outputs: RateOrderRepositoryImpl.Output { get }
    func fetchRates()
    func set(stars: Int, order: Int, comment: String, samples: [Int])
}

final class RateOrderRepositoryImpl: RateOrderRepository {
    private let disposeBag = DisposeBag()

    private(set) var outputs: Output = .init()

    private let rateService: RateService

    init(rateService: RateService) {
        self.rateService = rateService
    }

    func fetchRates() {
        outputs.didStartRequest.accept(())
        rateService.getRates()
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] rateResponse in
                self?.outputs.didEndRequest.accept(())
                self?.outputs.didGetRates.accept(rateResponse)
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.process(error: error)
            })
            .disposed(by: disposeBag)
    }

    func set(stars: Int, order: Int, comment: String, samples: [Int]) {
        outputs.didStartRequest.accept(())
        rateService.setUserRate(with: UserRateDTO(star: stars, order: order, comment: comment, sample: samples))
            .retryWhenUnautharized()
            .subscribe(onSuccess: { [weak self] _ in
                self?.outputs.didSendRate.accept(())
                self?.outputs.didEndRequest.accept(())
            }, onError: { [weak self] error in
                self?.outputs.didEndRequest.accept(())
                self?.process(error: error)
            })
            .disposed(by: disposeBag)
    }

    private func process(error: Error) {
        guard let errorPresentable = error as? ErrorPresentable else {
            outputs.didFail.accept(NetworkError.error(error.localizedDescription))
            return
        }

        if (errorPresentable as? NetworkError) == .unauthorized {
            outputs.didFailAuth.accept(errorPresentable)
            return
        }

        outputs.didFail.accept(errorPresentable)
    }
}

extension RateOrderRepositoryImpl {
    struct Output {
        let didGetRates = PublishRelay<[RateStarList]>()
        let didFail = PublishRelay<ErrorPresentable>()
        let didFailAuth = PublishRelay<ErrorPresentable>()
        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didSendRate = PublishRelay<Void>()
    }
}
