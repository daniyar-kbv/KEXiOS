//
//  PaymentSelectionViewController.swift
//  SalamBro
//
//  Created by Ilyar Mnazhdin on 06.07.2021.
//

import UIKit

final class PaymentSelectionViewController: UIViewController {
    var onChangePaymentMethod: (() -> Void)?

    private let viewModel: PaymentSelectionViewModel
    private lazy var contentView: PaymentSelectionContainerView = {
        let view = PaymentSelectionContainerView()
        view.delegate = self
        return view
    }()

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

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: PaymentText.PaymentSelection.title)
    }
}

extension PaymentSelectionViewController: PaymentSelectionContainerViewDelegate {
    func handleChangePaymentMethod() {
        onChangePaymentMethod?()
    }
}
