//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

final class AgreementController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AgreementViewModel

    private lazy var webView = WKWebView()

    init(viewModel: AgreementViewModel) {
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

    private func bindViewModel() {
        viewModel.ouputs.url
            .bind(onNext: { [weak self] url in
                self?.webView.load(URLRequest(url: url))
            })
            .disposed(by: disposeBag)

        viewModel.ouputs.name
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
}
