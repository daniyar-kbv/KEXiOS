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

    private let contentView = ChangeNameView()

    private let viewModel: ChangeNameViewModel

    override func loadView() {
        super.loadView()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .arcticWhite
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.black,
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.title = L10n.ChangeName.NavigationBar.title
    }
}

extension ChangeNameController {
    private func configureViews() {
        contentView.nameTextField.text = viewModel.oldUserInfo.name
        contentView.emailTextField.text = viewModel.oldUserInfo.email
        contentView.saveButton.isEnabled = !(contentView.nameTextField.text?.isEmpty ?? true)

        contentView.nameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        contentView.emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        contentView.saveButton.addTarget(self, action: #selector(saveName), for: .touchUpInside)
    }

    @objc private func editingChanged(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard let name = contentView.nameTextField.text, let email = contentView.emailTextField.text, !name.isEmpty, !email.isEmpty else {
            contentView.saveButton.isEnabled = false
            contentView.saveButton.backgroundColor = .calmGray
            return
        }
        contentView.saveButton.isEnabled = true
        contentView.saveButton.backgroundColor = .kexRed
    }

    @objc private func saveName() {
        viewModel.change(name: contentView.nameTextField.text, email: contentView.emailTextField.text)
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
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
