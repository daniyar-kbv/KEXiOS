//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import SnapKit
import UIKit
import WebKit

class AgreementController: ViewController {
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Rating.information
    }
}

private extension AgreementController {
    func setupViews() {
        view.backgroundColor = .arcticWhite
        let myURL = URL(string: "https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        view.addSubview(webView)
    }

    func setupConstraints() {
        webView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}

extension AgreementController: WKUIDelegate {}
