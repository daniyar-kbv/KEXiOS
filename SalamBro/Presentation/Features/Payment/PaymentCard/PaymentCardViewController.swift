//
//  PaymentCardViewController.swift
//  SalamBro
//
//  Created by Dan on 7/9/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class PaymentCardViewController: UIViewController {
    private let viewModel: PaymentCardViewModel
    private lazy var contentView: PaymentCardView = {
        let view = PaymentCardView()
        view.delegate = self
        return view
    }()

    let outputs = Output()

    init(viewModel: PaymentCardViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = SBLocalization.localized(key: PaymentText.PaymentCard.title)
        setBackButton { [weak self] in
            self?.outputs.close.accept(())
        }
    }
}

extension PaymentCardViewController: PaymentCardViewDelegate {
    func onSaveTap() {
        outputs.onDone.accept(())
    }
}

extension PaymentCardViewController {
    struct Output {
        let close = PublishRelay<Void>()
        let onDone = PublishRelay<Void>()
    }
}
