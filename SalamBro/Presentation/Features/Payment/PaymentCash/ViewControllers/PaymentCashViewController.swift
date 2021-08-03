//
//  PaymentCashViewController.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class PaymentCashViewController: UIViewController {
    private let viewModel: PaymentCashViewModel
    private let disposeBag = DisposeBag()

    private lazy var contentView: PaymentCashView = {
        let view = PaymentCashView()
        view.delegate = self
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentCashViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
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

        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }

        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentView.showKeyboard()
    }

    private func bindViewModel() {
        viewModel.outputs.price
            .subscribe(onNext: { [weak self] price in
                self?.contentView.set(price: price)
            }).disposed(by: disposeBag)

        viewModel.outputs.needChange
            .subscribe(onNext: { [weak self] needChange in
                self?.contentView.set(needChange: needChange)
                self?.configTitle(needChange: needChange)
            }).disposed(by: disposeBag)

        viewModel.outputs.isLessThanPrice
            .subscribe(onNext: { [weak self] isLess in
                self?.contentView.set(isChangeLess: isLess)
            }).disposed(by: disposeBag)

        viewModel.outputs.onDone
            .bind(to: outputs.onDone)
            .disposed(by: disposeBag)
    }

    private func configTitle(needChange: Bool) {
        title = needChange ?
            SBLocalization.localized(key: PaymentText.PaymentCash.Title.change) :
            SBLocalization.localized(key: PaymentText.PaymentCash.Title.base)
    }
}

extension PaymentCashViewController: PaymentCashViewDelegate {
    func onSubmit() {
        viewModel.submit()
    }

    func textFieldDidChange(text: String?) {
        viewModel.set(change: text)
    }
}

extension PaymentCashViewController {
    struct Output {
        let close = PublishRelay<Void>()
        let onDone = PublishRelay<Void>()
    }
}
