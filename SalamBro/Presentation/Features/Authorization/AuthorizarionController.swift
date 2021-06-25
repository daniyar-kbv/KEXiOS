//
//  AuthorizarionController.swift
//  SalamBro
//
//  Created by Arystan on 3/8/21.
//

import InputMask
import RxCocoa
import RxSwift
import UIKit

final class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    private lazy var maskedDelegate: MaskedTextFieldDelegate = {
        let delegate = MaskedTextFieldDelegate(primaryFormat: "([000]) [000] [00] [00]")
        delegate.listener = self
        return delegate
    }()

    private let authHeaderView = AuthHeaderView()

    private let aggreementLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Authorization.Agreement.Inactive.title + L10n.Authorization.Agreement.Active.title
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        return label
    }()

    private let numberView = AuthNumberView()

    private let getButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Authorization.Button.title, for: .normal)
        button.addTarget(self, action: #selector(handleGetButtonAction), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .calmGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()

    private let viewModel: AuthorizationViewModel

    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        outputs.didCloseAuthFlow.accept(())
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureViews()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.shadowImage = .init()
        navigationController?.navigationBar.setBackgroundImage(.init(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .kexRed
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "chevron.left"), style: .plain, target: self, action: #selector(dismissVC))
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

        viewModel.outputs.didSendOTP
            .subscribe(onNext: { [weak self] phoneNumber in
                self?.outputs.didSendOTP.accept(phoneNumber)
            })
            .disposed(by: disposeBag)
    }
}

extension AuthorizationController {
    @objc private func handleTapOnLabel() {
        outputs.handleAgreementTextAction.accept(())
    }

    @objc private func handlecCountryCodeButtonAction() {
        outputs.handleChangeCountryCode.accept(())
    }

    func changeCountryCode(title: String) {
        numberView.countryCodeButton.setTitle(title, for: .normal)
    }
}

extension AuthorizationController {
    @objc private func handleGetButtonAction() {
        viewModel.sendOTP()
    }

    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
    }

    func textField(_: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if complete {
            getButton.isEnabled = true
            getButton.backgroundColor = .kexRed
            viewModel.setPhoneNumber(value)
        } else {
            getButton.isEnabled = false
            getButton.backgroundColor = .calmGray
        }
    }

    private func configureViews() {
        maskedDelegate.listener = self
        numberView.numberField.delegate = maskedDelegate
        view.backgroundColor = .white
        numberView.countryCodeButton.setTitle(viewModel.getCountryCode(), for: .normal)
        aggreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel)))
        numberView.chevronView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlecCountryCodeButtonAction)))
        numberView.countryCodeButton.addTarget(self, action: #selector(handlecCountryCodeButtonAction), for: .touchUpInside)
    }

    private func layoutUI() {
        view.addSubview(authHeaderView)
        authHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }

        view.addSubview(numberView)
        numberView.snp.makeConstraints {
            $0.top.equalTo(authHeaderView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(31)
        }

        view.addSubview(aggreementLabel)
        aggreementLabel.snp.makeConstraints {
            $0.top.equalTo(numberView.snp.bottom).offset(72)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(32)
        }

        view.addSubview(getButton)
        getButton.snp.makeConstraints {
            $0.top.equalTo(aggreementLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(43)
        }
    }
}

extension AuthorizationController {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didCloseAuthFlow = PublishRelay<Void>()
        let handleChangeCountryCode = PublishRelay<Void>()
        let handleAgreementTextAction = PublishRelay<Void>()
    }
}
