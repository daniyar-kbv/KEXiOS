//
//  VerificationViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/9/21.
//

import RxCocoa
import RxSwift
import UIKit

final class VerificationController: ViewController, LoaderDisplayable, AlertDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private var rootView: VerificationView!
    private let viewModel: VerificationViewModel

    init(viewModel: VerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func loadView() {
        rootView = VerificationView(delegate: self, number: viewModel.phoneNumber)
        view = rootView

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_: Bool) {
        rootView.startTimer()
    }

    override func viewDidDisappear(_: Bool) {
        rootView.otpField.text = ""
        rootView.otpField.clearLabels()
        rootView.timer.invalidate()
        rootView.getCodeButton.setTitle(L10n.Verification.Button.title("01:30"), for: .disabled)
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .subscribe(onNext: { [weak self] in
                self?.hideLoader()
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didFail
            .subscribe(onNext: { [weak self] error in
                self?.showError(error)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didVerifyOTP
            .bind(to: outputs.didGetToken)
            .disposed(by: disposeBag)

        viewModel.outputs.didResendOTP
            .subscribe(onNext: { [weak self] in
                self?.rootView.reload()
            })
            .disposed(by: disposeBag)
    }
}

extension VerificationController: VerificationViewDelegate {
    func verificationViewDelegate(_: VerificationView, enteredCode: String) {
        viewModel.verifyOTP(code: enteredCode)
    }

    func resendOTPTapped(_: VerificationView) {
        viewModel.resendOTP()
    }
}

extension VerificationController {
    struct Output {
        let didGetToken = PublishRelay<Void>()
    }
}
