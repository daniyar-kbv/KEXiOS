//
//  File.swift
//  SalamBro
//
//  Created by Dan on 7/6/21.
//

import Foundation
import Reachability
import RxCocoa
import RxSwift

protocol ReachabilityManager: AnyObject {
    var outputs: ReachabilityManagerImpl.Output { get }

    func start()
    func getReachability() -> Bool
}

final class ReachabilityManagerImpl: ReachabilityManager {
    private let reachability = try! Reachability()
    private lazy var lastReachability = getReachability()

    static let shared = ReachabilityManagerImpl()

    let outputs: Output = .init()

    private init() {}

    func start() {
        configActions()
        startNotifier()
    }

    func getReachability() -> Bool {
        return resolveReachability(connection: reachability.connection)
    }

    private func configActions() {
        reachability.whenReachable = { [weak self] reachability in
            self?.onReachabilityChange(self?.resolveReachability(connection: reachability.connection))
        }

        reachability.whenUnreachable = { [weak self] reachability in
            self?.onReachabilityChange(self?.resolveReachability(connection: reachability.connection))
        }
    }

    private func startNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    private func resolveReachability(connection: Reachability.Connection) -> Bool {
        let isReachable = [.cellular, .wifi].contains(connection)
        return isReachable
    }

    private func onReachabilityChange(_ isReachable: Bool?) {
        guard let isReachable = isReachable,
              lastReachability != isReachable else { return }
        lastReachability = isReachable
        outputs.connectionDidChange.accept(isReachable)
    }
}

extension ReachabilityManagerImpl {
    struct Output {
        let connectionDidChange = PublishRelay<Bool>()
    }
}
