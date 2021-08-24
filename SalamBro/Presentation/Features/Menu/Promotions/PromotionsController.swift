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

final class PromotionsController: UIViewController, WKNavigationDelegate {
    private let disposeBag = DisposeBag()
    private let viewModel: PromotionsViewModel

    private lazy var webView = PromotionsWebView()

    private var redirectURL = ""

    init(viewModel: PromotionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.ouputs.name
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)

        viewModel.ouputs.url
            .bind(onNext: { [weak self] url in
                var request = URLRequest(url: url)
                request.addValue("JWT \(self?.viewModel.getToken() ?? "")", forHTTPHeaderField: "Authorization")
                self?.webView.load(request)
            })
            .disposed(by: disposeBag)

        viewModel.ouputs.redirectURL
            .bind(onNext: { [weak self] urlString in
                self?.redirectURL = urlString
            })
            .disposed(by: disposeBag)
    }
}

extension PromotionsController {
    override func observeValue(forKeyPath keyPath: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            let url = webView.url
            print("url = \(url)")
        }
    }
}
