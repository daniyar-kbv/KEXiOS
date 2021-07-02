//
//  AnimationController.swift
//  SalamBro
//
//  Created by Dan on 7/2/21.
//

import Foundation
import UIKit

final class AnimationController: UIViewController {
    private let animationType: LottieAnimationModel
    private lazy var contenView = AnimationContainerView(animationType: animationType)

    weak var delegate: AnimationContainerViewDelegate?

    init(animationType: LottieAnimationModel) {
        self.animationType = animationType

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = contenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contenView.animationPlay()
    }

    private func configActions() {
        contenView.actionButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }

    @objc private func performAction() {
        delegate?.performAction()
    }
}
