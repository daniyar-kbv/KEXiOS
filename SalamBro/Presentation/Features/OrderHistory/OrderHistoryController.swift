//
//  OrderHistoryController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import UIKit
import WebKit

class OrderHistoryController: UIViewController {

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "post", style: .done, target: self, action: #selector(addTapped))
        webView.loadHTMLString(htmlString, baseURL: nil)
        contentView.backgroundColor = .white
        contentView.addSubview(webView)
        view.addSubview(contentView)
    }
    
    fileprivate func setupConstraints() {
        
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        webView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        webView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        webView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        webView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }

    @objc func addTapped() {
        let url = URL(string: "instagram-stories://share")!
                if UIApplication.shared.canOpenURL(url){
                    let backgroundData = self.view.asImage().jpegData(compressionQuality: 1.0)!
                    let pasteBoardItems = [
                                            ["com.instagram.sharedSticker.backgroundImage" : backgroundData]
                                          ]

                    if #available(iOS 10.0, *) {

                        UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
                    } else {
                        UIPasteboard.general.items = pasteBoardItems
                    }
                    UIApplication.shared.openURL(url)
                }
    }

}
