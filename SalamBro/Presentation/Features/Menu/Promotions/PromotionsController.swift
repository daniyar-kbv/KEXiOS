//
//  PromotionsController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 8/23/21.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

final class PromotionsController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: PromotionsViewModel

    let outputs = Output()

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.configuration.userContentController.add(self, name: viewModel.getWebHandlerName())
        return view
    }()

    init(viewModel: PromotionsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)

        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getURLRequest()
    }

    private func bindViewModel() {
        viewModel.outputs.name
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.outputs.urlRequest
            .subscribe(onNext: { [weak self] request in
                self?.webView.load(request)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.toAuth
            .bind(to: outputs.toAuth)
            .disposed(by: disposeBag)
    }
}

extension PromotionsController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let verificationURL = viewModel.getVerificationURL() else {
            decisionHandler(.allow)
            return
        }

        if navigationAction.request.url?.absoluteString.contains(verificationURL) ?? false,
           !viewModel.getIsOAuthRedirect()
        {
            viewModel.setIsOAuthRedirect(true)
            if let url = navigationAction.request.url {
                webView.load(.init(url: url))
            }
            decisionHandler(.cancel)
            return
        }

        viewModel.setIsOAuthRedirect(false)
        decisionHandler(.allow)
    }
}

extension PromotionsController: WKScriptMessageHandler {
    func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        viewModel.process(message: message)
    }

    func didAuthirize() {
        print("didAuthirize()")
        guard let script = viewModel.getFinishAuthScript() else {
            webView.reload()
            return
        }

        print(script)
        webView.evaluateJavaScript(script)
    }
}

extension PromotionsController {
    struct Output {
        let toAuth = PublishRelay<Void>()
    }
}
