//
//  VerificationView.swift
//  SalamBro
//
//  Created by Arystan on 3/11/21.
//

import UIKit

protocol VerificationViewDelegate {
    func passCode()
    func back()
}

class VerificationView: UIView {
    var timer: Timer!
    var expirationDate = Date()
    var numSeconds: TimeInterval = 91.0
    var delegate: VerificationViewDelegate?
    var number: String?

    lazy var maintitle: UILabel = {
        let label = UILabel()
        label.text = L10n.Verification.title
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitle: UILabel = {
        let label = UILabel()
        label.text = L10n.Verification.subtitle(" " + number!)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .mildBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var otpField: OTPView = {
        let field = OTPView()
        field.setup()
        field.didEnterLastDigit = { code in
            self.passCode()
            print(code)
        }
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var getCodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.isEnabled = false
        button.setTitle(L10n.Verification.Button.title(" 01:30"), for: .disabled)
        button.setTitleColor(.mildBlue, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(delegate: VerificationViewDelegate, number: String) {
        super.init(frame: .zero)
        self.number = number
        self.delegate = delegate
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VerificationView {
    func setupViews() {
        backgroundColor = .white
        addSubview(maintitle)
        addSubview(subtitle)
        addSubview(otpField)
        addSubview(getCodeButton)
    }

    func setupConstraints() {
        maintitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        maintitle.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        maintitle.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        subtitle.topAnchor.constraint(equalTo: maintitle.bottomAnchor).isActive = true
        subtitle.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        subtitle.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true

        otpField.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40).isActive = true
        otpField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        otpField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        otpField.heightAnchor.constraint(equalToConstant: 65).isActive = true

        getCodeButton.topAnchor.constraint(equalTo: otpField.bottomAnchor, constant: 72).isActive = true
        getCodeButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        getCodeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        getCodeButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }

    func startTimer() {
        // then set time interval to expirationDate…
        getCodeButton.isEnabled = false
        getCodeButton.backgroundColor = .white

        expirationDate = Date(timeIntervalSinceNow: numSeconds)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        print("START TIMER CALLED")
    }

    func currentTimeString() -> String? {
        let unitFlags = Set<Calendar.Component>([.hour, .minute, .second])
        let countdown: DateComponents = Calendar.current.dateComponents(unitFlags, from: Date(), to: expirationDate)

        var timeRemaining: String
        print("minute: \(countdown.minute!), second: \(countdown.second!)")
        if countdown.second! > 0 || countdown.minute! > 0 {
            timeRemaining = String(format: "%02d:%02d", countdown.minute!, countdown.second!)
            return timeRemaining
        }
        timer.invalidate()
        return nil
    }

    @objc func updateUI() {
        // Call the currentTimeString method which can decrease the time..
        let timeString = currentTimeString()
        if timeString != nil {
            getCodeButton.setTitle(" " + L10n.Verification.Button.title(timeString!), for: .disabled)
        } else {
            getCodeButton.isEnabled = true
            getCodeButton.backgroundColor = .kexRed
            getCodeButton.setTitle(L10n.Verification.Button.timeout, for: .normal)
        }
    }

    @objc func reload() {
        otpField.text = ""
        otpField.clearLabels()
        startTimer()
    }

    func passCode() {
        delegate?.passCode()
    }

    @objc func backButtonTapped() {
        delegate?.back()
    }
}
