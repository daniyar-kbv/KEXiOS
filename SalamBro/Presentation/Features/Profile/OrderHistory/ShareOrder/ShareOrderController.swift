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
    private let viewModel: ShareOrderViewModel

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

    private lazy var submitButton: SBTextButton = {
        let view = SBTextButton()
        view.setTitle(SBLocalization.localized(key: ProfileText.ShareOrder.submitButton), for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return view
    }()

    init(viewModel: ShareOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        bindOutputs()
    }
}

extension ShareOrderController {
    private func bindOutputs() {
        viewModel.checkURL
            .bind(onNext: { [weak self] checkURL in
                guard let url = URL(string: checkURL) else { return }
                self?.webView.load(URLRequest(url: url))
            })
            .disposed(by: disposeBag)
    }

    private func layoutUI() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(customView: submitButton)

        contentView.addSubview(webView)
        view.addSubview(contentView)

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
        guard let url = URL(string: "instagram-stories://share") else { return }

        if UIApplication.shared.canOpenURL(url) {
            guard let backgroundData = contentView.asImage().jpegData(compressionQuality: 1.0) else { return }
            let pasteBoardItems = [
                ["com.instagram.sharedSticker.backgroundImage": backgroundData],
            ]

            UIPasteboard.general.setItems(pasteBoardItems, options: [.expirationDate: Date().addingTimeInterval(60 * 5)])

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
