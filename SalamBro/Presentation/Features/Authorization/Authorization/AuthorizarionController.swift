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

final class AuthorizationController: UIViewController, MaskedTextFieldDelegateListener, LoaderDisplayable {
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
        label.text = SBLocalization.localized(key: AuthorizationText.Auth.Agreement.inactive) +
            SBLocalization.localized(key: AuthorizationText.Auth.Agreement.active)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        return label
    }()

    private var numberView: AuthNumberView?

    private let getButton: SBSubmitButton = {
        let button = SBSubmitButton(style: .filledRed)
        button.setTitle(SBLocalization.localized(key: AuthorizationText.Auth.buttonTitle), for: .normal)
        button.addTarget(self, action: #selector(handleGetButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    private let viewModel: AuthorizationViewModel

    override func loadView() {
        super.loadView()
        numberView = AuthNumberView(delegate: self, maskedDelegate: maskedDelegate)
    }

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

        viewModel.getDocuments()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        numberView?.showKeyboard()
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
        guard let userAgreementInfo = viewModel.getUserAgreementInfo() else { return }
        outputs.handleAgreementTextAction.accept(userAgreementInfo)
    }

    func changeCountryCode(title: String) {
        numberView?.configureButtonTitle(with: title)
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
            viewModel.setPhoneNumber(value)
        } else {
            getButton.isEnabled = false
        }
    }

    private func configureViews() {
        view.backgroundColor = .white
        maskedDelegate.listener = self

        aggreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel)))

        numberView?.configureButtonTitle(with: viewModel.getCountryCode())
    }

    private func layoutUI() {
        view.addSubview(authHeaderView)
        authHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }

        guard let numberView = numberView else { return }
        view.addSubview(numberView)
        numberView.snp.makeConstraints {
            $0.top.equalTo(authHeaderView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(31)
        }

        view.addSubview(aggreementLabel)
        aggreementLabel.snp.makeConstraints {
            $0.top.equalTo(numberView.snp.bottom).offset(72)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(32)
        }

        view.addSubview(getButton)
        getButton.snp.makeConstraints {
            $0.top.equalTo(aggreementLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
    }
}

extension AuthorizationController: AuthNumberViewDelegate {
    func countryCodeButtonTapped() {
        outputs.handleChangeCountryCode.accept(())
    }
}

extension AuthorizationController {
    struct Output {
        let didSendOTP = PublishRelay<String>()
        let didCloseAuthFlow = PublishRelay<Void>()
        let handleChangeCountryCode = PublishRelay<Void>()
        let handleAgreementTextAction = PublishRelay<(URL, String)>()
    }
}
