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

    private func bindViewModel() {
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
        view.layer.addSublayer(playerLayer)

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
