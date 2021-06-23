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

class ShareOrderController: UIViewController {
    // private let viewModel: ShareOrderViewModel

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
        view.setTitle(L10n.ShareOrder.submitButton, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.kexRed, for: .normal)
        view.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return view
    }()

    init() {
        // self.viewModel = viewModel
        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        // bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.rightBarButtonItem = .init(customView: submitButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
    }
}

extension ShareOrderController {
    private func layoutUI() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white

        contentView.addSubview(webView)
        view.addSubview(contentView)

        webView.loadHTMLString(htmlString, baseURL: nil)

        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        webView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.left.equalTo(contentView.snp.left).offset(16)
            $0.right.equalTo(contentView.snp.right).offset(-16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}

extension ShareOrderController {
//    private func bind() {
//        viewModel.url.bind(onNext: { [weak self] url in
//            self?.webView.loadHTMLString(htmlString, baseURL: nil)
//        }).disposed(by: disposeBag)
//    }

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

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}
