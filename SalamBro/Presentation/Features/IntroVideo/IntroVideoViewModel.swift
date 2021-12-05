//
//  FirstVideoViewModel.swift
//  SalamBro
//
//  Created by Dan on 11/1/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol IntroVideoViewModel: AnyObject {
    var output: IntroVideoViewModelImpl.Output { get }
    func getVideo()
}

final class IntroVideoViewModelImpl: IntroVideoViewModel {
    let output: Output

    init() {
        let hideButton = DefaultStorageImpl.sharedStorage.launchCount <= 3
        output = .init(hideButton: .init(value: hideButton))
    }

    func getVideo() {
        guard let path = Bundle.main.path(forResource: "intro_app", ofType: "mp4") else {
            debugPrint("intro_app.mp4 not found")
            return
        }
        output.videoURL.accept(URL(fileURLWithPath: path))
    }
}

extension IntroVideoViewModelImpl {
    struct Output {
        let hideButton: BehaviorRelay<Bool>
        let videoURL = PublishRelay<URL>()
    }
}
