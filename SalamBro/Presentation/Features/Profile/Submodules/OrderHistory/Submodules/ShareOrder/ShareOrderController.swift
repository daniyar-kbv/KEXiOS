//
//  ShareOrderController.swift
//  SalamBro
//
//  Created by Arystan on 4/22/21.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import WebKit

final class ShareOrderController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        return webView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var submitButton: UIButton = {
        let view = UIButton()
        view.setTitle(SBLocalization.localized(key: ProfileText.ShareOrder.submitButton), for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.kexRed, for: .normal)
        view.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return view
    }()

    init() {
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }
}

extension ShareOrderController {
    private func layoutUI() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(customView: submitButton)

        contentView.addSubview(webView)
        view.addSubview(contentView)

        webView.loadHTMLString(htmlString, baseURL: nil)

        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        webView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView)
            $0.left.right.equalTo(contentView).inset(16)
        }
    }
}

extension ShareOrderController {
    @objc private func addTapped() {
        let url = URL(string: "instagram-stories://share")!
        if UIApplication.shared.canOpenURL(url) {
            let backgroundData = contentView.asImage().jpegData(compressionQuality: 1.0)!
            let pasteBoardItems = [
                ["com.instagram.sharedSticker.backgroundImage": backgroundData],
            ]
            if #available(iOS 10.0, *) {
                UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])
            } else {
                UIPasteboard.general.items = pasteBoardItems
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
