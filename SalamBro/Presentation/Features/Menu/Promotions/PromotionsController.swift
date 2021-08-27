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

final class PromotionsController: UIViewController, WKNavigationDelegate, LoaderDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: PromotionsViewModel

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
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
    }

    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let verificationURL = viewModel.getVerificationURL() else {
            decisionHandler(.allow)
            return
        }

        if navigationAction.request.url?.absoluteString.contains(verificationURL) ?? false,
           !viewModel.getIsOAuthRedirect()
        {
            viewModel.setIsOAuthRedirect(true)
            open(url: navigationAction.request.url)
            decisionHandler(.cancel)
            return
        }

        viewModel.setIsOAuthRedirect(false)
        decisionHandler(.allow)
    }

    private func open(url: URL?) {
        guard let url = url else { return }
        webView.load(.init(url: url))
    }

    private func urlContains(_ string: String, in navigationAction: WKNavigationAction) -> Bool {
        return navigationAction.request.url?.absoluteString.contains(string) ?? false
    }
}
