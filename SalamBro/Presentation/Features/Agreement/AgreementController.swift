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

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureWebView()
    }

    private func layoutUI() {
        navigationItem.title = L10n.Rating.information
        view.backgroundColor = .arcticWhite
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func configureWebView() {
        guard let testUrl = URL(string: "https://www.google.com") else { return }
        let myRequest = URLRequest(url: testUrl)
        webView.load(myRequest)
    }
}

extension AgreementController: WKUIDelegate {}
