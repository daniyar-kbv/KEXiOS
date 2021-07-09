//
//  PaymentSelectionViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentSelectionViewController: UIViewController {
    var onChangePaymentMethod: (() -> Void)?

    private var containerView: PaymentSelectionContainerView!

    private let viewModel: PaymentSelectionViewModel

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
    }
}

extension PaymentSelectionViewController: PaymentSelectionContainerViewDelegate {
    func handleChangePaymentMethod() {
        onChangePaymentMethod?()
    }
}
