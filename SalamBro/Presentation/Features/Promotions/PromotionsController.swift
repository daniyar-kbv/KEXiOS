//
//  PromotionsController.swift
//  SalamBro
//
//  Created by Dan on 6/15/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit

final class PromotionsController: UIViewController {
    let outputs = Output()
    
    private let viewModel: PromotionsViewModel
    
    init(viewModel: PromotionsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
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
        view.load(URLRequest(url: viewModel.getPromotionURL()))
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
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
    }
    
    @objc func infoButtonTapped() {
        outputs.toInfo.accept(viewModel.getInfoURL())
    }
}

extension PromotionsController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let toInfo = PublishRelay<URL>()
    }
}
