//
//  PaymentSelectionViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import RxCocoa
import RxSwift
import UIKit

final class PaymentSelectionViewController: UIViewController {
    private var containerView: PaymentSelectionContainerView!

    private let viewModel: PaymentSelectionViewModel

    let outputs = Output()

    init(viewModel: PaymentSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        containerView = PaymentSelectionContainerView()
        containerView.delegate = self
        view = containerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: Payment.PaymentSelectionText.title)

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension PaymentSelectionViewController: PaymentSelectionContainerViewDelegate {
    func handleChangePaymentMethod() {
        outputs.onChangePaymentMethod.accept(())
    }
}

extension PaymentSelectionViewController {
    struct Output {
        let close = PublishRelay<Void>()
        let onChangePaymentMethod = PublishRelay<Void>()
    }
}
