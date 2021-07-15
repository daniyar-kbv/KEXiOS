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
    private let disposeBag = DisposeBag()
    private let viewModel: PaymentSelectionViewModel
    private lazy var contentView: PaymentSelectionContainerView = {
        let view = PaymentSelectionContainerView()
        view.delegate = self
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentSelectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
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

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: PaymentText.PaymentSelection.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.outputs.didSelectPaymentMethod
            .subscribe(onNext: { [weak self] text in
                self?.contentView.setPaymentMethod(text: text)
            }).disposed(by: disposeBag)
    }

    func selected(paymentMethod: PaymentMethodType) {
        viewModel.set(paymentMethod: paymentMethod)
    }
}

extension PaymentSelectionViewController: PaymentSelectionContainerViewDelegate {
    func handleChangePaymentMethod() {
        outputs.onChangePaymentMethod.accept(())
    }
}

extension PaymentSelectionViewController {
    struct Output {
        let didTerminate = PublishRelay<Void>()
        let close = PublishRelay<Void>()
        let onChangePaymentMethod = PublishRelay<Void>()
    }
}
