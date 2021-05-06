//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import SnapKit
import UIKit
import WebKit

class AgreementController: UIViewController {
    lazy var navbar = CustomNavigationBarView(navigationTitle: L10n.Agreement.Navigation.title)

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
}

extension AgreementController {
    fileprivate func setupViews() {
        view.backgroundColor = .arcticWhite
        let myURL = URL(string: "https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        view.addSubview(webView)
        view.addSubview(navbar)
        navbar.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    fileprivate func setupConstraints() {
        navbar.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }

        webView.snp.makeConstraints {
            $0.top.equalTo(navbar.snp.bottom).offset(24)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AgreementController: WKUIDelegate {}
