//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit
import WebKit

final class AgreementController: UIViewController {
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        return webView
    }()

    private let viewModel: AgreementViewModel

    init(viewModel: AgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureWebView()
    }

    // MARK: - Tech Debt: change

    private func layoutUI() {
        navigationItem.title = L10n.Rating.information
        navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = .arcticWhite
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    private func configureWebView() {
        guard let testUrl = URL(string: "https://www.google.com") else { return }
        let myRequest = URLRequest(url: testUrl)
        webView.load(myRequest)
    }
}

extension AgreementController: WKUIDelegate {}
