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

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    init(viewModel: AgreementViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        viewModel.url.bind(onNext: { [weak self] url in
            self?.webView.load(URLRequest(url: url))
        }).disposed(by: disposeBag)
    }

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    // MARK: - Tech Debt: change

    private func setupNavigationBar() {
        navigationItem.title = L10n.Rating.information
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isTranslucent = false
    }
}
