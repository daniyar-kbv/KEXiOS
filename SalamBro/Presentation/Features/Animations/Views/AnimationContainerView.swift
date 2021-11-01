//
//  AnimationsView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/10/21.
//

import Lottie
import SnapKit
import UIKit

final class AnimationContainerView: UIView {
    let animationType: LottieAnimationModel

    private lazy var lottieAnimationView: AnimationView = {
        let view = AnimationView()
        view.contentMode = .scaleAspectFill
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

    lazy var actionButton: SBSubmitButton = {
        let view = SBSubmitButton(style: animationType.buttonStyle)
        view.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        return view
    }()

    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [lottieAnimationView, infoLabel])
        view.axis = .vertical
        view.spacing = 32
        view.distribution = .equalSpacing
        view.alignment = .center
        return view
    }()

    var action: (() -> Void)?

    init(animationType: LottieAnimationModel) {
        self.animationType = animationType

        super.init(frame: .zero)

        configureViews(with: animationType)
        layoutUI(with: animationType)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews(with type: LottieAnimationModel) {
        setState(with: type)

        configureLabel(with: type)
        actionButton.setTitle(type.getButtonTitle(), for: .normal)

        lottieAnimationView.animation = type.getAnimation()
        lottieAnimationView.loopMode = type.animationLoopMode
    }

    private func configureLabel(with type: LottieAnimationModel) {
        switch type {
        case .overload: setOverloadText()
        default: infoLabel.text = type.infoText
        }
    }

    private func setState(with style: LottieAnimationModel) {
        let textColor: UIColor = style.isActive ? .kexRed : .mildBlue
        actionButton.borderColor = textColor
        actionButton.setTitleColor(textColor, for: .normal)
    }

    private func layoutUI(with animationType: LottieAnimationModel) {
        backgroundColor = .arcticWhite

        lottieAnimationView.snp.makeConstraints {
            $0.width.equalTo(animationType.animationSize.width)
            $0.height.equalTo(animationType.animationSize.height)
        }

        infoLabel.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width - 48)
        }

        if animationType.withButton {
            verticalStackView.addArrangedSubview(actionButton)
            actionButton.snp.makeConstraints {
                $0.width.equalTo(UIScreen.main.bounds.width - 48)
                $0.height.equalTo(43)
            }
        }

        addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(UIScreen.main.bounds.height / 2.3)
        }
    }

    func animationPlay() {
        lottieAnimationView.play()
    }

    @objc private func performAction() {
        action?()
    }
}

// MARK: - Overload handling

extension AnimationContainerView {
    private func setOverloadText() {
        let attributedString = NSMutableAttributedString(
            string: LottieAnimationModel.overload.infoText,
            attributes: [
                .foregroundColor: UIColor.mildBlue,
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            ]
        )
        let linkRange = NSString(string: attributedString.string).range(of: Constants.websiteURL)
        attributedString.addAttributes(
            [
                .foregroundColor: UIColor.kexRed,
                .underlineStyle: NSUnderlineStyle.single,
                .underlineColor: UIColor.kexRed,
            ],
            range: linkRange
        )
        infoLabel.attributedText = attributedString

        let gesture = UITapGestureRecognizer(target: self, action: #selector(openWebSite))
        infoLabel.addGestureRecognizer(gesture)
    }

    @objc func openWebSite() {
        guard let url = URL(string: "https://\(Constants.websiteURL)"),
              UIApplication.shared.canOpenURL(url)
        else { return }

        UIApplication.shared.open(url, options: [:])
    }
}
