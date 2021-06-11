//
//  AnimationsView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/10/21.
//

import Lottie
import SnapKit
import UIKit

enum AnimationType {
    case orderHistory
    case emptyBasket
    case noInternet
    case upgrade
    case overload
    case payment
    case profile

    var infoText: String {
        switch self {
        case .orderHistory:
            return "Тут будут Ваши заказы, чтобы сделать заказ перейдите в меню"
        case .emptyBasket:
            return "Вы еще ничего не выбрали. Минимальная сумма заказа 1000₸"
        case .noInternet:
            return "Нет связи. Проверьте интернет соединение"
        case .upgrade:
            return "Мы добавили много новых функций и исправили некоторые баги, чтобы вам было удобнее пользоваться приложением"
        case .overload:
            return "В данный момент мы принимаем очень много заказов, пожалуйста попробуйте немного позднее"
        case .payment:
            return "Проводим оплату"
        case .profile:
            return "Вам необходимо авторизоваться, чтобы сделать заказ"
        }
    }

    var buttonTitle: String {
        switch self {
        case .orderHistory, .emptyBasket:
            return "Перейти в меню"
        case .noInternet, .overload:
            return "Попробовать еще раз"
        case .upgrade:
            return "Обновить приложение"
        case .payment:
            return "Отменить заказ"
        case .profile:
            return "Войти"
        }
    }

    var isActive: Bool {
        switch self {
        case .payment:
            return false
        case .orderHistory, .emptyBasket, .noInternet, .overload, .upgrade, .profile:
            return true
        }
    }
}

protocol AnimationContainerViewDelegate: AnyObject {
    func performAction()
}

final class AnimationContainerView: UIView {
    weak var delegate: AnimationContainerViewDelegate?

    private var currentAnimationType: AnimationType?

    private lazy var lottieAnimationView: AnimationView = {
        let view = AnimationView()
        view.frame = CGRect(x: 0, y: 0, width: 272, height: 200)
        view.loopMode = .loop
        return view
    }()

    private lazy var infoLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .mildBlue
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()

    private lazy var actionButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.cornerRadius = 10
        view.borderWidth = 1
        view.titleLabel?.textAlignment = .center
        return view
    }()

    init(delegate: AnimationContainerViewDelegate, animationType: AnimationType) {
        super.init(frame: .zero)
        self.delegate = delegate
        currentAnimationType = animationType
        configureViews(with: animationType)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews(with type: AnimationType) {
        setState(with: type)

        infoLabel.text = type.infoText

        actionButton.setTitle(type.buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)

        let animation = Animation.named("\(type)")
        lottieAnimationView.animation = animation
    }

    private func setState(with style: AnimationType) {
        actionButton.borderColor = style.isActive ? .kexRed : .mildBlue
        if style.isActive {
            actionButton.setTitleColor(.kexRed, for: .normal)
        } else {
            actionButton.setTitleColor(.mildBlue, for: .normal)
        }
    }

    private func layoutUI() {
        backgroundColor = .white

        infoLabel.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 48)
            $0.height.lessThanOrEqualTo(64)
        }

        actionButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 48)
            $0.height.equalTo(43)
        }

        let verticalStackView = UIStackView(arrangedSubviews: [lottieAnimationView, infoLabel, actionButton])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 32
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .center
        addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(UIScreen.main.bounds.height / 2.3)
        }

        lottieAnimationView.play()
    }

    @objc func performAction() {
        switch currentAnimationType {
        case .orderHistory, .emptyBasket, .noInternet, .upgrade, .overload, .payment, .profile:
            delegate?.performAction()
        default:
            print("Selection Error")
        }
    }
}
