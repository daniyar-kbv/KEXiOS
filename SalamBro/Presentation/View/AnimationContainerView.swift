//
//  AnimationsView.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/10/21.
//

import Lottie
import SnapKit
import UIKit

protocol AnimationContainerViewDelegate: AnyObject {
    func performAction(_ view: AnimationContainerView)
}

final class AnimationContainerView: UIView {
    weak var delegate: AnimationContainerViewDelegate?

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

    init(delegate: AnimationContainerViewDelegate?, animationType: LottieAnimationModel) {
        super.init(frame: .zero)
        self.delegate = delegate
        configureViews(with: animationType)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews(with type: LottieAnimationModel) {
        setState(with: type)

        infoLabel.text = type.infoText

        actionButton.setTitle(type.getButtonTitle(), for: .normal)
        actionButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)

        lottieAnimationView.animation = type.getAnimation()
    }

    private func setState(with style: LottieAnimationModel) {
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
        delegate?.performAction(self)
    }
}
