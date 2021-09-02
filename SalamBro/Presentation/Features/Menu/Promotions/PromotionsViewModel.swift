//
//  PromotionsViewModel.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/23/21.
//

import Foundation
import RxCocoa
import RxSwift
import WebKit

protocol PromotionsViewModel {
    var inputs: PromotionsViewModelImpl.Input { get }
    var outputs: PromotionsViewModelImpl.Output { get }

    func getURLRequest()
    func getVerificationURL() -> String?

    func getIsOAuthRedirect() -> Bool
    func setIsOAuthRedirect(_ isOAuthRedirect: Bool)

    func getWebHandlerName() -> String
    func process(message: WKScriptMessage)
    func getFinishAuthScript() -> String?
}

class PromotionsViewModelImpl: PromotionsViewModel {
    private let disposeBag = DisposeBag()

    private let menuRepository: MenuRepository
    private let authTokenStorage: AuthTokenStorage
    private let defaultStorage: DefaultStorage

    private var isOAuthRedirect = false
    private let webHandlerName = "KEXApp"
    private let authFlowMessage = "startAuthFlow"
    private let authFinshMethod = "sendAuthToken"

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
            URLQueryItem(name: "device", value: "ios"),
        ]
        urlComponents?.queryItems = queryItems

        guard let requestURL = urlComponents?.url else { return }

        var request = URLRequest(url: requestURL)

        if let token = authTokenStorage.token {
            request.addValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        }

        outputs.urlRequest.accept(request)
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
    func getWebHandlerName() -> String {
        return webHandlerName
    }

    func process(message: WKScriptMessage) {
        guard message.name == webHandlerName,
              let value = message.body as? String else { return }
        switch value {
        case authFlowMessage:
            outputs.toAuth.accept(())
        default:
            break
        }
    }

    func getFinishAuthScript() -> String? {
        guard let token = authTokenStorage.token else { return nil }

        return "\(webHandlerName).\(authFinshMethod)(`\(token)`)"
    }
}

extension PromotionsViewModelImpl {
    struct Input {
        let url: URL
        let name: String?
    }

    struct Output {
        let name: BehaviorRelay<String?>
        let urlRequest = PublishRelay<URLRequest>()
        let finishAuthScript = PublishRelay<String>()

        let didStartRequest = PublishRelay<Void>()
        let didEndRequest = PublishRelay<Void>()
        let didGetError = PublishRelay<ErrorPresentable>()

        let toAuth = PublishRelay<Void>()
    }
}
