//
//  3DSViewController.swift
//  SalamBro
//
//  Created by Dan on 7/18/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import WebKit

final class ThreeDSViewController: UIViewController {
    private let webView: WKWebView

    let outputs = Output()

    init(webView: WKWebView) {
        self.webView = webView

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        outputs.didTerminate.accept(())
    }

    override func loadView() {
        super.loadView()

        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension ThreeDSViewController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()
    }
}
