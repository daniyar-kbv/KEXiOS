//
//  FirstVideoController.swift
//  SalamBro
//
//  Created by Dan on 11/1/21.
//

import AVFoundation
import AVKit
import Foundation
import RxCocoa
import RxSwift
import UIKit

final class IntroVideoController: UIViewController {
    private(set) lazy var skipButton: SBSubmitButton = {
        let view = SBSubmitButton(style: .filledRed)
        view.setTitle(SBLocalization.localized(key: IntroVideoText.buttonTitle), for: .normal)
        return view
    }()

    private let disposeBag = DisposeBag()
    private let viewModel: IntroVideoViewModel

    let output = Output()

    init(viewModel: IntroVideoViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        bindActions()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.getVideo()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    private func layoutUI() {
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.height.equalTo(43)
        }
    }

    private func bindActions() {
        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.output.didFinish.accept(())
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.output
            .hideButton
            .bind(to: skipButton.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output
            .videoURL
            .subscribe(onNext: playVideo(with:))
            .disposed(by: disposeBag)
    }

    private func playVideo(with url: URL) {
        let player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.contentsGravity = .resizeAspectFill
        view.layer.insertSublayer(playerLayer, at: 0)

        player.play()
    }

    @objc private func playerDidFinishPlaying(note _: NSNotification) {
        output.didFinish.accept(())
    }
}

extension IntroVideoController {
    struct Output {
        let didFinish = PublishRelay<Void>()
    }
}
