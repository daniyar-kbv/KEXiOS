//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let url: URL
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }()
    
    init(url: URL) {
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
    }

    private func layoutUI() {
        navigationItem.title = L10n.Rating.information
        view.backgroundColor = .arcticWhite
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
