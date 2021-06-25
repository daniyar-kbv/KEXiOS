//
//  ChangeNameController.swift
//  SalamBro
//
//  Created by Arystan on 3/25/21.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: Tech debt, нужно переписать как будет время, не критично.

final class ChangeNameController: UIViewController, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private var yCoordinate: CGFloat?

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = L10n.ChangeName.nameLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var emailLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mildBlue
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.text = L10n.ChangeName.emailLabel
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.ChangeName.SaveButton.title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(saveName), for: .touchUpInside)
        button.backgroundColor = .calmGray
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let viewModel: ChangeNameViewModel

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
        setupUI()
        setupViews()
        setupConstraints()
        bindViewModel()
    }

    private func setupUI() {
        navigationItem.title = L10n.ChangeName.NavigationBar.title
        yCoordinate = saveButton.frame.origin.y
    }
}

extension ChangeNameController {
    private func setupViews() {
        view.backgroundColor = .white
        nameView.addSubview(nameField)
        emailView.addSubview(emailField)
        view.addSubview(nameLabel)
        view.addSubview(nameView)
        view.addSubview(emailLabel)
        view.addSubview(emailView)
        view.addSubview(saveButton)

        saveButton.isEnabled = !(nameField.text?.isEmpty ?? true)

        nameField.text = viewModel.oldUserInfo.name
        emailField.text = viewModel.oldUserInfo.email
    }

    private func setupConstraints() {
        nameLabel.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 16).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: nameView.topAnchor, constant: -4).isActive = true

        nameField.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 16).isActive = true
        nameField.rightAnchor.constraint(equalTo: nameView.rightAnchor, constant: -16).isActive = true
        nameField.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true

        nameView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        nameView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        nameView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        emailLabel.leftAnchor.constraint(equalTo: emailView.leftAnchor, constant: 16).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: emailView.topAnchor, constant: -4).isActive = true

        emailField.leftAnchor.constraint(equalTo: emailView.leftAnchor, constant: 16).isActive = true
        emailField.rightAnchor.constraint(equalTo: emailView.rightAnchor, constant: -16).isActive = true
        emailField.centerYAnchor.constraint(equalTo: emailView.centerYAnchor).isActive = true

        emailView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 40).isActive = true
        emailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        emailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        saveButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
        saveButton.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 24).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
    }

    @objc private func editingChanged(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard let name = nameField.text, let email = emailField.text, !name.isEmpty, !email.isEmpty else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .calmGray
            return
        }
        saveButton.isEnabled = true
        saveButton.backgroundColor = .kexRed
    }

    @objc private func saveName() {
        viewModel.change(name: nameField.text, email: emailField.text)
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
