//
//  PromotionsController.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import WebKit

final class PromotionsController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: PromotionsViewModel

    let outputs = Output()

    init(viewModel: PromotionsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        outputs.didTerminate.accept(())
    }

    private lazy var infoButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "info"), for: .normal)
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = L10n.Rating.title
    }

    private func bindViewModel() {
        viewModel.promotionURL
            .bind(onNext: { [weak self] url in
                self?.webView.load(URLRequest(url: url))
            })
            .disposed(by: disposeBag)

        viewModel.infoURL
            .bind(onNext: { [weak self] infoURL in
                self?.infoButton.isHidden = infoURL == nil
            })
            .disposed(by: disposeBag)
    }

    @objc private func infoButtonTapped() {
        guard let infoURL = viewModel.infoURL.value else { return }
        outputs.toInfo.accept(infoURL)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension PromotionsController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toInfo = PublishRelay<URL>()
    }
}
