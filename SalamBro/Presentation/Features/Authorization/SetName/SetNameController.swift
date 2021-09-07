//
//  GetNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import RxCocoa
import RxSwift
import UIKit

final class SetNameController: UIViewController, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    var didGetEnteredName: (() -> Void)?

    private lazy var rootView = SetNameView(delegate: self)
    private let viewModel: SetNameViewModel

    init(viewModel: SetNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addObserversForAuthFlow()
        rootView.showKeyboard()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserversForAuthFlow()
    }

    private func bindViewModel() {
        viewModel.outputs.didStartRequest
            .bind { [weak self] in
                self?.showLoader()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didEndRequest
            .bind { [weak self] in
                self?.hideLoader()
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didFail
            .bind { [weak self] error in
                self?.showError(error)
            }
            .disposed(by: disposeBag)

        viewModel.outputs.didSaveUserName
            .bind { [weak self] in
                self?.didGetEnteredName?()
            }
            .disposed(by: disposeBag)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension SetNameController: GetNameViewDelegate {
    func submit(name: String) {
        viewModel.persist(name: name)
    }
}

extension SetNameController {
    @objc override func keyboardWillShowForAuthFlow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let keyWindow = UIApplication.shared.keyWindow else { return }

        let convertedFrame = rootView.nextButton.convert(rootView.nextButton.bounds, to: keyWindow)

        let heightFromButton = keyWindow.frame.height - (convertedFrame.maxY + 15)
        let difference = keyboardSize.height - heightFromButton

        if difference > 0 {
            UIApplication.shared.keyWindow?.frame.origin.y = -difference
        }
    }

    @objc override func keyboardWillHideForAuthFlow(notification _: NSNotification) {
        UIApplication.shared.keyWindow?.frame.origin.y = 0.0
    }
}
