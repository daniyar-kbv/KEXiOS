//
//  VerificationView.swift
//  SalamBro
//
//  Created by Arystan on 3/11/21.
//

import UIKit

protocol VerificationViewDelegate: AnyObject {
    func verificationViewDelegate(_ view: VerificationView, enteredCode: String)
    func resendOTPTapped(_ view: VerificationView)
}

final class VerificationView: UIView {
    var timer: Timer!
    private var expirationDate = Date()
    private var numSeconds: TimeInterval = 91.0
    weak var delegate: VerificationViewDelegate?
    private var number: String?

    private lazy var maintitle: UILabel = {
        let label = UILabel()
        label.text = SBLocalization.localized(key: AuthorizationText.Verification.title)
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    lazy var otpField: OTPView = {
        let field = OTPView()
        field.setup()
        field.didEnterLastDigit = { _ in
            self.passCode()
        }
        return field
    }()

    lazy var getCodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.isEnabled = false
        button.setTitle(SBLocalization.localized(key: AuthorizationText.Verification.Button.title, arguments: "01:30"), for: .disabled)
        button.setTitleColor(.mildBlue, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        return button
    }()

    init(delegate: VerificationViewDelegate, number: String) {
        super.init(frame: .zero)
        self.number = number
        self.delegate = delegate
        subtitle.text = SBLocalization.localized(key: AuthorizationText.Verification.subtitle, arguments: " " + number)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VerificationView {
    private func layoutUI() {
        backgroundColor = .white

        [maintitle, subtitle, otpField, getCodeButton].forEach {
            addSubview($0)
        }

        maintitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview().inset(24)
        }

        subtitle.snp.makeConstraints {
            $0.top.equalTo(maintitle.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-16)
        }

        otpField.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(40)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(65)
        }

        getCodeButton.snp.makeConstraints {
            $0.top.equalTo(otpField.snp.bottom).offset(72)
            $0.left.right.equalToSuperview().inset(18)
            $0.height.equalTo(43)
        }
    }

    func startTimer() {
        // then set time interval to expirationDate…
        getCodeButton.isEnabled = false
        getCodeButton.backgroundColor = .white

        expirationDate = Date(timeIntervalSinceNow: numSeconds)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }

    private func currentTimeString() -> String? {
        let unitFlags = Set<Calendar.Component>([.hour, .minute, .second])
        let countdown: DateComponents = Calendar.current.dateComponents(unitFlags, from: Date(), to: expirationDate)

        var timeRemaining: String
        if countdown.second! > 0 || countdown.minute! > 0 {
            timeRemaining = String(format: "%02d:%02d", countdown.minute!, countdown.second!)
            return timeRemaining
        }
        timer.invalidate()
        return nil
    }

    @objc private func updateUI() {
        // Call the currentTimeString method which can decrease the time..
        let timeString = currentTimeString()
        if timeString != nil {
            getCodeButton.setTitle(" " + SBLocalization.localized(key: AuthorizationText.Verification.Button.title, arguments: timeString!), for: .disabled)
        } else {
            getCodeButton.isEnabled = true
            getCodeButton.backgroundColor = .kexRed
            getCodeButton.setTitle(SBLocalization.localized(key: AuthorizationText.Verification.Button.timeout), for: .normal)
        }
    }

    @objc func reload() {
        otpField.text = ""
        otpField.clearLabels()
        startTimer()
    }

    private func passCode() {
        guard
            let code = otpField.text,
            code.count == 4
        else { return }
        delegate?.verificationViewDelegate(self, enteredCode: code)
    }

    func showKeyboard() {
        otpField.becomeFirstResponder()
    }
}
