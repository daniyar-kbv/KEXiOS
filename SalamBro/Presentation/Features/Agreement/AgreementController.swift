//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

final class AgreementController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AgreementViewModel

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    init(viewModel: AgreementViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
    }

    private func bindViewModel() {
        viewModel.url.bind(onNext: { [weak self] url in
            self?.webView.load(URLRequest(url: url))
        }).disposed(by: disposeBag)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}
