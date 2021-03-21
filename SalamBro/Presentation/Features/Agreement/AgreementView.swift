//
//  AgreementView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit
import WebKit

class AgreementView: UIView {
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    init(delegate: WKUIDelegate) {
        super.init(frame: .zero)
        webView.uiDelegate = delegate
        setupViews()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AgreementView {
    fileprivate func setupViews() {
        backgroundColor = .arcticWhite
        let myURL = URL(string: "https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        addSubview(webView)
    }

    fileprivate func setupConstraints() {
        webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }

}
