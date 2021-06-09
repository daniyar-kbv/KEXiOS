//
//  AnimationViewController.swift
//  SalamBro
//
//  Created by Meruyert Tastandiyeva on 6/9/21.
//

import Lottie
import SnapKit
import UIKit

class AnimationViewController: UIViewController {
    lazy var animationView: AnimationView = {
        let view = AnimationView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return view
    }()

    lazy var info: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .mildBlue
        view.contentMode = .center
        view.font = .systemFont(ofSize: 16, weight: .regular)
        return view
    }()

    lazy var button: UIButton = {
        let view = UIButton()
        view.tintColor = .kexRed
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        view.cornerRadius = 10
        view.borderWidth = 1
        view.borderColor = .kexRed
        view.contentMode = .center
        return view
    }()

    public var jsonName = ""
    public var infoText = ""
    public var buttonTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        setupViews()
        setupConstraints()
    }

    private func loadInfo() {
        info.text = infoText

        button.setTitle(buttonTitle, for: .normal)

        let animation = Animation.named(jsonName)
        animationView = AnimationView(animation: animation)
    }

    private func setupViews() {
        [animationView, info, button].forEach {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        animationView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().offset(124)
        }

        info.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(34)
            $0.left.right.equalToSuperview().offset(32)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(info.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().offset(24)
            $0.height.equalTo(43)
        }

        animationView.play()
    }
}
