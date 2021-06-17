//
//  AgreementController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel.url.bind(onNext: { [weak self] url in
            self?.webView.load(URLRequest(url: url))
        }).disposed(by: disposeBag)
    }
    
    override func loadView() {
        super.loadView()
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

    // MARK: - Tech Debt: change

    private func setupNavigationBar() {
        navigationItem.title = L10n.Rating.information
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isTranslucent = false
    }
}
