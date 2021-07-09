//
//  ChangeNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import RxCocoa
import RxSwift
import UIKit

final class ChangeNameController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private var contentView: ChangeNameView?

    private let viewModel: ChangeNameViewModel

    override func loadView() {
        super.loadView()
        contentView = ChangeNameView(delegate: self)
        view = contentView
    }

    init(viewModel: ChangeNameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
    }
}

extension ChangeNameController {
    private func configureViews() {
        navigationItem.title = SBLocalization.localized(key: ProfileText.ChangeName.title)
        if let name = viewModel.oldUserInfo.name, let email = viewModel.oldUserInfo.email {
            contentView?.configureTextFields(name: name, email: email)
        }
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

        viewModel.outputs.didGetUserInfo
            .bind(to: outputs.didGetUserInfo)
            .disposed(by: disposeBag)
    }

    struct Output {
        let didGetUserInfo = PublishRelay<UserInfoResponse>()
    }
}

extension ChangeNameController: ChangeNameViewDelegate {
    func textFieldsTapped(_ textfield: UITextField) {
        textfield.text = textfield.text?.trimmingCharacters(in: .whitespaces)
        guard let name = contentView?.nameTextField.text, let email = contentView?.emailTextField.text, !name.isEmpty, !email.isEmpty else {
            contentView?.configureButton(isEnabled: false)
            return
        }
        contentView?.configureButton(isEnabled: true)
    }

    func saveButtonTapped() {
        viewModel.change(name: contentView?.nameTextField.text, email: contentView?.emailTextField.text)
    }
}
