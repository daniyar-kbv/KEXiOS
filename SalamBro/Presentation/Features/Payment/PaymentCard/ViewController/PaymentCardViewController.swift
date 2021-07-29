//
//  PaymentCardViewController.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class PaymentCardViewController: UIViewController, AlertDisplayable {
    private let disposeBag = DisposeBag()
    private let viewModel: PaymentCardViewModel

    private lazy var contentView: PaymentCardView = {
        let view = PaymentCardView()
        view.delegate = self
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentCardViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)

        bindViewModel()
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

        title = SBLocalization.localized(key: PaymentText.PaymentCard.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }

    private func bindViewModel() {
        viewModel.outputs.didGetError
            .subscribe(onNext: { [weak self] in
                self?.showInvalidError()
            }).disposed(by: disposeBag)

        viewModel.outputs.onDone
            .bind(to: outputs.onDone)
            .disposed(by: disposeBag)
    }

    private func showInvalidError() {
        showAlert(title: SBLocalization.localized(key: PaymentText.PaymentCard.Error.title),
                  message: SBLocalization.localized(key: PaymentText.PaymentCard.Error.message))
        contentView.showInvalidFields()
    }
}

extension PaymentCardViewController: PaymentCardViewDelegate {
    func onSaveTap() {
        viewModel.processCardInfo(cardNumber: contentView.getCardNumber(),
                                  expiryDate: contentView.getExpieryDate(),
                                  cvv: contentView.getCVV(),
                                  cardholderName: contentView.getCardholderName(),
                                  needsSave: contentView.getNeedsSave())
    }
}

extension PaymentCardViewController {
    struct Output {
        let close = PublishRelay<Void>()
        let onDone = PublishRelay<Void>()
    }
}
