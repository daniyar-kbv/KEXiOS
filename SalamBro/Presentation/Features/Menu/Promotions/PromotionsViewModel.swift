//
//  PromotionsViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/23/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol PromotionsViewModel {
    var inputs: PromotionsViewModelImpl.Input { get }
    var outputs: PromotionsViewModelImpl.Output { get }

    func getURLRequest()
    func processVerification(url: URL?)

    func getRedirectURL() -> String?
    func getVerificationURL() -> String?

    func getIsOAuthRedirect() -> Bool
    func setIsOAuthRedirect(_ isOAuthRedirect: Bool)
}

class PromotionsViewModelImpl: PromotionsViewModel {
    private let disposeBag = DisposeBag()

    private let menuRepository: MenuRepository
    private let authTokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    private var isOAuthRedirect = false

    let inputs: Input
    let outputs: Output

    init(input: Input,
         menuRepository: MenuRepository,
         authTokenStorage: AuthTokenStorage,
         defaultStorage: DefaultStorage)
    {
        inputs = input

        self.menuRepository = menuRepository
        self.authTokenStorage = authTokenStorage
        self.defaultStorage = defaultStorage

        outputs = .init(name: .init(value: input.name))

        bindMenuRepository()
    }

    func getURLRequest() {
        guard let leadUUID = defaultStorage.leadUUID else { return }

        var urlComponents = URLComponents(url: inputs.url, resolvingAgainstBaseURL: false)
        let queryItems = [
            URLQueryItem(name: "is_web_view", value: "1"),
            URLQueryItem(name: "lead_uuid", value: leadUUID),
        ]
        urlComponents?.queryItems = queryItems

        guard let requestURL = urlComponents?.url else { return }

        var request = URLRequest(url: requestURL)

        if let token = authTokenStorage.token {
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        }

        outputs.urlRequest.accept(request)
    }

    func processVerification(url: URL?) {
        guard let url = url,
              let parameterName = menuRepository.getPromotionsParamenterName() else { return }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

//        guard let parameter = urlComponents?.queryItems?.first(where: { $0.name == parameterName })?.value else { return }

        let parameter = "AQBxzdnTjfnIbJJ5BogEQltx9qYps5hmlCG1w47-GE_6oKu1p2ZSZoBBjLsNdT3JNhf52_oXAXiX4DjY9kW30f9c50AGbyyZi8WkjaP54XP7Ud0hArVWCnJwerV7Ciw7gFh9J9fweLGkcstiCvt5NbwYJhHb-3npGNi_nOi40iKntiP-bZ6vm8SZDePcW6WN3FJ4l2uDbL3jDl8x3GtzyyceS84t1LhMpbqea8IrWwu0RQ#_"

        menuRepository.sendParticipate(promotionId: inputs.id, code: parameter)
    }
}

extension PromotionsViewModelImpl {
    private func bindMenuRepository() {
        menuRepository.outputs.didStartRequest
            .bind(to: outputs.didStartRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didEndRequest
            .bind(to: outputs.didEndRequest)
            .disposed(by: disposeBag)

        menuRepository.outputs.didGetError
            .bind(to: outputs.didGetError)
            .disposed(by: disposeBag)

        menuRepository.outputs.participationVerified
            .subscribe(onNext: { [weak self] in
                self?.getURLRequest()
            })
            .disposed(by: disposeBag)
    }
}

extension PromotionsViewModelImpl {
    func getRedirectURL() -> String? {
        return menuRepository.getPromotionsRedirectURL()
    }

    func getVerificationURL() -> String? {
        return menuRepository.getPromotionsVerificationURL()
    }

    func getIsOAuthRedirect() -> Bool {
        return isOAuthRedirect
    }

    func setIsOAuthRedirect(_ isOAuthRedirect: Bool) {
        self.isOAuthRedirect = isOAuthRedirect
    }
}

extension PromotionsViewModelImpl {
    struct Input {
        let id: Int
        let url: URL
        let name: String?
    }

    struct Output {
        let name: BehaviorRelay<String?>
        let urlRequest = PublishRelay<URLRequest>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()
    }
}
