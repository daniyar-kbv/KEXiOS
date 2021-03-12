//
//  VerificationView.swift
//  SalamBro
//
//  Created by Arystan on 3/11/21.
//

import UIKit

protocol VerificationViewDelegate {
    func passCode()
    
}
class VerificationView: UIView {

    var timer: Timer!
    var expirationDate = Date()

    var numSeconds: TimeInterval = 91.0
    
    var delegate: VerificationViewDelegate?
    
    lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Введите код из сообщения"
        label.font = .boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var smallTitle: UILabel = {
        let label = UILabel()
        label.text = "Мы отправили его на номер +7 (702) 000 00 28"
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
        button.setTitle("Отправить повторно через: 01:30", for: .disabled)
        button.setTitleColor(.darkGray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(delegate: VerificationViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension VerificationView {
    func setupViews() {
        backgroundColor = .white
        
        addSubview(mainTitle)
        addSubview(smallTitle)
        addSubview(otpField)
        addSubview(getCodeButton)
    }
    
    func setupConstraints() {
        mainTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainTitle.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        mainTitle.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        smallTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor).isActive = true
        smallTitle.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        smallTitle.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        
        otpField.topAnchor.constraint(equalTo: smallTitle.bottomAnchor, constant: 40).isActive = true
        otpField.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        otpField.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        otpField.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        getCodeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        getCodeButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
        getCodeButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
        getCodeButton.heightAnchor.constraint(equalToConstant: 43).isActive = true
    }
    
    func startTimer( ){
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
        if countdown.second! > 0 || countdown.minute! > 0
        {
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
            getCodeButton.setTitle("Отправить повторно через: \(timeString!)", for: .disabled)
        } else {
            
            getCodeButton.isEnabled = true
            getCodeButton.backgroundColor = .kexRed
            getCodeButton.setTitle("Отправить код повторно", for: .normal)
        }
    }
    
    @objc func reload() {
        print("reload!")
        otpField.text = ""
        otpField.clearLabels()
        startTimer()
    }
    
    func passCode() {
        delegate?.passCode()
    }
    
}
