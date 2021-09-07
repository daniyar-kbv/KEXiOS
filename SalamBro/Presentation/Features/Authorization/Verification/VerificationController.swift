//
//  VerificationViewController.swift
//  SalamBro
//
//  Created by Arystan on 3/9/21.
//

import RxCocoa
import RxSwift
import UIKit

final class VerificationController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private var rootView: VerificationView?
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
    }

    override func viewWillAppear(_: Bool) {
        rootView?.startTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserversForAuthFlow()
        rootView?.showKeyboard()
    }

    override func viewDidDisappear(_: Bool) {
        removeObserversForAuthFlow()

        rootView?.otpField.text = ""
        rootView?.otpField.clearLabels()
        rootView?.timer.invalidate()
        rootView?.getCodeButton.setTitle(SBLocalization.localized(key: AuthorizationText.Verification.Button.title, arguments: "01:30"), for: .disabled)
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
                self?.showError(error, completion: {
                    self?.rootView?.showKeyboard()
                })
                self?.rootView?.reload(for: true)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.didFinish
            .bind(to: outputs.didFinish)
            .disposed(by: disposeBag)

        viewModel.outputs.didResendOTP
            .subscribe(onNext: { [weak self] in
                self?.rootView?.reload(for: false)
            })
            .disposed(by: disposeBag)
    }

    private func reload() {
        print("reload()")
        rootView?.reload(for: true)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
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
        let didFinish = PublishRelay<Bool>()
    }
}

extension VerificationController {
    @objc override func keyboardWillShowForAuthFlow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard let maxY = rootView?.getCodeButton.frame.maxY else { return }
            if view.frame.height - maxY <= keyboardSize.height {
                UIApplication.shared.keyWindow?.frame.origin.y -= keyboardSize.height / 3
            }
        }
    }

    @objc override func keyboardWillHideForAuthFlow(notification _: NSNotification) {
        UIApplication.shared.keyWindow?.frame.origin.y = 0.0
    }
}
