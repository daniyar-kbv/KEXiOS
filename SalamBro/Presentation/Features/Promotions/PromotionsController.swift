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

    lazy var infoButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "info"), for: .normal)
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        bindViewModel()
    }

    func bindViewModel() {
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

//    Tech debt: change

    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.backIndicatorImage = Asset.chevronLeft.image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = Asset.chevronLeft.image
        navigationItem.title = nil
        navigationItem.title = L10n.Rating.title
        navigationItem.rightBarButtonItem = .init(customView: infoButton)
        navigationController?.navigationBar.isTranslucent = false
    }

    @objc func infoButtonTapped() {
        guard let infoURL = viewModel.infoURL.value else { return }
        outputs.toInfo.accept(infoURL)
    }
}

extension PromotionsController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toInfo = PublishRelay<URL>()
    }
}
