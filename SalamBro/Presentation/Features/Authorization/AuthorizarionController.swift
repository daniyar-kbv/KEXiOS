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

final class AuthorizationController: ViewController, MaskedTextFieldDelegateListener, AlertDisplayable, LoaderDisplayable {
    private let disposeBag = DisposeBag()

    let outputs = Output()

    lazy var maskedDelegate: MaskedTextFieldDelegate = {
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

    // MARK: Tech debt, нужно перенести в отдельный класс countryCodeButton, chevronView и numberField

    private let countryCodeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(handlecCountryCodeButtonAction), for: .touchUpInside)
        return button
    }()

    private let chevronView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevron.bottom")
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()

    private let numberField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 26)
        field.attributedPlaceholder = NSAttributedString(
            string: L10n.Authorization.NumberField.Placeholder.title,
            attributes: [.font: UIFont.systemFont(ofSize: 26, weight: .medium)]
        )
        return field
    }()

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
        configureNavigationBar()
        bindViewModel()
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
        countryCodeButton.setTitle(title, for: .normal)
    }
}

extension AuthorizationController {
    @objc func handleGetButtonAction() {
        viewModel.sendOTP()
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

    private func configureNavigationBar() {
        navigationItem.title = ""
    }

    func configureViews() {
        maskedDelegate.listener = self
        numberField.delegate = maskedDelegate
        view.backgroundColor = .white
        countryCodeButton.setTitle(viewModel.getCountryCode(), for: .normal)
        aggreementLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel)))
        chevronView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlecCountryCodeButtonAction)))
    }

    func layoutUI() {
        view.addSubview(authHeaderView)
        authHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.bounds.height * 0.14)
        }

        view.addSubview(countryCodeButton)
        countryCodeButton.snp.makeConstraints {
            $0.top.equalTo(authHeaderView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(40)
            $0.height.equalTo(32)
        }

        view.addSubview(chevronView)
        chevronView.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.leading.equalTo(countryCodeButton.snp.trailing)
            $0.size.equalTo(24)
        }

        view.addSubview(numberField)
        numberField.snp.makeConstraints {
            $0.centerY.equalTo(countryCodeButton)
            $0.leading.equalTo(chevronView.snp.trailing)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(32)
        }

        view.addSubview(aggreementLabel)
        aggreementLabel.snp.makeConstraints {
            $0.top.equalTo(countryCodeButton.snp.bottom).offset(72)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(32)
        }

        view.addSubview(getButton)
        getButton.snp.makeConstraints {
            $0.top.equalTo(aggreementLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
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
