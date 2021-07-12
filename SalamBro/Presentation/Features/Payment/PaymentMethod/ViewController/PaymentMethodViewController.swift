//
//  PaymentMethodViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class PaymentMethodViewController: UIViewController {
    private var paymentMethodView: PaymentMethodView!

    private let viewModel: PaymentMethodVCViewModel

    let outputs = Output()

    init(viewModel: PaymentMethodVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        paymentMethodView = PaymentMethodView(viewModel: PaymentMethodViewModelImpl())
        view = paymentMethodView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Tech debt: localize
        title = "Способ оплаты"
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension PaymentMethodViewController {
    struct Output {
        let close = PublishRelay<Void>()
    }
}
